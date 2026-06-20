import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import '../../../../core/constants/env.dart';
import '../../../quiz/domain/entities/quiz_session.dart';
import '../../domain/entities/progress_entities.dart';

abstract class ProgressRemoteDataSource {
  Future<void> saveSession(String userId, QuizSession session);

  Future<UserProgressSummary> getSummary(String userId);

  Future<List<QuestionStatRecord>> getWrongStats(String userId);
}

class FirestoreProgressRemoteDataSource implements ProgressRemoteDataSource {
  FirestoreProgressRemoteDataSource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  static bool get isConfigured =>
      !Env.skipFirebaseInit && Firebase.apps.isNotEmpty;

  @override
  Future<void> saveSession(String userId, QuizSession session) async {
    final userRef = _firestore.collection('users').doc(userId);
    final sessionRef = userRef.collection('sessions').doc(session.sessionId);

    await sessionRef.set({
      'startedAt': Timestamp.fromDate(session.startedAt),
      'completedAt': Timestamp.fromDate(DateTime.now()),
      'mode': session.mode.name,
      'category': session.topicCategory?.apiValue,
      'totalQuestions': session.questions.length,
      'correctCount': session.correctCount,
      'answers': session.answers,
    });

    for (final question in session.questions) {
      final answer = session.answers[question.id];
      if (answer == null) {
        continue;
      }

      final statRef =
          userRef.collection('question_stats').doc(question.id);
      final isCorrect = question.isCorrect(answer);

      await _firestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(statRef);
        final currentAnswered =
            (snapshot.data()?['timesAnswered'] as num?)?.toInt() ?? 0;
        final currentCorrect =
            (snapshot.data()?['timesCorrect'] as num?)?.toInt() ?? 0;

        transaction.set(statRef, {
          'timesAnswered': currentAnswered + 1,
          'timesCorrect': currentCorrect + (isCorrect ? 1 : 0),
          'lastAnsweredAt': Timestamp.fromDate(DateTime.now()),
          'nextReviewAt': isCorrect
              ? null
              : Timestamp.fromDate(DateTime.now().add(const Duration(days: 1))),
        });
      });
    }

    await userRef.set(
      {
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }

  @override
  Future<UserProgressSummary> getSummary(String userId) async {
    final sessionsSnap = await _firestore
        .collection('users')
        .doc(userId)
        .collection('sessions')
        .get();

    final statsSnap = await _firestore
        .collection('users')
        .doc(userId)
        .collection('question_stats')
        .get();

    final wrongQuestionIds = statsSnap.docs
        .where((doc) {
          final data = doc.data();
          final answered = (data['timesAnswered'] as num?)?.toInt() ?? 0;
          final correct = (data['timesCorrect'] as num?)?.toInt() ?? 0;
          return answered > correct;
        })
        .map((doc) => doc.id)
        .toList();

    var totalQuestions = 0;
    var totalCorrect = 0;

    for (final doc in sessionsSnap.docs) {
      final data = doc.data();
      totalQuestions += (data['totalQuestions'] as num?)?.toInt() ?? 0;
      totalCorrect += (data['correctCount'] as num?)?.toInt() ?? 0;
    }

    return UserProgressSummary(
      totalSessions: sessionsSnap.docs.length,
      totalQuestions: totalQuestions,
      totalCorrect: totalCorrect,
      byCategory: const {},
      wrongQuestionIds: wrongQuestionIds,
    );
  }

  @override
  Future<List<QuestionStatRecord>> getWrongStats(String userId) async {
    final statsSnap = await _firestore
        .collection('users')
        .doc(userId)
        .collection('question_stats')
        .get();

    final records = <QuestionStatRecord>[];
    for (final doc in statsSnap.docs) {
      final data = doc.data();
      final answered = (data['timesAnswered'] as num?)?.toInt() ?? 0;
      final correct = (data['timesCorrect'] as num?)?.toInt() ?? 0;
      if (answered <= correct) {
        continue;
      }

      records.add(
        QuestionStatRecord(
          questionId: doc.id,
          timesAnswered: answered,
          timesCorrect: correct,
          lastAnsweredAt:
              (data['lastAnsweredAt'] as Timestamp?)?.toDate() ??
                  DateTime.now(),
          nextReviewAt: (data['nextReviewAt'] as Timestamp?)?.toDate(),
        ),
      );
    }

    records.sort(
      (a, b) => b.lastAnsweredAt.compareTo(a.lastAnsweredAt),
    );
    return records;
  }
}
