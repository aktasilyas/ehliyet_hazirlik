import 'question_category.dart';

class QuestionEntity {
  const QuestionEntity({
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

  final String id;
  final QuestionCategory category;
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

  List<String> get options => [optionA, optionB, optionC, optionD];

  String optionLabel(int index) => switch (index) {
        0 => 'A',
        1 => 'B',
        2 => 'C',
        3 => 'D',
        _ => '',
      };

  String optionText(String label) => switch (label) {
        'A' => optionA,
        'B' => optionB,
        'C' => optionC,
        'D' => optionD,
        _ => '',
      };

  bool isCorrect(String selectedOption) =>
      selectedOption.toUpperCase() == correctOption.toUpperCase();
}
