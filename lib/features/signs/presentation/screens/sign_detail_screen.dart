import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../ai_explain/presentation/widgets/ai_explain_button.dart';
import '../../../quiz/domain/entities/question_category.dart';
import '../../../quiz/domain/entities/question_entity.dart';
import '../../domain/entities/sign_entity.dart';
import '../providers/signs_providers.dart';

class SignDetailScreen extends ConsumerWidget {
  const SignDetailScreen({required this.signId, super.key});

  final String signId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final signAsync = ref.watch(signByIdProvider(signId));

    return signAsync.when(
      loading: () => Scaffold(
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(e.toString())),
      ),
      data: (SignEntity? sign) {
        if (sign == null) {
          return Scaffold(
            appBar: AppBar(title: Text(l10n.signsTitle)),
            body: Center(child: Text(l10n.errorGeneric)),
          );
        }
        return _SignDetailBody(sign: sign);
      },
    );
  }
}

class _SignDetailBody extends StatelessWidget {
  const _SignDetailBody({required this.sign});

  final SignEntity sign;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final color = _categoryColor(sign.category);

    return Scaffold(
      appBar: AppBar(
        title: Text(sign.code),
        backgroundColor: color.withValues(alpha: 0.08),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
                border: Border.all(color: color, width: 2),
              ),
              alignment: Alignment.center,
              child: Text(
                String.fromCharCode(sign.iconCode),
                style: const TextStyle(fontSize: 56),
              ),
            ),
            const SizedBox(height: 16),
            if (sign.isPremium)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star, size: 14, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text(
                      l10n.premiumBadge,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.amber,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 8),
            Text(
              sign.name,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Chip(
              label: Text(
                '${sign.category.iconEmoji} ${sign.category.displayName}',
              ),
              backgroundColor: color.withValues(alpha: 0.1),
              side: BorderSide(color: color),
            ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.signsDetailDescription,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: AppColors.onSurface,
                            letterSpacing: 0.5,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      sign.description,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            _SignAiExplainButton(sign: sign),
          ],
        ),
      ),
    );
  }

  Color _categoryColor(SignCategory category) => switch (category) {
        SignCategory.warning => Colors.orange,
        SignCategory.prohibition => Colors.red,
        SignCategory.obligation => Colors.blue,
        SignCategory.informational => Colors.green,
        SignCategory.priority => Colors.purple,
      };
}

class _SignAiExplainButton extends StatelessWidget {
  const _SignAiExplainButton({required this.sign});

  final SignEntity sign;

  @override
  Widget build(BuildContext context) {
    final question = QuestionEntity(
      id: 'sign_${sign.id}',
      category: QuestionCategory.traffic,
      difficulty: 1,
      questionText: sign.name,
      optionA: sign.description,
      optionB: '-',
      optionC: '-',
      optionD: '-',
      correctOption: 'A',
    );

    return AiExplainButton(
      question: question,
      selectedOption: 'A',
    );
  }
}
