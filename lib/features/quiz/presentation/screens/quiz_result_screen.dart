import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/question_category.dart';
import '../providers/quiz_providers.dart';

class QuizResultScreen extends ConsumerWidget {
  const QuizResultScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final session = ref.watch(quizSessionControllerProvider);

    if (session == null || !session.isCompleted) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.quizResultTitle)),
        body: Center(child: Text(l10n.quizNoSession)),
      );
    }

    final total = session.questions.length;
    final correct = session.correctCount;
    final wrong = total - correct;
    final percentage = total == 0 ? 0 : ((correct / total) * 100).round();
    final passed = percentage >= 70;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.quizResultTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AppCard(
            child: Column(
              children: [
                Icon(
                  passed ? Icons.emoji_events : Icons.refresh,
                  size: 64,
                  color: passed ? AppColors.secondary : AppColors.warning,
                ),
                const SizedBox(height: 16),
                Text(
                  passed ? l10n.quizResultPassed : l10n.quizResultFailed,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.quizResultScore(correct, total, percentage),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          AppCard(
            child: Column(
              children: [
                _ResultRow(
                  label: l10n.quizResultCorrect,
                  value: '$correct',
                  color: AppColors.secondary,
                ),
                const Divider(height: 24),
                _ResultRow(
                  label: l10n.quizResultWrong,
                  value: '$wrong',
                  color: AppColors.error,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.quizResultByCategory,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          ...QuestionCategory.values.map((category) {
            final categoryQuestions = session.questions
                .where((question) => question.category == category)
                .toList();
            if (categoryQuestions.isEmpty) {
              return const SizedBox.shrink();
            }

            final categoryCorrect = categoryQuestions
                .where(
                  (question) =>
                      session.answers[question.id] != null &&
                      question.isCorrect(session.answers[question.id]!),
                )
                .length;

            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: AppCard(
                child: Row(
                  children: [
                    Expanded(child: Text(category.displayName)),
                    Text('$categoryCorrect / ${categoryQuestions.length}'),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              ref.read(quizSessionControllerProvider.notifier).clearSession();
              context.go(AppRoutes.home);
            },
            child: Text(l10n.quizBackHome),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: () {
              ref.read(quizSessionControllerProvider.notifier).clearSession();
              context.go(AppRoutes.quizMock);
            },
            child: Text(l10n.quizRetry),
          ),
        ],
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  const _ResultRow({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }
}
