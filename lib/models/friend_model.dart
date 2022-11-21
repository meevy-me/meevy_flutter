// To parse this JSON data, do
//
//     final friends = friendsFromJson(jsonString);

import 'dart:convert';

import 'package:soul_date/models/messages.dart';
import 'package:soul_date/models/profile_model.dart';

List<Friends> friendsFromJson(String str) =>
    List<Friends>.from(json.decode(str).map((x) => Friends.fromJson(x)));

String friendsToJson(List<Friends> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Friends {
  final int id;
  final Profile profile2;
  final bool accepted;
  final DateTime dateAdded;
  final dynamic dateAccepted;
  final Profile profile1;
  final dynamic match;
  final Message? lastMessage;

  factory Friends.fromJson(Map<String, dynamic> json) {
    Friends friend = Friends(
        id: json["id"],
        dateAdded: DateTime.parse(json["date_added"]),
        dateAccepted: json["date_accepted"],
        profile2: Profile.fromJson(json["profile2"]),
        profile1: Profile.fromJson(json["profile1"]),
        match: json["match"],
        lastMessage: Message.fromJson(json['last_message']),
        accepted: json["accepted"]);

    return friend;
  }

  Friends(
      {this.lastMessage,
      required this.id,
      required this.profile2,
      required this.accepted,
      required this.dateAdded,
      this.dateAccepted,
      required this.profile1,
      this.match});

  Map<String, dynamic> toJson() => {
        "id": id,
        // "profile2": profile2.toJson(),
        "accepted": accepted,
        "date_added": dateAdded.toIso8601String(),
        "date_accepted": dateAccepted,
        "profile1": profile1,
        "match": match,
      };
}
