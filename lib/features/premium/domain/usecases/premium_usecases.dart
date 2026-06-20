import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../entities/premium_entities.dart';
import '../repositories/premium_repository.dart';

class GetPremiumStatusUseCase {
  const GetPremiumStatusUseCase(this._repository);
  final PremiumRepository _repository;
  Future<Either<Failure, PremiumStatus>> call() =>
      _repository.getPremiumStatus();
}

class GetOfferingsUseCase {
  const GetOfferingsUseCase(this._repository);
  final PremiumRepository _repository;
  Future<Either<Failure, PremiumOffering>> call() => _repository.getOfferings();
}

class PurchaseUseCase {
  const PurchaseUseCase(this._repository);
  final PremiumRepository _repository;
  Future<Either<Failure, PremiumStatus>> call(PremiumPackage package) =>
      _repository.purchase(package);
}

class RestorePurchasesUseCase {
  const RestorePurchasesUseCase(this._repository);
  final PremiumRepository _repository;
  Future<Either<Failure, PremiumStatus>> call() =>
      _repository.restorePurchases();
}
