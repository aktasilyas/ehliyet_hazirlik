import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../entities/question_category.dart';
import '../entities/question_entity.dart';

abstract class QuestionRepository {
  Future<Either<Failure, List<QuestionEntity>>> getQuestionsByCategory(
    QuestionCategory category, {
    int? limit,
  });

  Future<Either<Failure, List<QuestionEntity>>> getMockExamQuestions();

  Future<Either<Failure, List<QuestionEntity>>> getQuestionsByYear(int year);
}
