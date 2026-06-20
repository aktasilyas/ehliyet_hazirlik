import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/constants/env.dart';
import '../../domain/entities/question_category.dart';
import '../../domain/entities/question_entity.dart';
import '../models/question_model.dart';

abstract class QuestionRemoteDataSource {
  Future<List<QuestionEntity>> getByCategory(
    QuestionCategory category, {
    int? limit,
  });

  Future<List<QuestionEntity>> getByYear(int year);

  Future<List<QuestionEntity>> getAllActive();
}

class SupabaseQuestionRemoteDataSource implements QuestionRemoteDataSource {
  SupabaseQuestionRemoteDataSource({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  static bool get isConfigured =>
      !Env.supabaseUrl.contains('YOUR_PROJECT') &&
      !Env.supabaseAnonKey.contains('YOUR_SUPABASE');

  @override
  Future<List<QuestionEntity>> getAllActive() async {
    final response = await _client
        .from('questions')
        .select()
        .eq('is_active', true);

    return _mapList(response);
  }

  @override
  Future<List<QuestionEntity>> getByCategory(
    QuestionCategory category, {
    int? limit,
  }) async {
    final baseQuery = _client
        .from('questions')
        .select()
        .eq('is_active', true)
        .eq('category', category.apiValue);

    final response = limit == null ? await baseQuery : await baseQuery.limit(limit);
    return _mapList(response);
  }

  @override
  Future<List<QuestionEntity>> getByYear(int year) async {
    final response = await _client
        .from('questions')
        .select()
        .eq('is_active', true)
        .eq('year', year);

    return _mapList(response);
  }

  List<QuestionEntity> _mapList(dynamic response) {
    final rows = response as List<dynamic>;
    return rows
        .map(
          (row) => QuestionModel.fromJson(
            Map<String, dynamic>.from(row as Map),
          ).toEntity(),
        )
        .toList();
  }
}
