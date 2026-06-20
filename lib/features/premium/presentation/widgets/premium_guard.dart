import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../l10n/app_localizations.dart';
import '../providers/premium_providers.dart';

/// İçeriği premium durumuna göre kilitler veya gösterir.
class PremiumGuard extends ConsumerWidget {
  const PremiumGuard({
    required this.child,
    this.lockedPlaceholder,
    super.key,
  });

  final Widget child;
  final Widget? lockedPlaceholder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final premiumAsync = ref.watch(premiumStatusProvider);

    return premiumAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, _) => child,
      data: (status) {
        if (status.isActive) return child;
        return lockedPlaceholder ?? _DefaultLockedWidget(child: child);
      },
    );
  }
}

class _DefaultLockedWidget extends StatelessWidget {
  const _DefaultLockedWidget({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Stack(
      children: [
        Opacity(opacity: 0.3, child: IgnorePointer(child: child)),
        Positioned.fill(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => context.push(AppRoutes.premium),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.amber.withValues(alpha: 0.4),
                            blurRadius: 16,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.lock,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      l10n.premiumLocked,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.premiumUnlockCta,
                      style: const TextStyle(color: Colors.amber),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
