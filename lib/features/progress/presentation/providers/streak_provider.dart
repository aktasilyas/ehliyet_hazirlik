import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StreakData {
  const StreakData({
    required this.currentStreak,
    required this.longestStreak,
    required this.lastStudyDate,
    required this.weeklyStudyDays,
  });

  /// Günlük seri (ardışık gün sayısı)
  final int currentStreak;
  final int longestStreak;
  final DateTime? lastStudyDate;

  /// Son 7 günde çalışılan günler (index 0 = 6 gün önce, 6 = bugün)
  final List<bool> weeklyStudyDays;

  bool get studiedToday {
    if (lastStudyDate == null) return false;
    final now = DateTime.now();
    return lastStudyDate!.year == now.year &&
        lastStudyDate!.month == now.month &&
        lastStudyDate!.day == now.day;
  }
}

class StreakNotifier extends AsyncNotifier<StreakData> {
  static const _kCurrentStreak = 'streak_current';
  static const _kLongestStreak = 'streak_longest';
  static const _kLastStudy = 'streak_last_study';
  static const _kWeeklyDays = 'streak_weekly_days';

  @override
  Future<StreakData> build() async {
    final prefs = await SharedPreferences.getInstance();
    return _load(prefs);
  }

  StreakData _load(SharedPreferences prefs) {
    final current = prefs.getInt(_kCurrentStreak) ?? 0;
    final longest = prefs.getInt(_kLongestStreak) ?? 0;
    final lastStudyStr = prefs.getString(_kLastStudy);
    final lastStudy =
        lastStudyStr != null ? DateTime.tryParse(lastStudyStr) : null;
    final weeklyRaw = prefs.getStringList(_kWeeklyDays) ??
        List.filled(7, 'false');
    final weekly = weeklyRaw.map((v) => v == 'true').toList();

    return StreakData(
      currentStreak: current,
      longestStreak: longest,
      lastStudyDate: lastStudy,
      weeklyStudyDays: weekly,
    );
  }

  /// Sınav tamamlandığında çağrılır; seriyi günceller.
  Future<void> recordStudy() async {
    final prefs = await SharedPreferences.getInstance();
    final current = _load(prefs);
    final now = DateTime.now();

    int newStreak = current.currentStreak;

    if (current.lastStudyDate == null) {
      newStreak = 1;
    } else {
      final diff = now.difference(current.lastStudyDate!).inDays;
      if (diff == 0) {
        // Aynı gün — seri değişmez
      } else if (diff == 1) {
        // Ardışık gün — seri artar
        newStreak = current.currentStreak + 1;
      } else {
        // Gün atlandı — seri sıfırlanır
        newStreak = 1;
      }
    }

    final longest =
        newStreak > current.longestStreak ? newStreak : current.longestStreak;

    // Haftalık listeyi güncelle
    final weeklyDays = _updateWeekly(current.weeklyStudyDays, now);

    await prefs.setInt(_kCurrentStreak, newStreak);
    await prefs.setInt(_kLongestStreak, longest);
    await prefs.setString(_kLastStudy, now.toIso8601String());
    await prefs.setStringList(
        _kWeeklyDays, weeklyDays.map((v) => v.toString()).toList());

    state = AsyncData(StreakData(
      currentStreak: newStreak,
      longestStreak: longest,
      lastStudyDate: now,
      weeklyStudyDays: weeklyDays,
    ));
  }

  List<bool> _updateWeekly(List<bool> current, DateTime now) {
    final days = List<bool>.from(current);
    // Index 6 = bugün, index 0 = 6 gün önce
    const todayIndex = 6;
    final result = List<bool>.filled(7, false);
    for (var i = 0; i < 7; i++) {
      result[i] = days[i];
    }
    result[todayIndex] = true;
    return result;
  }
}

final streakProvider =
    AsyncNotifierProvider<StreakNotifier, StreakData>(StreakNotifier.new);
