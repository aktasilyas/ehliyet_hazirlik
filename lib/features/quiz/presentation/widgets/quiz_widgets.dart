import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_theme.dart';
import '../../domain/entities/question_entity.dart';

class QuizOptionTile extends StatelessWidget {
  const QuizOptionTile({
    required this.label,
    required this.text,
    required this.isSelected,
    required this.onTap,
    this.isRevealed = false,
    this.isCorrectOption = false,
    super.key,
  });

  final String label;
  final String text;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isRevealed;
  final bool isCorrectOption;

  @override
  Widget build(BuildContext context) {
    Color? fillColor;
    Color borderColor = Theme.of(context).colorScheme.outline;

    if (isRevealed && isCorrectOption) {
      fillColor = AppColors.secondary.withValues(alpha: 0.12);
      borderColor = AppColors.secondary;
    } else if (isRevealed && isSelected && !isCorrectOption) {
      fillColor = AppColors.error.withValues(alpha: 0.12);
      borderColor = AppColors.error;
    } else if (isSelected) {
      fillColor = AppColors.primary.withValues(alpha: 0.12);
      borderColor = AppColors.primary;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: isRevealed ? null : onTap,
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: fillColor,
            borderRadius: BorderRadius.circular(AppTheme.cardRadius),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: borderColor.withValues(alpha: 0.15),
                child: Text(
                  label,
                  style: TextStyle(
                    color: borderColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  text,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class QuestionCard extends StatelessWidget {
  const QuestionCard({
    required this.question,
    required this.questionNumber,
    required this.totalQuestions,
    super.key,
  });

  final QuestionEntity question;
  final int questionNumber;
  final int totalQuestions;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Soru $questionNumber / $totalQuestions',
              style: Theme.of(context).textTheme.labelSmall,
            ),
            const SizedBox(height: 12),
            Text(
              question.questionText,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
