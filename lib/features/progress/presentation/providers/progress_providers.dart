import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/failures.dart';
import '../../data/datasources/progress_local_datasource.dart';
import '../../data/datasources/progress_remote_datasource.dart';
import '../../data/repositories/progress_repository_impl.dart';
import '../../domain/entities/progress_entities.dart';
import '../../domain/repositories/progress_repository.dart';
import '../../domain/usecases/progress_usecases.dart';

final progressLocalDataSourceProvider = Provider<ProgressLocalDataSource>(
  (ref) => InMemoryProgressLocalDataSource(),
);

final progressRemoteDataSourceProvider = Provider<ProgressRemoteDataSource>(
  (ref) => FirestoreProgressRemoteDataSource(),
);

final progressRepositoryProvider = Provider<ProgressRepository>(
  (ref) => ProgressRepositoryImpl(
    remoteDataSource: ref.watch(progressRemoteDataSourceProvider),
    localDataSource: ref.watch(progressLocalDataSourceProvider),
  ),
);

final saveQuizSessionUseCaseProvider = Provider<SaveQuizSessionUseCase>(
  (ref) => SaveQuizSessionUseCase(ref.watch(progressRepositoryProvider)),
);

final getUserProgressUseCaseProvider = Provider<GetUserProgressUseCase>(
  (ref) => GetUserProgressUseCase(ref.watch(progressRepositoryProvider)),
);

final getWrongQuestionStatsUseCaseProvider =
    Provider<GetWrongQuestionStatsUseCase>(
  (ref) => GetWrongQuestionStatsUseCase(ref.watch(progressRepositoryProvider)),
);

final userProgressProvider =
    FutureProvider.family<UserProgressSummary, String>((ref, userId) async {
  final result = await ref.watch(getUserProgressUseCaseProvider).call(userId);
  return result.fold(
    (Failure failure) => throw Exception(failure.message),
    (UserProgressSummary summary) => summary,
  );
});
