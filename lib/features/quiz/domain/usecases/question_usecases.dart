import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../entities/question_category.dart';
import '../entities/question_entity.dart';
import '../repositories/question_repository.dart';

class GetMockExamQuestionsUseCase {
  const GetMockExamQuestionsUseCase(this._repository);

  final QuestionRepository _repository;

  Future<Either<Failure, List<QuestionEntity>>> call() {
    return _repository.getMockExamQuestions();
  }
}

class GetTopicQuestionsUseCase {
  const GetTopicQuestionsUseCase(this._repository);

  final QuestionRepository _repository;

  Future<Either<Failure, List<QuestionEntity>>> call(
    QuestionCategory category, {
    int limit = 20,
  }) {
    return _repository.getQuestionsByCategory(category, limit: limit);
  }
}

class GetPastExamQuestionsUseCase {
  const GetPastExamQuestionsUseCase(this._repository);

  final QuestionRepository _repository;

  Future<Either<Failure, List<QuestionEntity>>> call(int year) {
    return _repository.getQuestionsByYear(year);
  }
}
