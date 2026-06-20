import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../providers/practice_providers.dart';

class PracticeTabScreen extends ConsumerWidget {
  const PracticeTabScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final topicsAsync = ref.watch(practiceTopicsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.practiceTitle)),
      body: topicsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text(error.toString())),
        data: (topics) => ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: topics.length,
          separatorBuilder: (_, _) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final topic = topics[index];
            return Card(
              child: ListTile(
                leading: Icon(_iconFromName(topic.iconName)),
                title: Text(topic.title),
                subtitle: Text(topic.description),
                trailing: const Icon(Icons.play_circle_outline),
                onTap: () => context.push('/practice/${topic.id}'),
              ),
            );
          },
        ),
      ),
    );
  }

  IconData _iconFromName(String name) {
    return switch (name) {
      'local_parking' => Icons.local_parking,
      'terrain' => Icons.terrain,
      'turn_slight_right' => Icons.turn_slight_right,
      'u_turn_left' => Icons.u_turn_left,
      _ => Icons.directions_car,
    };
  }
}
