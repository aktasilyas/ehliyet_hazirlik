import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../domain/entities/progress_entities.dart';
import '../providers/progress_providers.dart';
import '../providers/streak_provider.dart';

class StatsScreen extends ConsumerWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final user = ref.watch(authStateProvider).valueOrNull;
    final streakAsync = ref.watch(streakProvider);

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.statsTitle)),
        body: Center(child: Text(l10n.errorGeneric)),
      );
    }

    final progressAsync = ref.watch(userProgressProvider(user.id));

    return Scaffold(
      appBar: AppBar(title: Text(l10n.statsTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── Seri Kartı ────────────────────────────────────────────────
          streakAsync.when(
            loading: () => const SizedBox.shrink(),
            error: (_, _) => const SizedBox.shrink(),
            data: (streak) => _StreakCard(streak: streak),
          ),
          const SizedBox(height: 16),

          // ── Haftalık Aktivite ─────────────────────────────────────────
          streakAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, _) => const SizedBox.shrink(),
            data: (streak) => AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.statsWeeklyActivity,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  _WeeklyActivityBar(days: streak.weeklyStudyDays),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // ── Doğruluk Grafiği ──────────────────────────────────────────
          progressAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Text(e.toString()),
            data: (summary) => AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.statsAccuracyByCategory,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 180,
                    child: _AccuracyBarChart(summary: summary),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // ── Genel İstatistikler ───────────────────────────────────────
          progressAsync.when(
            loading: () => const SizedBox.shrink(),
            error: (_, _) => const SizedBox.shrink(),
            data: (summary) => AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.statsOverall,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  _StatRow(
                    label: l10n.progressTotalSessions,
                    value: '${summary.totalSessions}',
                    icon: Icons.quiz,
                  ),
                  _StatRow(
                    label: l10n.progressCorrect,
                    value:
                        '${summary.totalCorrect} / ${summary.totalQuestions}',
                    icon: Icons.check_circle,
                  ),
                  _StatRow(
                    label: l10n.progressAccuracy,
                    value:
                        '${(summary.overallAccuracy * 100).round()}%',
                    icon: Icons.percent,
                    valueColor: _accuracyColor(summary.overallAccuracy),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _accuracyColor(double accuracy) {
    if (accuracy >= 0.7) return Colors.green;
    if (accuracy >= 0.5) return Colors.orange;
    return Colors.red;
  }
}

class _StreakCard extends StatelessWidget {
  const _StreakCard({required this.streak});

  final StreakData streak;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      color: AppColors.primary,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _StreakStat(
              label: l10n.statsStreak,
              value: '🔥 ${streak.currentStreak}',
              color: Colors.white,
            ),
            Container(width: 1, height: 40, color: Colors.white24),
            _StreakStat(
              label: l10n.statsLongestStreak,
              value: '${streak.longestStreak}',
              color: Colors.white,
            ),
            Container(width: 1, height: 40, color: Colors.white24),
            _StreakStat(
              label: l10n.statsStudiedToday,
              value: streak.studiedToday ? '✅' : '❌',
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}

class _StreakStat extends StatelessWidget {
  const _StreakStat({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: color.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }
}

class _WeeklyActivityBar extends StatelessWidget {
  const _WeeklyActivityBar({required this.days});

  final List<bool> days;

  static const _dayLabels = ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(7, (i) {
        final studied = i < days.length && days[i];
        return Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: studied
                    ? AppColors.primary
                    : AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: studied
                  ? const Icon(Icons.check, color: Colors.white, size: 16)
                  : null,
            ),
            const SizedBox(height: 4),
            Text(
              _dayLabels[i],
              style: const TextStyle(fontSize: 10),
            ),
          ],
        );
      }),
    );
  }
}

class _AccuracyBarChart extends StatelessWidget {
  const _AccuracyBarChart({required this.summary});

  final UserProgressSummary summary;

  @override
  Widget build(BuildContext context) {
    const categories = [
      ('Trafik', AppColors.primary),
      ('İlk Yard.', AppColors.error),
      ('Motor', AppColors.warning),
      ('Çevre', AppColors.secondary),
    ];

    final entries = summary.byCategory.entries.toList();

    if (entries.isEmpty) {
      return Center(
        child: Text(AppLocalizations.of(context)!.progressNoData),
      );
    }

    final bars = entries.asMap().entries.map((entry) {
      final idx = entry.key;
      final stat = entry.value.value;
      final accuracy = stat.accuracy;
      final color = idx < categories.length
          ? categories[idx].$2
          : AppColors.primary;

      return BarChartGroupData(
        x: idx,
        barRods: [
          BarChartRodData(
            toY: accuracy * 100,
            color: color,
            width: 24,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
          ),
        ],
      );
    }).toList();

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 100,
        barGroups: bars,
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final idx = value.toInt();
                if (idx < categories.length) {
                  return Text(
                    categories[idx].$1,
                    style: const TextStyle(fontSize: 10),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          leftTitles: const AxisTitles(),
          topTitles: const AxisTitles(),
          rightTitles: const AxisTitles(),
        ),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({
    required this.label,
    required this.value,
    required this.icon,
    this.valueColor,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.onSurface),
          const SizedBox(width: 10),
          Expanded(child: Text(label)),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}
