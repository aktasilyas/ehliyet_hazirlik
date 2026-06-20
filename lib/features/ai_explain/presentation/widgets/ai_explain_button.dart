import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../quiz/domain/entities/question_entity.dart';
import '../providers/ai_explain_providers.dart';

class AiExplainButton extends ConsumerStatefulWidget {
  const AiExplainButton({
    required this.question,
    required this.selectedOption,
    super.key,
  });

  final QuestionEntity question;
  final String selectedOption;

  @override
  ConsumerState<AiExplainButton> createState() => _AiExplainButtonState();
}

class _AiExplainButtonState extends ConsumerState<AiExplainButton> {
  bool _isLoading = false;

  Future<void> _showExplanation() async {
    final l10n = AppLocalizations.of(context)!;
    final user = ref.read(authStateProvider).valueOrNull;
    if (user == null) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final result =
          await ref.read(aiExplainRepositoryProvider).getExplanation(
                userId: user.id,
                question: widget.question,
                selectedOption: widget.selectedOption,
              );

      if (!mounted) {
        return;
      }

      await showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.aiExplainTitle,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                if (result.fromCache)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      l10n.aiExplainCached,
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ),
                const SizedBox(height: 12),
                Text(result.explanation),
              ],
            ),
          );
        },
      );
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return OutlinedButton.icon(
      onPressed: _isLoading ? null : _showExplanation,
      icon: _isLoading
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.auto_awesome),
      label: Text(l10n.aiExplainButton),
    );
  }
}
