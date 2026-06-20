import 'package:firebase_remote_config/firebase_remote_config.dart';

import '../../../../core/constants/env.dart';
import '../../domain/entities/practice_topic.dart';

abstract class PracticeConfigDataSource {
  Future<List<PracticeTopic>> getTopics();
}

class RemoteConfigPracticeDataSource implements PracticeConfigDataSource {
  RemoteConfigPracticeDataSource({FirebaseRemoteConfig? remoteConfig})
      : _remoteConfig = remoteConfig ?? FirebaseRemoteConfig.instance;

  final FirebaseRemoteConfig _remoteConfig;

  static bool get isConfigured => !Env.skipFirebaseInit;

  @override
  Future<List<PracticeTopic>> getTopics() async {
    if (!isConfigured) {
      return defaultPracticeTopics;
    }

    try {
      await _remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 10),
          minimumFetchInterval: const Duration(hours: 1),
        ),
      );
      await _remoteConfig.setDefaults({
        for (final topic in defaultPracticeTopics)
          'practice_${topic.id}_video': topic.videoId,
      });
      await _remoteConfig.fetchAndActivate();
    } catch (_) {
      return defaultPracticeTopics;
    }

    return defaultPracticeTopics
        .map(
          (topic) => PracticeTopic(
            id: topic.id,
            title: topic.title,
            description: topic.description,
            examRequirement: topic.examRequirement,
            videoId: _remoteConfig.getString('practice_${topic.id}_video').isEmpty
                ? topic.videoId
                : _remoteConfig.getString('practice_${topic.id}_video'),
            iconName: topic.iconName,
          ),
        )
        .toList();
  }
}

class LocalPracticeConfigDataSource implements PracticeConfigDataSource {
  @override
  Future<List<PracticeTopic>> getTopics() async => defaultPracticeTopics;
}
