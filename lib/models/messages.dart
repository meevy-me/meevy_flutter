import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

List<Message> messageFromJson(String str) =>
    List<Message>.from(json.decode(str).map((x) => Message.fromJson(x)));

class Message {
  Message({
    required this.id,
    required this.content,
    required this.datePosted,
    required this.sender,
    this.replyTo,
    // required this.spot,
  });
  String id = "";
  String content;
  DateTime datePosted;
  int sender;
  Map<String, dynamic>? replyTo;
  // dynamic spot;

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
        id: json["id"],
        content: json["message"],
        datePosted: DateTime.parse(json["date_sent"]),
        sender: int.parse(json["sender"]),
        replyTo: json['reply_to']);
  }
  // spot: json["spot"],

  Map<String, dynamic> toJson() => {
        "id": id,
        "message": content,
        "date_sent": datePosted.toIso8601String(),
        "sender": sender.toString(),

        // "spot": spot,
      };

  String get formatContent {
    if (content.contains("https://open.spotify.com/")) {
      return "Sent a spotify item";
    }
    return content;
  }

  @override
  String toString() {
    return content;
  }

  Message? get repliedMessage {
    Message? msg;
    if (replyTo != null) {
      print(replyTo);
      msg = Message.fromJson(replyTo!);
      print(msg);
    }
    return msg;
  }
}
