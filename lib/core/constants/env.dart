/// Ortam değişkenleri — production'da `--dart-define` ile override edilir.
abstract final class Env {
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://YOUR_PROJECT.supabase.co',
  );

  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'YOUR_SUPABASE_ANON_KEY',
  );

  static const String anthropicApiKey = String.fromEnvironment(
    'ANTHROPIC_API_KEY',
  );

  static const bool skipFirebaseInit = bool.fromEnvironment(
    'SKIP_FIREBASE_INIT',
  );

  static bool get isAnthropicConfigured =>
      anthropicApiKey.isNotEmpty && !anthropicApiKey.startsWith('YOUR_');
}
