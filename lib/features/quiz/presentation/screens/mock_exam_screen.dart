import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/question_category.dart';
import '../providers/quiz_providers.dart';

class MockExamScreen extends ConsumerStatefulWidget {
  const MockExamScreen({super.key});

  @override
  ConsumerState<MockExamScreen> createState() => _MockExamScreenState();
}

class _MockExamScreenState extends ConsumerState<MockExamScreen> {
  bool _isLoading = false;

  Future<void> _startExam() async {
    setState(() => _isLoading = true);

    final result = await ref.read(getMockExamQuestionsUseCaseProvider).call();

    if (!mounted) {
      return;
    }

    setState(() => _isLoading = false);

    if (!mounted) {
      return;
    }

    await result.fold(
      (Failure failure) async {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(failure.message)),
        );
      },
      (questions) async {
        ref.read(quizSessionControllerProvider.notifier).startMockExam(questions);
        await context.push(AppRoutes.quizSession);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.mockExamTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            l10n.mockExamDescription,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 24),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _InfoRow(
                  icon: Icons.quiz,
                  label: l10n.mockExamQuestionCount,
                  value: '$mockExamQuestionCount',
                ),
                const SizedBox(height: 12),
                _InfoRow(
                  icon: Icons.timer,
                  label: l10n.mockExamDuration,
                  value: l10n.mockExamDurationValue,
                ),
                const SizedBox(height: 12),
                _InfoRow(
                  icon: Icons.category,
                  label: l10n.mockExamDistribution,
                  value: l10n.mockExamDistributionValue,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _isLoading ? null : _startExam,
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(l10n.mockExamStart),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary),
        const SizedBox(width: 12),
        Expanded(child: Text(label)),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ],
    );
  }
}
