import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../../../quiz/domain/entities/quiz_session.dart';
import '../entities/progress_entities.dart';

abstract class ProgressRepository {
  Future<Either<Failure, Unit>> saveQuizSession(
    String userId,
    QuizSession session,
  );

  Future<Either<Failure, UserProgressSummary>> getUserProgress(String userId);

  Future<Either<Failure, List<QuestionStatRecord>>> getWrongQuestionStats(
    String userId,
  );
}
