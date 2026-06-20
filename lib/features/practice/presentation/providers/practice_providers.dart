import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/practice_config_datasource.dart';
import '../../domain/entities/practice_topic.dart';

final practiceConfigDataSourceProvider = Provider<PracticeConfigDataSource>(
  (ref) => LocalPracticeConfigDataSource(),
);

final practiceTopicsProvider = FutureProvider<List<PracticeTopic>>((ref) async {
  return ref.watch(practiceConfigDataSourceProvider).getTopics();
});

final practiceTopicProvider =
    FutureProvider.family<PracticeTopic?, String>((ref, id) async {
  final topics = await ref.watch(practiceTopicsProvider.future);
  for (final topic in topics) {
    if (topic.id == id) {
      return topic;
    }
  }
  return null;
});
