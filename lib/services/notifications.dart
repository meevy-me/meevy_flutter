import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:soul_date/constants/colors.dart';

void showSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
}

class NotificationApi {
  static final _notifications = FlutterLocalNotificationsPlugin();
  static Future _notificationDetails() async {
    return const NotificationDetails(
        android: AndroidNotificationDetails(
          'soul id',
          'soul name',
          color: spotifyGreen,
          enableVibration: true,
        ),
        iOS: IOSNotificationDetails());
  }

  static const InitializationSettings initializationSettings =
      InitializationSettings(
          android: AndroidInitializationSettings('@mipmap/launcher_icon'),
          iOS: IOSInitializationSettings(
            requestAlertPermission: true,
            requestBadgePermission: true,
            requestSoundPermission: true,
          ));
  static Future showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async {
    _notifications.initialize(
      initializationSettings,
    );
    _notifications.show(id, title, body, await _notificationDetails(),
        payload: payload);
  }
}
