import 'package:purchases_flutter/purchases_flutter.dart';

import '../../domain/entities/premium_entities.dart';

abstract interface class PremiumDataSource {
  Future<PremiumStatus> getStatus();
  Future<PremiumOffering> getOfferings();
  Future<PremiumStatus> purchase(PremiumPackage package);
  Future<PremiumStatus> restorePurchases();
}

/// Dev/test modunda gerçek RevenueCat çağrısı yapmaz; free döner.
/// Production'da [RevenueCatPremiumDataSource] kullanılır.
class DevPremiumDataSource implements PremiumDataSource {
  const DevPremiumDataSource();

  @override
  Future<PremiumStatus> getStatus() async => const PremiumStatus.free();

  @override
  Future<PremiumOffering> getOfferings() async => const PremiumOffering(
        monthly: PremiumPackage(
          plan: PremiumPlan.monthly,
          identifier: 'monthly_premium',
          priceString: '₺79,99/ay',
          priceAmountMicros: 79990000,
        ),
        yearly: PremiumPackage(
          plan: PremiumPlan.yearly,
          identifier: 'yearly_premium',
          priceString: '₺599,99/yıl',
          priceAmountMicros: 599990000,
        ),
      );

  @override
  Future<PremiumStatus> purchase(PremiumPackage package) async {
    // Simülasyon: her zaman başarılı (dev modunda test için)
    return PremiumStatus(
      isActive: true,
      activeUntil: DateTime.now().add(
        package.plan == PremiumPlan.monthly
            ? const Duration(days: 30)
            : const Duration(days: 365),
      ),
      plan: package.plan,
    );
  }

  @override
  Future<PremiumStatus> restorePurchases() async => const PremiumStatus.free();
}

class RevenueCatPremiumDataSource implements PremiumDataSource {
  const RevenueCatPremiumDataSource();

  @override
  Future<PremiumStatus> getStatus() async {
    try {
      final info = await Purchases.getCustomerInfo();
      final active = info.entitlements.active.containsKey('premium');
      if (!active) return const PremiumStatus.free();
      return PremiumStatus(
        isActive: true,
        activeUntil:
            DateTime.tryParse(info.latestExpirationDate ?? '') ??
                DateTime.now().add(const Duration(days: 30)),
      );
    } catch (_) {
      return const PremiumStatus.free();
    }
  }

  @override
  Future<PremiumOffering> getOfferings() async {
    final offerings = await Purchases.getOfferings();
    final current = offerings.current;
    if (current == null) {
      return const PremiumOffering(
        monthly: PremiumPackage(
          plan: PremiumPlan.monthly,
          identifier: 'monthly_premium',
          priceString: '₺79,99/ay',
          priceAmountMicros: 79990000,
        ),
        yearly: PremiumPackage(
          plan: PremiumPlan.yearly,
          identifier: 'yearly_premium',
          priceString: '₺599,99/yıl',
          priceAmountMicros: 599990000,
        ),
      );
    }

    final monthlyPkg = current.monthly;
    final annualPkg = current.annual;

    return PremiumOffering(
      monthly: PremiumPackage(
        plan: PremiumPlan.monthly,
        identifier: monthlyPkg?.identifier ?? 'monthly_premium',
        priceString: monthlyPkg?.storeProduct.priceString ?? '₺79,99/ay',
        priceAmountMicros:
            ((monthlyPkg?.storeProduct.price ?? 79.99) * 1000000).round(),
      ),
      yearly: PremiumPackage(
        plan: PremiumPlan.yearly,
        identifier: annualPkg?.identifier ?? 'yearly_premium',
        priceString: annualPkg?.storeProduct.priceString ?? '₺599,99/yıl',
        priceAmountMicros:
            ((annualPkg?.storeProduct.price ?? 599.99) * 1000000).round(),
      ),
    );
  }

  @override
  Future<PremiumStatus> purchase(PremiumPackage package) async {
    final offerings = await Purchases.getOfferings();
    final rcPkg = offerings.current?.availablePackages.firstWhere(
      (p) => p.identifier == package.identifier,
      orElse: () => offerings.current!.availablePackages.first,
    );
    if (rcPkg == null) {
      throw Exception('Paket bulunamadı: ${package.identifier}');
    }
    final info = await Purchases.purchasePackage(rcPkg);
    final active = info.entitlements.active.containsKey('premium');
    return PremiumStatus(
      isActive: active,
      activeUntil: active
          ? DateTime.tryParse(info.latestExpirationDate ?? '')
          : null,
      plan: active ? package.plan : null,
    );
  }

  @override
  Future<PremiumStatus> restorePurchases() async {
    final info = await Purchases.restorePurchases();
    final active = info.entitlements.active.containsKey('premium');
    return PremiumStatus(
      isActive: active,
      activeUntil: active
          ? DateTime.tryParse(info.latestExpirationDate ?? '')
          : null,
    );
  }
}
