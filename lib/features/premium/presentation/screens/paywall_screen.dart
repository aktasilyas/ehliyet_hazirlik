import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/premium_entities.dart';
import '../providers/premium_providers.dart';

class PaywallScreen extends ConsumerWidget {
  const PaywallScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final offeringsAsync = ref.watch(offeringsProvider);
    final premiumAsync = ref.watch(premiumStatusProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: DecoratedBox(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF1565C0), Color(0xFF0D47A1)],
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 48),
                      const SizedBox(height: 8),
                      Text(
                        l10n.premiumTitle,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        l10n.premiumSubtitle,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _FeatureList(l10n: l10n),
                const SizedBox(height: 24),
                offeringsAsync.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Text(e.toString()),
                  data: (PremiumOffering? offering) {
                    if (offering == null) return const SizedBox.shrink();
                    return _PlanSelector(offering: offering);
                  },
                ),
                const SizedBox(height: 16),
                premiumAsync.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Text(
                    e.toString(),
                    style: const TextStyle(color: Colors.red),
                  ),
                  data: (status) {
                    if (status.isActive) {
                      return Card(
                        color: Colors.green.withValues(alpha: 0.1),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              const Icon(Icons.check_circle,
                                  color: Colors.green),
                              const SizedBox(width: 12),
                              Text(
                                l10n.premiumActive,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () =>
                      ref.read(premiumStatusProvider.notifier).restore(),
                  child: Text(l10n.premiumRestore),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureList extends StatelessWidget {
  const _FeatureList({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final features = [
      (Icons.all_inclusive, l10n.premiumFeatureUnlimited),
      (Icons.psychology, l10n.premiumFeatureAi),
      (Icons.bar_chart, l10n.premiumFeatureStats),
      (Icons.traffic, l10n.premiumFeatureSigns),
      (Icons.notifications_active, l10n.premiumFeatureNotifications),
    ];

    return Column(
      children: features
          .map(
            (f) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(f.$1, color: AppColors.primary, size: 18),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: Text(f.$2)),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}

class _PlanSelector extends ConsumerStatefulWidget {
  const _PlanSelector({required this.offering});

  final PremiumOffering offering;

  @override
  ConsumerState<_PlanSelector> createState() => _PlanSelectorState();
}

class _PlanSelectorState extends ConsumerState<_PlanSelector> {
  PremiumPlan _selected = PremiumPlan.yearly;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _PlanCard(
                package: widget.offering.monthly,
                isSelected: _selected == PremiumPlan.monthly,
                onTap: () => setState(() => _selected = PremiumPlan.monthly),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  _PlanCard(
                    package: widget.offering.yearly,
                    isSelected: _selected == PremiumPlan.yearly,
                    onTap: () => setState(() => _selected = PremiumPlan.yearly),
                  ),
                  Positioned(
                    top: -10,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          l10n.premiumBestValue,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              final package = _selected == PremiumPlan.monthly
                  ? widget.offering.monthly
                  : widget.offering.yearly;
              ref.read(premiumStatusProvider.notifier).purchase(package);
            },
            child: Text(
              l10n.premiumSubscribe,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({
    required this.package,
    required this.isSelected,
    required this.onTap,
  });

  final PremiumPackage package;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.05)
              : null,
        ),
        child: Column(
          children: [
            Text(
              package.plan == PremiumPlan.monthly ? 'Aylık' : 'Yıllık',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isSelected ? AppColors.primary : null,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              package.priceString,
              style: TextStyle(
                fontSize: 13,
                color: isSelected ? AppColors.primary : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
