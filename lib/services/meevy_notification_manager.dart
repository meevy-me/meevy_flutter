import 'dart:math';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class MeevyNotificationManager {
  static FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static var random =
      Random(); // keep this somewhere in a static variable. Just make sure to initialize only once.

  MeevyNotificationManager._privateConstructor();

  static final MeevyNotificationManager _instance =
      MeevyNotificationManager._privateConstructor();

  factory MeevyNotificationManager() {
    return _instance;
  }

  static Future<void> initialize() async {
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      onDidReceiveLocalNotification: (id, title, body, payload) {},
    );
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: const AndroidInitializationSettings('app_icon'),
            iOS: initializationSettingsDarwin);
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static Future<void> showNotification(
      {required int id,
      required String? title,
      String? body,
      String? payload}) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        const AndroidNotificationDetails('meevy_channel_id', 'Meevy',
            channelDescription: 'Meevy Notification Channel',
            importance: Importance.high,
            priority: Priority.high,
            groupKey: 'meevy_group',
            groupAlertBehavior: GroupAlertBehavior.children,
            setAsGroupSummary: true);
    final NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await _flutterLocalNotificationsPlugin.show(
        randomString, title, body, platformChannelSpecifics,
        payload: payload);
  }

  static int get randomString {
    return random.nextInt(1000000);
  }

  static Future<void> scheduleNotification(
      int id, String title, String body, tz.TZDateTime scheduledDate) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        const AndroidNotificationDetails('meevy_channel_id', 'Meevy',
            channelDescription: 'Meevy Notification Channel',
            importance: Importance.high,
            priority: Priority.high);
    final NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await _flutterLocalNotificationsPlugin.zonedSchedule(
        randomString, title, body, scheduledDate, platformChannelSpecifics,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.wallClockTime,
        androidAllowWhileIdle: true);
  }

  static tz.TZDateTime nextInstanceOfDate(
      {required Time time, required Duration duration}) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, time.hour);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(duration);
    }
    return scheduledDate;
  }

  static Future<void> cancelNotification(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
  }
}
