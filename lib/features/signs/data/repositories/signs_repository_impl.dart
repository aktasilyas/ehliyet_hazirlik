import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/sign_entity.dart';
import '../../domain/repositories/signs_repository.dart';
import '../datasources/signs_local_datasource.dart';

class SignsRepositoryImpl implements SignsRepository {
  const SignsRepositoryImpl(this._dataSource);

  final SignsLocalDataSource _dataSource;

  @override
  Future<Either<Failure, List<SignEntity>>> getAllSigns() async {
    try {
      return Right(_dataSource.getAllSigns());
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<SignEntity>>> getSignsByCategory(
    SignCategory category,
  ) async {
    try {
      final signs =
          _dataSource.getAllSigns().where((s) => s.category == category).toList();
      return Right(signs);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, SignEntity>> getSignById(String id) async {
    try {
      final sign =
          _dataSource.getAllSigns().firstWhere((s) => s.id == id);
      return Right(sign);
    } catch (e) {
      return Left(CacheFailure('Levha bulunamadı: $id'));
    }
  }

  @override
  Future<Either<Failure, List<SignEntity>>> searchSigns(String query) async {
    try {
      final lower = query.toLowerCase();
      final signs = _dataSource.getAllSigns().where((s) {
        return s.name.toLowerCase().contains(lower) ||
            s.code.toLowerCase().contains(lower) ||
            s.description.toLowerCase().contains(lower);
      }).toList();
      return Right(signs);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
