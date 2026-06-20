import '../../domain/entities/question_category.dart';
import '../../domain/entities/question_entity.dart';

class QuestionModel {
  const QuestionModel({
    required this.id,
    required this.category,
    required this.difficulty,
    required this.questionText,
    required this.optionA,
    required this.optionB,
    required this.optionC,
    required this.optionD,
    required this.correctOption,
    this.year,
    this.explanation,
    this.imageUrl,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json['id'] as String,
      category: json['category'] as String,
      difficulty: json['difficulty'] as int,
      year: json['year'] as int?,
      questionText: json['question_text'] as String,
      optionA: json['option_a'] as String,
      optionB: json['option_b'] as String,
      optionC: json['option_c'] as String,
      optionD: json['option_d'] as String,
      correctOption: json['correct_option'] as String,
      explanation: json['explanation'] as String?,
      imageUrl: json['image_url'] as String?,
    );
  }

  final String id;
  final String category;
  final int difficulty;
  final int? year;
  final String questionText;
  final String optionA;
  final String optionB;
  final String optionC;
  final String optionD;
  final String correctOption;
  final String? explanation;
  final String? imageUrl;

  QuestionEntity toEntity() {
    return QuestionEntity(
      id: id,
      category: QuestionCategory.fromApi(category),
      difficulty: difficulty,
      year: year,
      questionText: questionText,
      optionA: optionA,
      optionB: optionB,
      optionC: optionC,
      optionD: optionD,
      correctOption: correctOption,
      explanation: explanation,
      imageUrl: imageUrl,
    );
  }
}
