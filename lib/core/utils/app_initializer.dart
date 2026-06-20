import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../features/quiz/data/datasources/question_remote_datasource.dart';
import '../../firebase_options.dart';
import '../constants/env.dart';

Future<void> initializeFirebase() async {
  if (Env.skipFirebaseInit) {
    return;
  }

  if (Firebase.apps.isNotEmpty) {
    return;
  }

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

Future<void> initializeSupabase() async {
  if (!SupabaseQuestionRemoteDataSource.isConfigured) {
    debugPrint('Supabase: placeholder URL — init atlandı.');
    return;
  }

  if (Supabase.instance.isInitialized) {
    return;
  }

  await Supabase.initialize(
    url: Env.supabaseUrl,
    anonKey: Env.supabaseAnonKey, // ignore: deprecated_member_use
  );
}

Future<void> initializeRemoteConfig() async {
  if (Env.skipFirebaseInit || Firebase.apps.isEmpty) {
    return;
  }

  final remoteConfig = FirebaseRemoteConfig.instance;
  await remoteConfig.setConfigSettings(
    RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 10),
      minimumFetchInterval: const Duration(hours: 1),
    ),
  );
  await remoteConfig.setDefaults(const {
    'practice_parallel_park_video': 'Vd9QkWONiT4',
    'practice_hill_start_video': 'Vd9QkWONiT4',
    'practice_narrow_turn_video': 'Vd9QkWONiT4',
    'practice_reverse_maneuver_video': 'Vd9QkWONiT4',
  });

  try {
    await remoteConfig.fetchAndActivate();
  } catch (error) {
    debugPrint('Remote Config fetch hatası: $error');
  }
}
