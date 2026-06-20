import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../l10n/app_localizations.dart';

class QuizTabScreen extends StatelessWidget {
  const QuizTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.quizTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            leading: const Icon(Icons.timer),
            title: Text(l10n.homeMockExam),
            subtitle: Text(l10n.mockExamSubtitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(AppRoutes.quizMock),
          ),
          ListTile(
            leading: const Icon(Icons.category),
            title: Text(l10n.homeTopicStudy),
            subtitle: Text(l10n.topicSelectSubtitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(AppRoutes.quizTopic),
          ),
        ],
      ),
    );
  }
}
