// To parse this JSON data, do
//
//     final chat = chatFromJson(jsonString);

import 'dart:convert';

import 'package:objectbox/objectbox.dart';
import 'package:soul_date/models/friend_model.dart';

import 'messages.dart';

List<Chat> chatFromJson(String str) =>
    List<Chat>.from(json.decode(str).map((x) => Chat.fromJson(x)));

String chatToJson(List<Chat> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@Entity()
class Chat {
  Chat({
    required this.id,
    required this.dateCreated,
  });
  @Id(assignable: true)
  int id;
  final friends = ToOne<Friends>();
  final messages = ToMany<Message>();
  DateTime dateCreated;

  factory Chat.fromJson(Map<String, dynamic> json) {
    Chat newChat = Chat(
      id: json["id"],
      dateCreated: DateTime.parse(json["date_created"]),
    );
    newChat.friends.target = Friends.fromJson(json["friends"]);
    newChat.messages.addAll(
        List<Message>.from(json["messages"].map((x) => Message.fromJson(x))));

    return newChat;
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        // "friends": friends.toJson(),
        "messages": List<dynamic>.from(messages.map((x) => x.toJson())),
        "date_created": dateCreated.toIso8601String(),
      };

  @override
  String toString() {
    return id.toString();
  }
}
