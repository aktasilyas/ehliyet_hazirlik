import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../entities/sign_entity.dart';

abstract interface class SignsRepository {
  Future<Either<Failure, List<SignEntity>>> getAllSigns();
  Future<Either<Failure, List<SignEntity>>> getSignsByCategory(SignCategory category);
  Future<Either<Failure, SignEntity>> getSignById(String id);
  Future<Either<Failure, List<SignEntity>>> searchSigns(String query);
}
