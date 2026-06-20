import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/question_category.dart';
import '../providers/quiz_providers.dart';
import '../widgets/quiz_timer_bar.dart';
import '../widgets/quiz_widgets.dart';

class QuizSessionScreen extends ConsumerStatefulWidget {
  const QuizSessionScreen({super.key});

  @override
  ConsumerState<QuizSessionScreen> createState() => _QuizSessionScreenState();
}

class _QuizSessionScreenState extends ConsumerState<QuizSessionScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final session = ref.read(quizSessionControllerProvider);
      if (session == null) {
        return;
      }

      if (session.endsAt != null &&
          session.remainingTime == Duration.zero &&
          !session.isCompleted) {
        _finishExam(autoFinished: true);
        return;
      }

      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _finishExam({bool autoFinished = false}) async {
    final l10n = AppLocalizations.of(context)!;
    final session = ref.read(quizSessionControllerProvider);
    if (session == null) {
      return;
    }

    if (!autoFinished) {
      final unanswered = session.questions.length - session.answeredCount;
      if (unanswered > 0) {
        final shouldFinish = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(l10n.quizFinishTitle),
            content: Text(l10n.quizFinishMessage(unanswered)),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(l10n.quizContinue),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(l10n.quizFinish),
              ),
            ],
          ),
        );

        if (shouldFinish != true || !mounted) {
          return;
        }
      }
    }

    ref.read(quizSessionControllerProvider.notifier).completeSession();
    if (!mounted) {
      return;
    }
    context.go(AppRoutes.quizResult);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final session = ref.watch(quizSessionControllerProvider);

    if (session == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.quizSessionTitle)),
        body: Center(child: Text(l10n.quizNoSession)),
      );
    }

    final question = session.currentQuestion!;
    final selected = session.answers[question.id];
    final notifier = ref.read(quizSessionControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.quizSessionTitle),
        actions: [
          TextButton(
            onPressed: _finishExam,
            child: Text(l10n.quizFinish),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (session.endsAt != null)
            QuizTimerBar(
              remaining: session.remainingTime ?? Duration.zero,
              total: mockExamDuration,
            ),
          if (session.endsAt != null) const SizedBox(height: 16),
          LinearProgressIndicator(value: session.progress),
          const SizedBox(height: 16),
          QuestionCard(
            question: question,
            questionNumber: session.currentIndex + 1,
            totalQuestions: session.questions.length,
          ),
          const SizedBox(height: 16),
          for (var i = 0; i < 4; i++)
            QuizOptionTile(
              label: question.optionLabel(i),
              text: question.options[i],
              isSelected: selected == question.optionLabel(i),
              onTap: () => notifier.selectAnswer(
                question.id,
                question.optionLabel(i),
              ),
            ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: session.currentIndex == 0
                      ? null
                      : notifier.previousQuestion,
                  child: Text(l10n.quizPrevious),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: session.isLastQuestion
                      ? _finishExam
                      : notifier.nextQuestion,
                  child: Text(
                    session.isLastQuestion ? l10n.quizFinish : l10n.quizNext,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
