import '../../../quiz/domain/entities/question_entity.dart';

class AiExplanationResult {
  const AiExplanationResult({
    required this.explanation,
    required this.fromCache,
  });

  final String explanation;
  final bool fromCache;
}

abstract class AiExplainRepository {
  Future<AiExplanationResult> getExplanation({
    required String userId,
    required QuestionEntity question,
    required String selectedOption,
  });
}
