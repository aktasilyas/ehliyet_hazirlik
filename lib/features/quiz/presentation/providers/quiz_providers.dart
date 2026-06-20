import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/question_local_datasource.dart';
import '../../data/datasources/question_remote_datasource.dart';
import '../../data/repositories/question_repository_impl.dart';
import '../../domain/entities/question_category.dart';
import '../../domain/entities/question_entity.dart';
import '../../domain/entities/quiz_session.dart';
import '../../domain/repositories/question_repository.dart';
import '../../domain/usecases/question_usecases.dart';

String _newSessionId() =>
    'session_${DateTime.now().microsecondsSinceEpoch}';

final questionLocalDataSourceProvider = Provider<QuestionLocalDataSource>(
  (ref) => MockQuestionLocalDataSource(),
);

final questionRemoteDataSourceProvider = Provider<QuestionRemoteDataSource>(
  (ref) => SupabaseQuestionRemoteDataSource(),
);

final questionRepositoryProvider = Provider<QuestionRepository>(
  (ref) => QuestionRepositoryImpl(
    remoteDataSource: ref.watch(questionRemoteDataSourceProvider),
    localDataSource: ref.watch(questionLocalDataSourceProvider),
  ),
);

final getMockExamQuestionsUseCaseProvider = Provider<GetMockExamQuestionsUseCase>(
  (ref) => GetMockExamQuestionsUseCase(ref.watch(questionRepositoryProvider)),
);

final getTopicQuestionsUseCaseProvider = Provider<GetTopicQuestionsUseCase>(
  (ref) => GetTopicQuestionsUseCase(ref.watch(questionRepositoryProvider)),
);

class QuizSessionController extends Notifier<QuizSession?> {
  @override
  QuizSession? build() => null;

  void startMockExam(List<QuestionEntity> questions) {
    state = QuizSession(
      sessionId: _newSessionId(),
      mode: QuizMode.mock,
      questions: questions,
      startedAt: DateTime.now(),
      endsAt: DateTime.now().add(mockExamDuration),
    );
  }

  void startTopicExam(
    QuestionCategory category,
    List<QuestionEntity> questions,
  ) {
    state = QuizSession(
      sessionId: _newSessionId(),
      mode: QuizMode.topic,
      topicCategory: category,
      questions: questions,
      startedAt: DateTime.now(),
    );
  }

  void selectAnswer(String questionId, String option) {
    final session = state;
    if (session == null || session.isCompleted) {
      return;
    }

    state = session.copyWith(
      answers: {...session.answers, questionId: option},
    );
  }

  void goToQuestion(int index) {
    final session = state;
    if (session == null) {
      return;
    }
    if (index < 0 || index >= session.questions.length) {
      return;
    }

    state = session.copyWith(currentIndex: index);
  }

  void nextQuestion() {
    final session = state;
    if (session == null || session.isLastQuestion) {
      return;
    }
    state = session.copyWith(currentIndex: session.currentIndex + 1);
  }

  void previousQuestion() {
    final session = state;
    if (session == null || session.currentIndex == 0) {
      return;
    }
    state = session.copyWith(currentIndex: session.currentIndex - 1);
  }

  QuizSession? completeSession() {
    final session = state;
    if (session == null) {
      return null;
    }

    final completed = session.copyWith(isCompleted: true);
    state = completed;
    return completed;
  }

  void clearSession() {
    state = null;
  }
}

final quizSessionControllerProvider =
    NotifierProvider<QuizSessionController, QuizSession?>(
  QuizSessionController.new,
);
