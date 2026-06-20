import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/ai_explain_repository_impl.dart';
import '../../domain/repositories/ai_explain_repository.dart';

final aiCacheDataSourceProvider = Provider<AiCacheDataSource>(
  (ref) => InMemoryAiCacheDataSource(),
);

final claudeAiRemoteDataSourceProvider = Provider<ClaudeAiRemoteDataSource>(
  (ref) => ClaudeAiRemoteDataSource(),
);

final aiExplainRepositoryProvider = Provider<AiExplainRepository>(
  (ref) => AiExplainRepositoryImpl(
    cacheDataSource: ref.watch(aiCacheDataSourceProvider),
    remoteDataSource: ref.watch(claudeAiRemoteDataSourceProvider),
  ),
);
