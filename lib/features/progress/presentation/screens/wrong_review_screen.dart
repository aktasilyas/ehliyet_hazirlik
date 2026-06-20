import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../domain/entities/progress_entities.dart';
import '../providers/progress_providers.dart';

class WrongReviewScreen extends ConsumerWidget {
  const WrongReviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final user = ref.watch(authStateProvider).valueOrNull;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.wrongReviewTitle)),
        body: Center(child: Text(l10n.errorGeneric)),
      );
    }

    return FutureBuilder<Either<Failure, List<QuestionStatRecord>>>(
      future: ref.read(getWrongQuestionStatsUseCaseProvider).call(user.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Scaffold(
            appBar: AppBar(title: Text(l10n.wrongReviewTitle)),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        final result = snapshot.data;
        if (result == null) {
          return Scaffold(
            appBar: AppBar(title: Text(l10n.wrongReviewTitle)),
            body: Center(child: Text(l10n.errorGeneric)),
          );
        }

        return result.fold(
          (Failure failure) => Scaffold(
            appBar: AppBar(title: Text(l10n.wrongReviewTitle)),
            body: Center(child: Text(failure.message)),
          ),
          (List<QuestionStatRecord> stats) => _WrongReviewBody(stats: stats),
        );
      },
    );
  }
}

class _WrongReviewBody extends StatelessWidget {
  const _WrongReviewBody({required this.stats});

  final List<QuestionStatRecord> stats;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (stats.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.wrongReviewTitle)),
        body: Center(child: Text(l10n.wrongReviewEmpty)),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(l10n.wrongReviewTitle)),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: stats.length,
        separatorBuilder: (_, _) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final stat = stats[index];
          return Card(
            child: ListTile(
              title: Text(l10n.wrongReviewQuestion(stat.questionId)),
              subtitle: Text(
                l10n.wrongReviewStats(
                  stat.timesCorrect,
                  stat.timesAnswered,
                ),
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push(AppRoutes.quizTopic),
            ),
          );
        },
      ),
    );
  }
}
