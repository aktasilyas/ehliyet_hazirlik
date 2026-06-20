import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:http/http.dart' as http;

import '../../../../core/constants/env.dart';
import '../../../quiz/domain/entities/question_entity.dart';
import '../../domain/repositories/ai_explain_repository.dart';

abstract class AiCacheDataSource {
  Future<String?> getCachedExplanation(String questionId);

  Future<void> cacheExplanation(String questionId, String explanation);

  Future<int> getRemainingDailyQuota(String userId);

  Future<void> incrementDailyQuota(String userId);
}

class FirestoreAiCacheDataSource implements AiCacheDataSource {
  FirestoreAiCacheDataSource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  static bool get isConfigured =>
      !Env.skipFirebaseInit && Firebase.apps.isNotEmpty;

  @override
  Future<String?> getCachedExplanation(String questionId) async {
    if (!isConfigured) {
      return null;
    }

    final doc =
        await _firestore.collection('ai_explanations').doc(questionId).get();
    return doc.data()?['explanation'] as String?;
  }

  @override
  Future<void> cacheExplanation(String questionId, String explanation) async {
    if (!isConfigured) {
      return;
    }

    await _firestore.collection('ai_explanations').doc(questionId).set({
      'explanation': explanation,
      'generatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<int> getRemainingDailyQuota(String userId) async {
    if (!isConfigured) {
      return 10;
    }

    final doc = await _firestore.collection('users').doc(userId).get();
    final data = doc.data();
    if (data == null) {
      return 10;
    }

    final lastDate = (data['lastAiQueryDate'] as Timestamp?)?.toDate();
    final today = DateTime.now();
    if (lastDate == null ||
        lastDate.year != today.year ||
        lastDate.month != today.month ||
        lastDate.day != today.day) {
      return 10;
    }

    final used = (data['aiQueriesUsedToday'] as num?)?.toInt() ?? 0;
    return (10 - used).clamp(0, 10);
  }

  @override
  Future<void> incrementDailyQuota(String userId) async {
    if (!isConfigured) {
      return;
    }

    final userRef = _firestore.collection('users').doc(userId);
    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(userRef);
      final data = snapshot.data() ?? {};
      final today = DateTime.now();
      final lastDate = (data['lastAiQueryDate'] as Timestamp?)?.toDate();
      var used = (data['aiQueriesUsedToday'] as num?)?.toInt() ?? 0;

      if (lastDate == null ||
          lastDate.year != today.year ||
          lastDate.month != today.month ||
          lastDate.day != today.day) {
        used = 0;
      }

      transaction.set(
        userRef,
        {
          'aiQueriesUsedToday': used + 1,
          'lastAiQueryDate': Timestamp.fromDate(today),
        },
        SetOptions(merge: true),
      );
    });
  }
}

class InMemoryAiCacheDataSource implements AiCacheDataSource {
  final Map<String, String> _cache = {};
  final Map<String, int> _dailyUsage = {};

  @override
  Future<String?> getCachedExplanation(String questionId) async {
    return _cache[questionId];
  }

  @override
  Future<void> cacheExplanation(String questionId, String explanation) async {
    _cache[questionId] = explanation;
  }

  @override
  Future<int> getRemainingDailyQuota(String userId) async {
    final used = _dailyUsage[userId] ?? 0;
    return (10 - used).clamp(0, 10);
  }

  @override
  Future<void> incrementDailyQuota(String userId) async {
    _dailyUsage[userId] = (_dailyUsage[userId] ?? 0) + 1;
  }
}

class ClaudeAiRemoteDataSource {
  ClaudeAiRemoteDataSource({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<String> generateExplanation({
    required QuestionEntity question,
    required String selectedOption,
  }) async {
    if (!Env.isAnthropicConfigured) {
      return question.explanation ??
          'Doğru cevap ${question.correctOption}: '
              '${question.optionText(question.correctOption)}';
    }

    final prompt = '''
Soru: ${question.questionText}
A: ${question.optionA}
B: ${question.optionB}
C: ${question.optionC}
D: ${question.optionD}
Kullanıcının cevabı: $selectedOption
Doğru cevap: ${question.correctOption}

Öğrenci dostu, kısa ve Türkçe bir açıklama yaz. Neden doğru cevap ${question.correctOption} olduğunu anlat.
''';

    final response = await _client.post(
      Uri.parse('https://api.anthropic.com/v1/messages'),
      headers: {
        'x-api-key': Env.anthropicApiKey,
        'anthropic-version': '2023-06-01',
        'content-type': 'application/json',
      },
      body: jsonEncode({
        'model': 'claude-3-5-haiku-latest',
        'max_tokens': 300,
        'messages': [
          {'role': 'user', 'content': prompt},
        ],
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Claude API hatası: ${response.statusCode}');
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final content = body['content'] as List<dynamic>;
    final text = (content.first as Map<String, dynamic>)['text'] as String;
    return text.trim();
  }
}

class AiExplainRepositoryImpl implements AiExplainRepository {
  AiExplainRepositoryImpl({
    required AiCacheDataSource cacheDataSource,
    required ClaudeAiRemoteDataSource remoteDataSource,
  })  : _cacheDataSource = cacheDataSource,
        _remoteDataSource = remoteDataSource;

  final AiCacheDataSource _cacheDataSource;
  final ClaudeAiRemoteDataSource _remoteDataSource;

  @override
  Future<AiExplanationResult> getExplanation({
    required String userId,
    required QuestionEntity question,
    required String selectedOption,
  }) async {
    final cached = await _cacheDataSource.getCachedExplanation(question.id);
    if (cached != null) {
      return AiExplanationResult(explanation: cached, fromCache: true);
    }

    final remaining = await _cacheDataSource.getRemainingDailyQuota(userId);
    if (remaining <= 0) {
      throw Exception('Günlük AI açıklama hakkın doldu (10/10).');
    }

    final explanation = await _remoteDataSource.generateExplanation(
      question: question,
      selectedOption: selectedOption,
    );

    await _cacheDataSource.cacheExplanation(question.id, explanation);
    await _cacheDataSource.incrementDailyQuota(userId);

    return AiExplanationResult(explanation: explanation, fromCache: false);
  }
}
