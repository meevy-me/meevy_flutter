import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:get/get.dart';

import '../services/notifications.dart';

class FirebaseController extends GetxController {
  @override
  void onInit() async {
    handleMessage();
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
      log(message.notification!.title!);
      NotificationApi.showNotification(
          title: message.notification!.title, body: message.notification!.body);
    });
  }
}
