// To parse this JSON data, do
//
//     final chat = chatFromJson(jsonString);

import 'dart:convert';

import 'package:soul_date/models/friend_model.dart';

import 'messages.dart';

List<Chat> chatFromJson(String str) =>
    List<Chat>.from(json.decode(str).map((x) => Chat.fromJson(x)));

String chatToJson(List<Chat> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Chat {
  Chat({
    this.lastMessage,
    required this.friends,
    required this.id,
    required this.dateCreated,
  });
  final String id;
  final Friends friends;
  final Message? lastMessage;
  DateTime dateCreated;

  factory Chat.fromJson(Map<String, dynamic> json) {
    Chat newChat = Chat(
        id: json["id"],
        dateCreated: DateTime.parse(json["date_created"]),
        friends: Friends.fromJson(json["friends"]),
        lastMessage: Message.fromJson(json['lastMessage']));

    return newChat;
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        // "friends": friends.toJson(),
        // "messages": List<dynamic>.from(messages.map((x) => x.toJson())),
        "date_created": dateCreated.toIso8601String(),
      };

  @override
  String toString() {
    return id.toString();
  }
}
