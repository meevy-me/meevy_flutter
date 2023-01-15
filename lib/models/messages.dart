import 'dart:convert';

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
  Timestamp? datePosted;
  int sender;
  Map<String, dynamic>? replyTo;
  // dynamic spot;

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
        id: json.containsKey('id') ? json["id"] : "",
        content: json["message"],
        datePosted:
            json['date_sent'] != null ? json["date_sent"] as Timestamp : null,
        sender: int.parse(json["sender"]),
        replyTo: json['reply_to']);
  }
  // spot: json["spot"],

  Map<String, dynamic> toJson() => {
        "id": id,
        "message": content,
        "date_sent": datePosted,
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
      msg = Message.fromJson(replyTo!);
    }
    return msg;
  }
}
