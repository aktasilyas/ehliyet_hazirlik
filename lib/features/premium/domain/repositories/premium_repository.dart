import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../entities/premium_entities.dart';

abstract interface class PremiumRepository {
  Future<Either<Failure, PremiumStatus>> getPremiumStatus();
  Future<Either<Failure, PremiumOffering>> getOfferings();
  Future<Either<Failure, PremiumStatus>> purchase(PremiumPackage package);
  Future<Either<Failure, PremiumStatus>> restorePurchases();
}
