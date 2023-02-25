import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class SoulChatText {
  String? key;
  String text;
  bool formatted;

  SoulChatText({this.key, required this.text, this.formatted = false});

  @override
  String toString() {
    return key ?? text;
  }

  bool get valid {
    return text.contains("https://open.spotify.com/");
  }

  String get format {
    return _spotifyFormat();
  }

  String _spotifyFormat() {
    if (valid) {
      var text = this.text.replaceAll("https://open.spotify.com/", "");
      var keys = text.split("/");
      var field = keys[0];

      var fieldId = keys[1];
      if (fieldId.contains("?")) {
        fieldId = fieldId.split("?")[0];
      }
      return field;
    }
    return text;
  }
}

String utf8Format(String str) {
  try {
    return utf8.decode(str.runes.toList());
  } catch (e) {
    log(e.toString());
    return str;
  }
}

String joinList(List<Object> items, {int count = 3}) {
  String namesTemp = items.take(count).join(", ");
  int remainingCount = items.length - count;
  if (items.length > count) {
    return namesTemp + " & $remainingCount more.";
  }
  return namesTemp;
}

String timeFormat(DateTime time) {
  return DateFormat.jm().format(time);
}
