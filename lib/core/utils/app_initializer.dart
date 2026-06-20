import 'package:firebase_core/firebase_core.dart';
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
