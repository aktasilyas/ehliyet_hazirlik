import 'dart:math';

import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/question_category.dart';
import '../../domain/entities/question_entity.dart';
import '../../domain/repositories/question_repository.dart';
import '../datasources/question_local_datasource.dart';
import '../datasources/question_remote_datasource.dart';

class QuestionRepositoryImpl implements QuestionRepository {
  QuestionRepositoryImpl({
    required QuestionRemoteDataSource remoteDataSource,
    required QuestionLocalDataSource localDataSource,
    Random? random,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource,
        _random = random ?? Random();

  final QuestionRemoteDataSource _remoteDataSource;
  final QuestionLocalDataSource _localDataSource;
  final Random _random;

  @override
  Future<Either<Failure, List<QuestionEntity>>> getQuestionsByCategory(
    QuestionCategory category, {
    int? limit,
  }) async {
    try {
      final remote = await _fetchRemote(
        () => _remoteDataSource.getByCategory(category, limit: limit),
      );
      if (remote != null) {
        return Right(_applyLimit(remote, limit));
      }

      final local = _localDataSource.getByCategory(category);
      return Right(_applyLimit(_shuffle(local), limit));
    } catch (error) {
      return Left(_mapError(error));
    }
  }

  @override
  Future<Either<Failure, List<QuestionEntity>>> getMockExamQuestions() async {
    try {
      final remote = await _fetchRemote(_remoteDataSource.getAllActive);
      final source = remote ?? _localDataSource.getAll();
      final selected = _buildMockExam(source);
      return Right(selected);
    } catch (error) {
      return Left(_mapError(error));
    }
  }

  @override
  Future<Either<Failure, List<QuestionEntity>>> getQuestionsByYear(
    int year,
  ) async {
    try {
      final remote = await _fetchRemote(
        () => _remoteDataSource.getByYear(year),
      );
      if (remote != null) {
        return Right(_shuffle(remote));
      }

      return Right(_shuffle(_localDataSource.getByYear(year)));
    } catch (error) {
      return Left(_mapError(error));
    }
  }

  List<QuestionEntity> _buildMockExam(List<QuestionEntity> source) {
    final selected = <QuestionEntity>[];

    for (final entry in mockExamDistribution.entries) {
      final pool = _shuffle(
        source.where((q) => q.category == entry.key).toList(),
      );
      if (pool.length < entry.value) {
        throw ServerException(
          'Mock sınav için yeterli soru bulunamadı: ${entry.key.displayName}',
        );
      }
      selected.addAll(pool.take(entry.value));
    }

    return _shuffle(selected);
  }

  Future<List<QuestionEntity>?> _fetchRemote(
    Future<List<QuestionEntity>> Function() fetch,
  ) async {
    if (!SupabaseQuestionRemoteDataSource.isConfigured) {
      return null;
    }

    try {
      return await fetch();
    } on ServerException {
      rethrow;
    } catch (_) {
      return null;
    }
  }

  List<QuestionEntity> _shuffle(List<QuestionEntity> questions) {
    final copy = List<QuestionEntity>.from(questions);
    copy.shuffle(_random);
    return copy;
  }

  List<QuestionEntity> _applyLimit(
    List<QuestionEntity> questions,
    int? limit,
  ) {
    if (limit == null || questions.length <= limit) {
      return questions;
    }
    return questions.take(limit).toList();
  }

  Failure _mapError(Object error) {
    if (error is ServerException) {
      return ServerFailure(error.message);
    }
    return ServerFailure(error.toString());
  }
}
