import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../entities/sign_entity.dart';
import '../repositories/signs_repository.dart';

class GetAllSignsUseCase {
  const GetAllSignsUseCase(this._repository);
  final SignsRepository _repository;
  Future<Either<Failure, List<SignEntity>>> call() => _repository.getAllSigns();
}

class GetSignsByCategoryUseCase {
  const GetSignsByCategoryUseCase(this._repository);
  final SignsRepository _repository;
  Future<Either<Failure, List<SignEntity>>> call(SignCategory category) =>
      _repository.getSignsByCategory(category);
}

class GetSignByIdUseCase {
  const GetSignByIdUseCase(this._repository);
  final SignsRepository _repository;
  Future<Either<Failure, SignEntity>> call(String id) =>
      _repository.getSignById(id);
}

class SearchSignsUseCase {
  const SearchSignsUseCase(this._repository);
  final SignsRepository _repository;
  Future<Either<Failure, List<SignEntity>>> call(String query) =>
      _repository.searchSigns(query);
}
