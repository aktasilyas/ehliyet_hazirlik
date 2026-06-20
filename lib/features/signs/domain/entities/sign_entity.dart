enum SignCategory {
  warning,
  prohibition,
  obligation,
  informational,
  priority;

  String get displayName => switch (this) {
        SignCategory.warning => 'Tehlike',
        SignCategory.prohibition => 'Yasak',
        SignCategory.obligation => 'Zorunluluk',
        SignCategory.informational => 'Bilgi',
        SignCategory.priority => 'Öncelik',
      };

  String get iconEmoji => switch (this) {
        SignCategory.warning => '⚠️',
        SignCategory.prohibition => '🚫',
        SignCategory.obligation => '🔵',
        SignCategory.informational => 'ℹ️',
        SignCategory.priority => '⬆️',
      };
}

class SignEntity {
  const SignEntity({
    required this.id,
    required this.code,
    required this.name,
    required this.category,
    required this.description,
    required this.iconCode,
    this.isPremium = false,
  });

  final String id;
  final String code;
  final String name;
  final SignCategory category;
  final String description;

  /// Unicode code point for the sign icon (displayed with Text widget)
  final int iconCode;
  final bool isPremium;
}
