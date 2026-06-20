import '../../../quiz/domain/entities/question_category.dart';
import '../../../quiz/domain/entities/quiz_session.dart';
import '../../domain/entities/progress_entities.dart';

abstract class ProgressLocalDataSource {
  Future<void> saveSession(String userId, QuizSession session);

  Future<UserProgressSummary> getSummary(String userId);

  Future<List<QuestionStatRecord>> getWrongStats(String userId);
}

class InMemoryProgressLocalDataSource implements ProgressLocalDataSource {
  final Map<String, List<QuizSession>> _sessions = {};
  final Map<String, Map<String, QuestionStatRecord>> _stats = {};

  @override
  Future<void> saveSession(String userId, QuizSession session) async {
    _sessions.putIfAbsent(userId, () => []).add(session);

    final userStats = _stats.putIfAbsent(userId, () => {});
    for (final question in session.questions) {
      final answer = session.answers[question.id];
      if (answer == null) {
        continue;
      }

      final existing = userStats[question.id];
      final isCorrect = question.isCorrect(answer);
      userStats[question.id] = QuestionStatRecord(
        questionId: question.id,
        timesAnswered: (existing?.timesAnswered ?? 0) + 1,
        timesCorrect: (existing?.timesCorrect ?? 0) + (isCorrect ? 1 : 0),
        lastAnsweredAt: DateTime.now(),
        nextReviewAt: isCorrect
            ? null
            : DateTime.now().add(const Duration(days: 1)),
      );
    }
  }

  @override
  Future<UserProgressSummary> getSummary(String userId) async {
    final sessions = _sessions[userId] ?? [];
    final stats = _stats[userId] ?? {};

    final byCategory = <QuestionCategory, CategoryStats>{};
    for (final category in QuestionCategory.values) {
      byCategory[category] = const CategoryStats(answered: 0, correct: 0);
    }

    var totalQuestions = 0;
    var totalCorrect = 0;

    for (final session in sessions) {
      totalQuestions += session.questions.length;
      totalCorrect += session.correctCount;

      for (final question in session.questions) {
        final answer = session.answers[question.id];
        if (answer == null) {
          continue;
        }
        final current = byCategory[question.category]!;
        final isCorrect = question.isCorrect(answer);
        byCategory[question.category] = CategoryStats(
          answered: current.answered + 1,
          correct: current.correct + (isCorrect ? 1 : 0),
        );
      }
    }

    final wrongQuestionIds = stats.entries
        .where((entry) => entry.value.needsReview)
        .map((entry) => entry.key)
        .toList();

    return UserProgressSummary(
      totalSessions: sessions.length,
      totalQuestions: totalQuestions,
      totalCorrect: totalCorrect,
      byCategory: byCategory,
      wrongQuestionIds: wrongQuestionIds,
    );
  }

  @override
  Future<List<QuestionStatRecord>> getWrongStats(String userId) async {
    final stats = _stats[userId] ?? {};
    return stats.values.where((stat) => stat.needsReview).toList()
      ..sort(
        (a, b) => b.lastAnsweredAt.compareTo(a.lastAnsweredAt),
      );
  }
}
