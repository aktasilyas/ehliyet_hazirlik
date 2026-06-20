import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/question_category.dart';
import '../providers/quiz_providers.dart';

class TopicSelectScreen extends ConsumerStatefulWidget {
  const TopicSelectScreen({super.key});

  @override
  ConsumerState<TopicSelectScreen> createState() => _TopicSelectScreenState();
}

class _TopicSelectScreenState extends ConsumerState<TopicSelectScreen> {
  QuestionCategory? _loadingCategory;

  Future<void> _startTopic(QuestionCategory category) async {
    setState(() => _loadingCategory = category);

    final result =
        await ref.read(getTopicQuestionsUseCaseProvider).call(category);

    if (!mounted) {
      return;
    }

    setState(() => _loadingCategory = null);

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
        ref
            .read(quizSessionControllerProvider.notifier)
            .startTopicExam(category, questions);
        await context.push(AppRoutes.quizSession);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.topicSelectTitle)),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: QuestionCategory.values.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final category = QuestionCategory.values[index];
          final isLoading = _loadingCategory == category;

          return Card(
            child: ListTile(
              leading: Icon(_iconForCategory(category)),
              title: Text(category.displayName),
              subtitle: Text(l10n.topicQuestionCount),
              trailing: isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.chevron_right),
              onTap: isLoading ? null : () => _startTopic(category),
            ),
          );
        },
      ),
    );
  }

  IconData _iconForCategory(QuestionCategory category) {
    return switch (category) {
      QuestionCategory.traffic => Icons.traffic,
      QuestionCategory.firstAid => Icons.medical_services_outlined,
      QuestionCategory.engine => Icons.build_outlined,
      QuestionCategory.environment => Icons.eco_outlined,
    };
  }
}
