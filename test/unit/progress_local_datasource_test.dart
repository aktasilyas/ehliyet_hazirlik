import 'package:ehliyet_hazirlik/features/progress/data/datasources/progress_local_datasource.dart';
import 'package:ehliyet_hazirlik/features/quiz/domain/entities/question_category.dart';
import 'package:ehliyet_hazirlik/features/quiz/domain/entities/question_entity.dart';
import 'package:ehliyet_hazirlik/features/quiz/domain/entities/quiz_session.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late InMemoryProgressLocalDataSource dataSource;

  setUp(() {
    dataSource = InMemoryProgressLocalDataSource();
  });

  test('sınav kaydı özet istatistiklerini günceller', () async {
    const userId = 'user1';
    final session = QuizSession(
      sessionId: 's1',
      mode: QuizMode.mock,
      startedAt: DateTime(2026),
      isCompleted: true,
      questions: [
        const QuestionEntity(
          id: 'q1',
          category: QuestionCategory.traffic,
          difficulty: 1,
          questionText: 'Soru 1',
          optionA: 'A',
          optionB: 'B',
          optionC: 'C',
          optionD: 'D',
          correctOption: 'A',
        ),
        const QuestionEntity(
          id: 'q2',
          category: QuestionCategory.traffic,
          difficulty: 1,
          questionText: 'Soru 2',
          optionA: 'A',
          optionB: 'B',
          optionC: 'C',
          optionD: 'D',
          correctOption: 'B',
        ),
      ],
      answers: {'q1': 'A', 'q2': 'A'},
    );

    await dataSource.saveSession(userId, session);
    final summary = await dataSource.getSummary(userId);

    expect(summary.totalSessions, 1);
    expect(summary.totalQuestions, 2);
    expect(summary.totalCorrect, 1);
    expect(summary.wrongQuestionIds, contains('q2'));
  });
}
