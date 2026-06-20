import '../../../quiz/domain/entities/question_category.dart';

class CategoryStats {
  const CategoryStats({
    required this.answered,
    required this.correct,
  });

  final int answered;
  final int correct;

  double get accuracy => answered == 0 ? 0 : correct / answered;
}

class UserProgressSummary {
  const UserProgressSummary({
    required this.totalSessions,
    required this.totalQuestions,
    required this.totalCorrect,
    required this.byCategory,
    required this.wrongQuestionIds,
  });

  final int totalSessions;
  final int totalQuestions;
  final int totalCorrect;
  final Map<QuestionCategory, CategoryStats> byCategory;
  final List<String> wrongQuestionIds;

  double get overallAccuracy =>
      totalQuestions == 0 ? 0 : totalCorrect / totalQuestions;
}

class QuestionStatRecord {
  const QuestionStatRecord({
    required this.questionId,
    required this.timesAnswered,
    required this.timesCorrect,
    required this.lastAnsweredAt,
    this.nextReviewAt,
  });

  final String questionId;
  final int timesAnswered;
  final int timesCorrect;
  final DateTime lastAnsweredAt;
  final DateTime? nextReviewAt;

  bool get needsReview => timesCorrect < timesAnswered;
}
