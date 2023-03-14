import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:soul_date/main.dart';
import 'package:soul_date/services/network.dart';

import '../constants/constants.dart';
import '../models/models.dart';
import 'package:timezone/timezone.dart' as tz;

void showSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
}

void sendNotification(Profile profile, String message) async {
  HttpClient client = HttpClient();
  await client.post(notifyUrl,
      body: {'receiver': profile.id.toString(), 'message': message});
}
