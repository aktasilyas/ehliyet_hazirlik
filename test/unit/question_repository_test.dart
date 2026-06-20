import 'dart:math';

import 'package:ehliyet_hazirlik/features/quiz/data/datasources/question_local_datasource.dart';
import 'package:ehliyet_hazirlik/features/quiz/data/datasources/question_remote_datasource.dart';
import 'package:ehliyet_hazirlik/features/quiz/data/repositories/question_repository_impl.dart';
import 'package:ehliyet_hazirlik/features/quiz/domain/entities/question_category.dart';
import 'package:ehliyet_hazirlik/features/quiz/domain/entities/question_entity.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeRemoteDataSource implements QuestionRemoteDataSource {
  @override
  Future<List<QuestionEntity>> getAllActive() async => [];

  @override
  Future<List<QuestionEntity>> getByCategory(
    QuestionCategory category, {
    int? limit,
  }) async =>
      [];

  @override
  Future<List<QuestionEntity>> getByYear(int year) async => [];
}

void main() {
  late QuestionRepositoryImpl repository;

  setUp(() {
    repository = QuestionRepositoryImpl(
      remoteDataSource: _FakeRemoteDataSource(),
      localDataSource: MockQuestionLocalDataSource(),
      random: Random(1),
    );
  });

  group('QuestionRepositoryImpl', () {
    test('mock sınav 50 soru döner', () async {
      final result = await repository.getMockExamQuestions();

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Hata beklenmiyordu'),
        (questions) {
          expect(questions.length, 50);
          expect(
            questions
                .where((q) => q.category == QuestionCategory.traffic)
                .length,
            23,
          );
          expect(
            questions
                .where((q) => q.category == QuestionCategory.firstAid)
                .length,
            12,
          );
        },
      );
    });

    test('konuya göre soru döner', () async {
      final result = await repository.getQuestionsByCategory(
        QuestionCategory.engine,
        limit: 10,
      );

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Hata beklenmiyordu'),
        (questions) {
          expect(questions.length, 10);
          expect(
            questions.every((q) => q.category == QuestionCategory.engine),
            isTrue,
          );
        },
      );
    });
  });
}
