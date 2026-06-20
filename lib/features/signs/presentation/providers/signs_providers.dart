import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/signs_local_datasource.dart';
import '../../data/repositories/signs_repository_impl.dart';
import '../../domain/entities/sign_entity.dart';
import '../../domain/repositories/signs_repository.dart';
import '../../domain/usecases/signs_usecases.dart';

final signsRepositoryProvider = Provider<SignsRepository>((ref) {
  return const SignsRepositoryImpl(HardcodedSignsDataSource());
});

final getAllSignsUseCaseProvider = Provider<GetAllSignsUseCase>((ref) {
  return GetAllSignsUseCase(ref.read(signsRepositoryProvider));
});

final getSignsByCategoryUseCaseProvider =
    Provider<GetSignsByCategoryUseCase>((ref) {
  return GetSignsByCategoryUseCase(ref.read(signsRepositoryProvider));
});

final getSignByIdUseCaseProvider = Provider<GetSignByIdUseCase>((ref) {
  return GetSignByIdUseCase(ref.read(signsRepositoryProvider));
});

final searchSignsUseCaseProvider = Provider<SearchSignsUseCase>((ref) {
  return SearchSignsUseCase(ref.read(signsRepositoryProvider));
});

final allSignsProvider = FutureProvider<List<SignEntity>>((ref) async {
  final result = await ref.read(getAllSignsUseCaseProvider).call();
  return result.fold((f) => [], (signs) => signs);
});

final signsByCategoryProvider =
    FutureProvider.family<List<SignEntity>, SignCategory>((ref, category) async {
  final result =
      await ref.read(getSignsByCategoryUseCaseProvider).call(category);
  return result.fold((f) => [], (signs) => signs);
});

final signByIdProvider =
    FutureProvider.family<SignEntity?, String>((ref, id) async {
  final result = await ref.read(getSignByIdUseCaseProvider).call(id);
  return result.fold((f) => null, (sign) => sign);
});

final signsSearchQueryProvider = StateProvider<String>((ref) => '');

final filteredSignsProvider = FutureProvider<List<SignEntity>>((ref) async {
  final query = ref.watch(signsSearchQueryProvider);
  if (query.isEmpty) {
    return ref.watch(allSignsProvider.future);
  }
  final result =
      await ref.read(searchSignsUseCaseProvider).call(query);
  return result.fold((f) => [], (signs) => signs);
});

final selectedSignCategoryProvider =
    StateProvider<SignCategory?>((ref) => null);
