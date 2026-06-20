import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

class QuizTimerBar extends StatelessWidget {
  const QuizTimerBar({
    required this.remaining,
    required this.total,
    super.key,
  });

  final Duration remaining;
  final Duration total;

  @override
  Widget build(BuildContext context) {
    final progress = total.inSeconds == 0
        ? 0.0
        : remaining.inSeconds / total.inSeconds;
    final minutes = remaining.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = remaining.inSeconds.remainder(60).toString().padLeft(2, '0');
    final isLow = remaining <= const Duration(minutes: 5);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Kalan Süre',
              style: Theme.of(context).textTheme.labelSmall,
            ),
            Text(
              '$minutes:$seconds',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: isLow ? AppColors.error : AppColors.onBackground,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: progress.clamp(0, 1),
            minHeight: 8,
            backgroundColor: AppColors.background,
            color: isLow ? AppColors.error : AppColors.primary,
          ),
        ),
      ],
    );
  }
}
