import '../../domain/entities/question_category.dart';
import '../../domain/entities/question_entity.dart';
import 'mock_questions.dart';

abstract class QuestionLocalDataSource {
  List<QuestionEntity> getAll();

  List<QuestionEntity> getByCategory(QuestionCategory category);

  List<QuestionEntity> getByYear(int year);
}

class MockQuestionLocalDataSource implements QuestionLocalDataSource {
  MockQuestionLocalDataSource({List<QuestionEntity>? questions})
      : _questions = questions ?? buildMockQuestionBank();

  final List<QuestionEntity> _questions;

  @override
  List<QuestionEntity> getAll() => List.unmodifiable(_questions);

  @override
  List<QuestionEntity> getByCategory(QuestionCategory category) {
    return _questions.where((q) => q.category == category).toList();
  }

  @override
  List<QuestionEntity> getByYear(int year) {
    return _questions.where((q) => q.year == year).toList();
  }
}
