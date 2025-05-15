import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const initSettings = InitializationSettings(android: androidSettings);
    await _notifications.initialize(initSettings);
    tz.initializeTimeZones();
  }

  static AndroidNotificationDetails _createAndroidDetails({
    required String channelId,
    required String channelName,
    String? channelDescription,
  }) {
    return AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDescription,
      importance: Importance.max,
      priority: Priority.high,
      visibility: NotificationVisibility.public,
      playSound: true,
      enableVibration: true,
      showWhen: true,
    );
  }

  static Future<void> _scheduleNotification({
    required int id,
    required String title,
    required String body,
    required Duration delay,
    required AndroidNotificationDetails androidDetails,
  }) async {
    final scheduledTime = tz.TZDateTime.now(tz.local).add(delay);
    await _notifications.zonedSchedule(
      id,
      title,
      body,
      scheduledTime,
      NotificationDetails(android: androidDetails),
      androidScheduleMode: AndroidScheduleMode.inexact,
    );
  }

  static Future<void> showSimpleNotification({
    int id = 0,
    String title = 'Nhac hoc tu vung',
    String body = 'Ban da hoc 5 tu moi hom nay chua?',
  }) async {
    final details = _createAndroidDetails(
      channelId: 'learn_english_channel',
      channelName: 'Hoc Anh Van',
    );

    await _notifications.show(
      id,
      title,
      body,
      NotificationDetails(android: details),
    );
  }

  static Future<void> scheduleStudyReminderAfter10Minutes() async {
    final details = _createAndroidDetails(
      channelId: 'study_reminder_channel',
      channelName: 'Hoc Anh Van',
    );

    await _scheduleNotification(
      id: 1,
      title: 'Lam bai tap di',
      body: 'Thong bao lam bai tap sau 10 phut',
      delay: Duration(minutes: 10),
      androidDetails: details,
    );
  }

  static Future<void> scheduleNotificationAfter5Minutes() async {
    final details = _createAndroidDetails(
      channelId: 'study_channel',
      channelName: 'Hoc tap',
      channelDescription: 'Nhac hoc moi ngay',
    );

    await _scheduleNotification(
      id: 2,
      title: '📝 Hay tat may di',
      body: 'Thong bao tat may sau 5 phut',
      delay: Duration(minutes: 5),
      androidDetails: details,
    );
  }
}
