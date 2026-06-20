import 'package:ehliyet_hazirlik/features/ai_explain/data/repositories/ai_explain_repository_impl.dart';
import 'package:ehliyet_hazirlik/features/quiz/domain/entities/question_category.dart';
import 'package:ehliyet_hazirlik/features/quiz/domain/entities/question_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('AI açıklama statik fallback döner', () async {
    final repository = AiExplainRepositoryImpl(
      cacheDataSource: InMemoryAiCacheDataSource(),
      remoteDataSource: ClaudeAiRemoteDataSource(),
    );

    const question = QuestionEntity(
      id: 'q1',
      category: QuestionCategory.traffic,
      difficulty: 1,
      questionText: 'Test sorusu',
      optionA: 'A',
      optionB: 'B',
      optionC: 'C',
      optionD: 'D',
      correctOption: 'A',
      explanation: 'Statik açıklama metni',
    );

    final result = await repository.getExplanation(
      userId: 'user1',
      question: question,
      selectedOption: 'B',
    );

    expect(result.explanation, contains('Statik açıklama'));
    expect(result.fromCache, isFalse);

    final cached = await repository.getExplanation(
      userId: 'user1',
      question: question,
      selectedOption: 'B',
    );
    expect(cached.fromCache, isTrue);
  });
}
