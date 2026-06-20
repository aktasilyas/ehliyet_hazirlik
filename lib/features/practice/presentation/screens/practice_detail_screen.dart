import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../../core/constants/app_theme.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/practice_topic.dart';
import '../providers/practice_providers.dart';

class PracticeDetailScreen extends ConsumerStatefulWidget {
  const PracticeDetailScreen({required this.topicId, super.key});

  final String topicId;

  @override
  ConsumerState<PracticeDetailScreen> createState() =>
      _PracticeDetailScreenState();
}

class _PracticeDetailScreenState extends ConsumerState<PracticeDetailScreen> {
  YoutubePlayerController? _controller;

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final topicAsync = ref.watch(practiceTopicProvider(widget.topicId));

    return topicAsync.when(
      loading: () => Scaffold(
        appBar: AppBar(title: Text(l10n.practiceTitle)),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Scaffold(
        appBar: AppBar(title: Text(l10n.practiceTitle)),
        body: Center(child: Text(error.toString())),
      ),
      data: (PracticeTopic? topic) {
        if (topic == null) {
          return Scaffold(
            appBar: AppBar(title: Text(l10n.practiceTitle)),
            body: Center(child: Text(l10n.errorGeneric)),
          );
        }

        _controller ??= YoutubePlayerController(
          initialVideoId: topic.videoId,
          flags: const YoutubePlayerFlags(autoPlay: false),
        );

        return YoutubePlayerBuilder(
          player: YoutubePlayer(controller: _controller!),
          builder: (context, player) {
            return Scaffold(
              appBar: AppBar(title: Text(topic.title)),
              body: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  ClipRRect(
                    borderRadius:
                        BorderRadius.circular(AppTheme.cardRadius),
                    child: player,
                  ),
                  const SizedBox(height: 16),
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.practiceExamRequirement,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(topic.examRequirement),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  AppCard(
                    child: Text(topic.description),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
