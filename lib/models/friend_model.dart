// To parse this JSON data, do
//
//     final friends = friendsFromJson(jsonString);

import 'dart:convert';

import 'package:soul_date/models/profile_model.dart';

List<Friends> friendsFromJson(String str) =>
    List<Friends>.from(json.decode(str).map((x) => Friends.fromJson(x)));

String friendsToJson(List<Friends> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Friends {
  Friends(
      {required this.id,
      required this.profile2,
      required this.dateAdded,
      required this.dateAccepted,
      required this.profile1,
      required this.match,
      required this.accepted});

  int id;
  Profile profile2;
  bool accepted;
  DateTime dateAdded;
  dynamic dateAccepted;
  Profile profile1;
  dynamic match;

  factory Friends.fromJson(Map<String, dynamic> json) => Friends(
        id: json["id"],
        profile2: Profile.fromJson(json["profile2"]),
        accepted: json["accepted"],
        dateAdded: DateTime.parse(json["date_added"]),
        dateAccepted: json["date_accepted"],
        profile1: Profile.fromJson(json["profile1"]),
        match: json["match"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "profile2": profile2.toJson(),
        "accepted": accepted,
        "date_added": dateAdded.toIso8601String(),
        "date_accepted": dateAccepted,
        "profile1": profile1,
        "match": match,
      };
}
