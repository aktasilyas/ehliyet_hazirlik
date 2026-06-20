import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../../../quiz/domain/entities/quiz_session.dart';
import '../entities/progress_entities.dart';
import '../repositories/progress_repository.dart';

class SaveQuizSessionUseCase {
  const SaveQuizSessionUseCase(this._repository);

  final ProgressRepository _repository;

  Future<Either<Failure, Unit>> call(String userId, QuizSession session) {
    return _repository.saveQuizSession(userId, session);
  }
}

class GetUserProgressUseCase {
  const GetUserProgressUseCase(this._repository);

  final ProgressRepository _repository;

  Future<Either<Failure, UserProgressSummary>> call(String userId) {
    return _repository.getUserProgress(userId);
  }
}

class GetWrongQuestionStatsUseCase {
  const GetWrongQuestionStatsUseCase(this._repository);

  final ProgressRepository _repository;

  Future<Either<Failure, List<QuestionStatRecord>>> call(String userId) {
    return _repository.getWrongQuestionStats(userId);
  }
}
