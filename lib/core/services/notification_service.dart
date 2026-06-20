import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const _channelId = 'ehliyet_daily';
  static const _channelName = 'Günlük Çalışma';
  static const _channelDesc = 'Günlük çalışma hatırlatıcıları';

  Future<void> initialize() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();

    await _plugin.initialize(
      const InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      ),
    );
  }

  Future<bool> requestPermission() async {
    final android = _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    if (android != null) {
      return await android.requestNotificationsPermission() ?? false;
    }

    final ios = _plugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>();
    if (ios != null) {
      return await ios.requestPermissions(alert: true, badge: true, sound: true) ?? false;
    }

    return false;
  }

  /// Sabah 09:00 ve öğlen 12:00 hatırlatıcıları zamanlar.
  Future<void> scheduleDailyReminders() async {
    await _cancelAll();

    const androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDesc,
    );
    const iosDetails = DarwinNotificationDetails();
    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    // Sabah 09:00 — her gün
    await _plugin.periodicallyShow(
      1,
      'Ehliyet Hazırlık ☀️',
      'Bugünkü çalışmanı yapmayı unutma! Hedefe bir adım daha yaklaş.',
      RepeatInterval.daily,
      details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

  /// Seri tehlikede uyarı bildirimi (kullanıcı gün boyu çalışmadıysa).
  Future<void> showStreakWarning(int currentStreak) async {
    const androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDesc,
      importance: Importance.high,
      priority: Priority.high,
    );
    const details = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(),
    );

    await _plugin.show(
      2,
      '🔥 Seriniz tehlikede!',
      '$currentStreak günlük serinizi kaybetmemek için şimdi çalış!',
      details,
    );
  }

  Future<void> cancelDailyReminders() => _plugin.cancel(1);

  Future<void> _cancelAll() => _plugin.cancelAll();
}
