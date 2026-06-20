import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/premium_entities.dart';
import '../../domain/repositories/premium_repository.dart';
import '../datasources/revenuecat_datasource.dart';

class PremiumRepositoryImpl implements PremiumRepository {
  const PremiumRepositoryImpl(this._dataSource);

  final PremiumDataSource _dataSource;

  @override
  Future<Either<Failure, PremiumStatus>> getPremiumStatus() async {
    try {
      return Right(await _dataSource.getStatus());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PremiumOffering>> getOfferings() async {
    try {
      return Right(await _dataSource.getOfferings());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PremiumStatus>> purchase(
    PremiumPackage package,
  ) async {
    try {
      return Right(await _dataSource.purchase(package));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PremiumStatus>> restorePurchases() async {
    try {
      return Right(await _dataSource.restorePurchases());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
