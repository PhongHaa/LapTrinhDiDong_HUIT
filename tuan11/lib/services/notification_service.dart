// lib/services/notification_service.dart
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    await _plugin.initialize(const InitializationSettings(android: android));
    tz.initializeTimeZones();
  }

  static Future<void> scheduleReminder(
    String title,
    String body,
    int id,
  ) async {
    final android = AndroidNotificationDetails(
      'id',
      'reminder',
      importance: Importance.max,
    );
    final time = tz.TZDateTime.now(tz.local).add(Duration(minutes: 10));
    await _plugin.zonedSchedule(
      id,
      title,
      body,
      time,
      NotificationDetails(android: android),
      androidScheduleMode: AndroidScheduleMode.inexact,
    );
  }

  static Future<void> showSimple(String title, String body) async {
    final android = AndroidNotificationDetails(
      'id',
      'simple',
      importance: Importance.max,
    );
    await _plugin.show(0, title, body, NotificationDetails(android: android));
  }
}
