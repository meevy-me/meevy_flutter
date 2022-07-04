// To parse this JSON data, do
//
//     final chat = chatFromJson(jsonString);

import 'dart:convert';

import 'package:get/get.dart';
import 'package:soul_date/models/friend_model.dart';

import 'messages.dart';

List<Chat> chatFromJson(String str) =>
    List<Chat>.from(json.decode(str).map((x) => Chat.fromJson(x)));

String chatToJson(List<Chat> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Chat {
  Chat({
    required this.id,
    required this.friends,
    required this.messages,
    required this.dateCreated,
  });

  int id;
  Friends friends;
  RxList<Message> messages;
  DateTime dateCreated;

  factory Chat.fromJson(Map<String, dynamic> json) => Chat(
        id: json["id"],
        friends: Friends.fromJson(json["friends"]),
        messages:
            List<Message>.from(json["messages"].map((x) => Message.fromJson(x)))
                .obs,
        dateCreated: DateTime.parse(json["date_created"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "friends": friends.toJson(),
        "messages": List<dynamic>.from(messages.map((x) => x.toJson())),
        "date_created": dateCreated.toIso8601String(),
      };
}
