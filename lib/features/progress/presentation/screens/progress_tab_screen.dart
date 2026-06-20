import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../quiz/domain/entities/question_category.dart';
import '../../domain/entities/progress_entities.dart';
import '../providers/progress_providers.dart';

class ProgressTabScreen extends ConsumerWidget {
  const ProgressTabScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final user = ref.watch(authStateProvider).valueOrNull;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.progressTitle)),
        body: Center(child: Text(l10n.errorGeneric)),
      );
    }

    final progressAsync = ref.watch(userProgressProvider(user.id));

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.progressTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.replay),
            onPressed: () => context.push(AppRoutes.wrongReview),
          ),
        ],
      ),
      body: progressAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text(error.toString())),
        data: (summary) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.progressOverview,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  _StatTile(
                    label: l10n.progressTotalSessions,
                    value: '${summary.totalSessions}',
                  ),
                  _StatTile(
                    label: l10n.progressAccuracy,
                    value: '${(summary.overallAccuracy * 100).round()}%',
                  ),
                  _StatTile(
                    label: l10n.progressCorrect,
                    value: '${summary.totalCorrect}/${summary.totalQuestions}',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.progressByCategory,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 200,
              child: _CategoryChart(summary: summary),
            ),
            const SizedBox(height: 16),
            if (summary.wrongQuestionIds.isNotEmpty)
              ElevatedButton(
                onPressed: () => context.push(AppRoutes.wrongReview),
                child: Text(
                  l10n.progressWrongReview(summary.wrongQuestionIds.length),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}

class _CategoryChart extends StatelessWidget {
  const _CategoryChart({required this.summary});

  final UserProgressSummary summary;

  @override
  Widget build(BuildContext context) {
    final entries = QuestionCategory.values
        .map((category) {
          final stats = summary.byCategory[category];
          if (stats == null || stats.answered == 0) {
            return null;
          }
          return PieChartSectionData(
            value: stats.answered.toDouble(),
            title: category.displayName,
            color: _colorForCategory(category),
            radius: 50,
            titleStyle: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          );
        })
        .whereType<PieChartSectionData>()
        .toList();

    if (entries.isEmpty) {
      return Center(
        child: Text(AppLocalizations.of(context)!.progressNoData),
      );
    }

    return PieChart(
      PieChartData(
        sections: entries,
        sectionsSpace: 2,
        centerSpaceRadius: 24,
      ),
    );
  }

  Color _colorForCategory(QuestionCategory category) {
    return switch (category) {
      QuestionCategory.traffic => AppColors.primary,
      QuestionCategory.firstAid => AppColors.error,
      QuestionCategory.engine => AppColors.warning,
      QuestionCategory.environment => AppColors.secondary,
    };
  }
}
