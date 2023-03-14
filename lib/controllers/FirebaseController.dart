import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:get/get.dart';
import 'package:soul_date/services/meevy_notification_manager.dart';
import 'package:timezone/timezone.dart' as tz;

class FirebaseController extends GetxController {
  @override
  void onInit() async {
    handleMessage();
    scheduleNotification();
    super.onInit();
  }

  bool hasChat = false;

  handleMessage() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // if (message.notification!.title == 'Request') {
      //   Get.dialog(NoticeService.soulNotice(json.decode(message.data['data'])));
      // } else if (message.notification!.title == 'Message') {
      //   hasChat = true;
      //   update(['hasChat']);
      // }
      MeevyNotificationManager.showNotification(
          id: 0,
          title: message.notification!.title,
          body: message.notification!.body);
    });
  }

  scheduleNotification() async {
    tz.TZDateTime tzDateTime = MeevyNotificationManager.nextInstanceOfDate(
        time: const Time(18, 0, 0), duration: const Duration(days: 1));

    MeevyNotificationManager.scheduleNotification(
        0, "Song Remainder", "Dont Forget To Send Them A Song", tzDateTime);
  }
}
