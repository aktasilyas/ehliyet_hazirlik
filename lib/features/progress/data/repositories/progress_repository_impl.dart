import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../../../quiz/domain/entities/quiz_session.dart';
import '../../domain/entities/progress_entities.dart';
import '../../domain/repositories/progress_repository.dart';
import '../datasources/progress_local_datasource.dart';
import '../datasources/progress_remote_datasource.dart';

class ProgressRepositoryImpl implements ProgressRepository {
  ProgressRepositoryImpl({
    required ProgressRemoteDataSource remoteDataSource,
    required ProgressLocalDataSource localDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

  final ProgressRemoteDataSource _remoteDataSource;
  final ProgressLocalDataSource _localDataSource;

  @override
  Future<Either<Failure, Unit>> saveQuizSession(
    String userId,
    QuizSession session,
  ) async {
    try {
      await _localDataSource.saveSession(userId, session);
      if (FirestoreProgressRemoteDataSource.isConfigured) {
        await _remoteDataSource.saveSession(userId, session);
      }
      return const Right(unit);
    } catch (error) {
      return Left(ServerFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, UserProgressSummary>> getUserProgress(
    String userId,
  ) async {
    try {
      if (FirestoreProgressRemoteDataSource.isConfigured) {
        final remote = await _remoteDataSource.getSummary(userId);
        if (remote.totalSessions > 0) {
          return Right(remote);
        }
      }
      return Right(await _localDataSource.getSummary(userId));
    } catch (error) {
      return Left(ServerFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, List<QuestionStatRecord>>> getWrongQuestionStats(
    String userId,
  ) async {
    try {
      if (FirestoreProgressRemoteDataSource.isConfigured) {
        final remote = await _remoteDataSource.getWrongStats(userId);
        if (remote.isNotEmpty) {
          return Right(remote);
        }
      }
      return Right(await _localDataSource.getWrongStats(userId));
    } catch (error) {
      return Left(ServerFailure(error.toString()));
    }
  }
}
