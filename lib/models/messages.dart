import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:soul_date/models/Spotify/base_model.dart';

List<Message> messageFromJson(String str) =>
    List<Message>.from(json.decode(str).map((x) => Message.fromJson(x)));

class Message {
  Message({
    required this.id,
    required this.content,
    required this.datePosted,
    required this.type,
    required this.sender,
    this.spotifyData,
    this.replyTo,
    // required this.spot,
  });
  String id = "";
  String type;
  String content;
  Timestamp? datePosted;
  int sender;
  Map<String, dynamic>? replyTo;
  SpotifyData? spotifyData;
  // dynamic spot;

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
        id: json.containsKey('id') ? json["id"] : "",
        type: json.containsKey("type") ? json['type'] : "text",
        content: json["message"],
        datePosted:
            json['date_sent'] != null ? json["date_sent"] as Timestamp : null,
        sender: json['sender'] is String
            ? int.parse(json["sender"])
            : json['sender'],
        spotifyData:
            json.containsKey('spotifyData') && json['spotifyData'] != null
                ? SpotifyData.spotifyDataFactory(json['spotifyData'])
                : null,
        replyTo: json['reply_to']);
  }
  // spot: json["spot"],

  Map<String, dynamic> toJson() => {
        "id": id,
        "message": content,
        "date_sent": datePosted,
        "sender": sender.toString(),
        "spotifyData": spotifyData?.toJson()

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
