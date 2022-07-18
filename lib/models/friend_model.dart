// To parse this JSON data, do
//
//     final friends = friendsFromJson(jsonString);

import 'dart:convert';

import 'package:objectbox/objectbox.dart';
import 'package:soul_date/models/profile_model.dart';

List<Friends> friendsFromJson(String str) =>
    List<Friends>.from(json.decode(str).map((x) => Friends.fromJson(x)));

String friendsToJson(List<Friends> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@Entity()
class Friends {
  Friends({required this.id, required this.dateAdded, required this.accepted});
  @Id(assignable: true)
  int id;
  final profile2 = ToOne<Profile>();
  bool accepted;
  DateTime dateAdded;
  dynamic dateAccepted;
  final profile1 = ToOne<Profile>();
  dynamic match;

  factory Friends.fromJson(Map<String, dynamic> json) {
    Friends friend = Friends(
        id: json["id"],
        dateAdded: DateTime.parse(json["date_added"]),
        accepted: json["accepted"]);
    friend.dateAccepted = json["date_accepted"];
    friend.profile2.target = Profile.fromJson(json["profile2"]);
    friend.profile1.target = Profile.fromJson(json["profile1"]);
    friend.match = json["match"];

    return friend;
  }

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
