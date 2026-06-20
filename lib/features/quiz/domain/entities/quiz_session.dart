import 'question_category.dart';
import 'question_entity.dart';

class QuizSession {
  const QuizSession({
    required this.sessionId,
    required this.mode,
    required this.questions,
    required this.startedAt,
    this.endsAt,
    this.topicCategory,
    this.currentIndex = 0,
    this.answers = const {},
    this.isCompleted = false,
  });

  final String sessionId;
  final QuizMode mode;
  final List<QuestionEntity> questions;
  final DateTime startedAt;
  final DateTime? endsAt;
  final QuestionCategory? topicCategory;
  final int currentIndex;
  final Map<String, String> answers;
  final bool isCompleted;

  QuestionEntity? get currentQuestion {
    if (currentIndex < 0 || currentIndex >= questions.length) {
      return null;
    }
    return questions[currentIndex];
  }

  int get answeredCount =>
      answers.entries.where((entry) => entry.value.isNotEmpty).length;

  int get correctCount {
    var count = 0;
    for (final question in questions) {
      final answer = answers[question.id];
      if (answer != null && question.isCorrect(answer)) {
        count++;
      }
    }
    return count;
  }

  Duration? get remainingTime {
    if (endsAt == null) {
      return null;
    }
    final diff = endsAt!.difference(DateTime.now());
    return diff.isNegative ? Duration.zero : diff;
  }

  double get progress =>
      questions.isEmpty ? 0 : (currentIndex + 1) / questions.length;

  bool get isLastQuestion => currentIndex >= questions.length - 1;

  QuizSession copyWith({
    String? sessionId,
    QuizMode? mode,
    List<QuestionEntity>? questions,
    DateTime? startedAt,
    DateTime? endsAt,
    QuestionCategory? topicCategory,
    int? currentIndex,
    Map<String, String>? answers,
    bool? isCompleted,
  }) {
    return QuizSession(
      sessionId: sessionId ?? this.sessionId,
      mode: mode ?? this.mode,
      questions: questions ?? this.questions,
      startedAt: startedAt ?? this.startedAt,
      endsAt: endsAt ?? this.endsAt,
      topicCategory: topicCategory ?? this.topicCategory,
      currentIndex: currentIndex ?? this.currentIndex,
      answers: answers ?? this.answers,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
