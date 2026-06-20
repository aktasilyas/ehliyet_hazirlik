import '../../domain/entities/question_category.dart';
import '../../domain/entities/question_entity.dart';

/// Geliştirme ve test için yerel soru bankası.
/// Supabase bağlantısı yoksa veya hata olursa fallback olarak kullanılır.
List<QuestionEntity> buildMockQuestionBank() {
  final questions = <QuestionEntity>[];

  for (final category in QuestionCategory.values) {
    for (var i = 1; i <= 30; i++) {
      questions.add(
        QuestionEntity(
          id: '${category.apiValue}_$i',
          category: category,
          difficulty: (i % 3) + 1,
          year: i <= 8 ? 2018 + (i % 8) : null,
          questionText: '${category.displayName} sorusu $i: '
              'Aşağıdakilerden hangisi doğrudur?',
          optionA: 'Seçenek A — ${category.displayName}',
          optionB: 'Seçenek B — ${category.displayName}',
          optionC: 'Seçenek C — ${category.displayName}',
          optionD: 'Seçenek D — ${category.displayName}',
          correctOption: ['A', 'B', 'C', 'D'][i % 4],
          explanation: '${category.displayName} konusu için örnek açıklama.',
        ),
      );
    }
  }

  return questions;
}
