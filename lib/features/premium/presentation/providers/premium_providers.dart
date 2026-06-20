import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/revenuecat_datasource.dart';
import '../../data/repositories/premium_repository_impl.dart';
import '../../domain/entities/premium_entities.dart';
import '../../domain/repositories/premium_repository.dart';
import '../../domain/usecases/premium_usecases.dart';

final premiumDataSourceProvider = Provider<PremiumDataSource>((ref) {
  // Production'da RevenueCatPremiumDataSource() kullan
  return const DevPremiumDataSource();
});

final premiumRepositoryProvider = Provider<PremiumRepository>((ref) {
  return PremiumRepositoryImpl(ref.read(premiumDataSourceProvider));
});

final getPremiumStatusUseCaseProvider =
    Provider<GetPremiumStatusUseCase>((ref) {
  return GetPremiumStatusUseCase(ref.read(premiumRepositoryProvider));
});

final getOfferingsUseCaseProvider = Provider<GetOfferingsUseCase>((ref) {
  return GetOfferingsUseCase(ref.read(premiumRepositoryProvider));
});

final purchaseUseCaseProvider = Provider<PurchaseUseCase>((ref) {
  return PurchaseUseCase(ref.read(premiumRepositoryProvider));
});

final restorePurchasesUseCaseProvider =
    Provider<RestorePurchasesUseCase>((ref) {
  return RestorePurchasesUseCase(ref.read(premiumRepositoryProvider));
});

/// Aktif premium durumunu tutar. Satın alım sonrası invalidate edilir.
final premiumStatusProvider =
    AsyncNotifierProvider<PremiumStatusNotifier, PremiumStatus>(
  PremiumStatusNotifier.new,
);

class PremiumStatusNotifier extends AsyncNotifier<PremiumStatus> {
  @override
  Future<PremiumStatus> build() async {
    final result = await ref.read(getPremiumStatusUseCaseProvider).call();
    return result.fold((_) => const PremiumStatus.free(), (s) => s);
  }

  Future<void> purchase(PremiumPackage package) async {
    state = const AsyncLoading();
    final result = await ref.read(purchaseUseCaseProvider).call(package);
    state = result.fold(
      (failure) => AsyncError(failure.message, StackTrace.current),
      AsyncData.new,
    );
  }

  Future<void> restore() async {
    state = const AsyncLoading();
    final result = await ref.read(restorePurchasesUseCaseProvider).call();
    state = result.fold(
      (failure) => AsyncError(failure.message, StackTrace.current),
      AsyncData.new,
    );
  }
}

final offeringsProvider = FutureProvider<PremiumOffering?>((ref) async {
  final result = await ref.read(getOfferingsUseCaseProvider).call();
  return result.fold((_) => null, (o) => o);
});
