import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/services.dart';
import 'package:timezone/timezone.dart' as tz;

const _reminderBaseId = 1000;
const _sessionPreEndId = 2001;
const _sessionCompleteId = 2002;

const _iosForegroundDetails = DarwinNotificationDetails(
  presentAlert: true,
  presentSound: true,
  presentBadge: false,
  presentBanner: true,
  presentList: true,
);

const _iosSessionForegroundDetails = DarwinNotificationDetails(
  presentAlert: false,
  presentSound: true,
  presentBadge: false,
  presentBanner: false,
  presentList: false,
);

class NotificationService {
  NotificationService(this._plugin);

  final FlutterLocalNotificationsPlugin _plugin;

  static Future<NotificationService> initialize() async {
    final plugin = FlutterLocalNotificationsPlugin();
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    await plugin.initialize(settings);
    return NotificationService(plugin);
  }

  Future<void> requestPermissions() async {
    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
    await _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);
  }

  Future<void> scheduleDailyReminder({
    required bool enabled,
    required TimeOfDay time,
    required List<int> daysOfWeek,
  }) async {
    await cancelDailyReminders();
    if (!enabled) return;
    await requestPermissions();

    final sanitizedDays =
        daysOfWeek
            .where((day) => day >= DateTime.monday && day <= DateTime.sunday)
            .toSet()
            .toList()
          ..sort();
    if (sanitizedDays.isEmpty) return;

    for (final day in sanitizedDays) {
      final date = _nextInstanceOfTime(time, day);
      await _plugin.zonedSchedule(
        _reminderBaseId + day,
        'Do nothing.',
        'One hour. One day.',
        date,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'daily_reminder',
            'Daily Reminder',
            channelDescription: 'Reminds you to sit once per day.',
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: _iosForegroundDetails,
        ),
        payload: 'daily_reminder',
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      );
    }
  }

  Future<void> scheduleSessionAlerts({
    required int durationMinutes,
    required bool preEndAlert,
    required bool completionAlert,
    required bool vibration,
  }) async {
    await cancelSessionAlerts();
    if (!preEndAlert && !completionAlert) return;
    await requestPermissions();
    final now = tz.TZDateTime.now(tz.local);
    final completeTime = now.add(Duration(minutes: durationMinutes));
    final androidBase = AndroidNotificationDetails(
      'session_alerts',
      'Session Alerts',
      channelDescription: 'Pre-end and completion alerts',
      importance: Importance.high,
      priority: Priority.high,
      enableVibration: vibration,
      playSound: true,
    );

    if (preEndAlert && durationMinutes > 5) {
      final preEndTime = now.add(Duration(minutes: durationMinutes - 5));
      await _zonedScheduleWithExactFallback(
        id: _sessionPreEndId,
        title: 'Almost there',
        body: 'Five minutes remaining.',
        scheduledDate: preEndTime,
        notificationDetails: NotificationDetails(
          android: androidBase,
          iOS: _iosSessionForegroundDetails,
        ),
      );
    }

    if (completionAlert) {
      await _zonedScheduleWithExactFallback(
        id: _sessionCompleteId,
        title: 'Done.',
        body: 'Session completed.',
        scheduledDate: completeTime,
        notificationDetails: NotificationDetails(
          android: androidBase,
          iOS: _iosSessionForegroundDetails,
        ),
      );
    }
  }

  Future<void> cancelSessionAlerts() async {
    await _plugin.cancel(_sessionPreEndId);
    await _plugin.cancel(_sessionCompleteId);
  }

  Future<void> cancelDailyReminders() async {
    for (var i = 1; i <= 7; i++) {
      await _plugin.cancel(_reminderBaseId + i);
    }
  }

  Future<void> _zonedScheduleWithExactFallback({
    required int id,
    required String title,
    required String body,
    required tz.TZDateTime scheduledDate,
    required NotificationDetails notificationDetails,
  }) async {
    try {
      await _plugin.zonedSchedule(
        id,
        title,
        body,
        scheduledDate,
        notificationDetails,
        payload: 'session_alert',
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
    } on PlatformException catch (e) {
      if (e.code != 'exact_alarms_not_permitted') rethrow;
      await _plugin.zonedSchedule(
        id,
        title,
        body,
        scheduledDate,
        notificationDetails,
        payload: 'session_alert',
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      );
    }
  }

  tz.TZDateTime _nextInstanceOfTime(TimeOfDay time, int weekday) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );
    while (scheduled.weekday != weekday || scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }
}

final notificationServiceProvider = Provider<NotificationService>(
  (ref) => throw UnimplementedError('Notification service not initialized'),
);
