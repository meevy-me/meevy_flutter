// To parse this JSON data, do
//
//     final match = matchFromJson(jsonString);

import 'dart:convert';

import 'package:soul_date/models/details_model.dart';
import 'package:soul_date/models/profile_model.dart';

List<Match> matchFromJson(String str) =>
    List<Match>.from(json.decode(str).map((x) => Match.fromJson(x)));

String matchToJson(List<Match> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Match {
  Match({
    required this.id,
    required this.profile,
    required this.matched,
    required this.method,
    required this.details,
    required this.dateAdded,
    required this.friends,
  });

  int id;
  Profile profile;
  Profile matched;
  String method;
  List<Details> details;
  DateTime dateAdded;
  String friends;
  factory Match.fromJson(Map<String, dynamic> json) => Match(
        id: json["id"],
        profile: Profile.fromJson(json["profile"]),
        matched: Profile.fromJson(json["matched"]),
        method: json["method"],
        details:
            List<Details>.from(json["details"].map((x) => Details.fromJson(x))),
        dateAdded: DateTime.parse(json["date_added"]),
        friends: json["isFriend"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        // "profile": profile.toJson(),
        // "matched": matched.toJson(),
        "method": method,
        "details": List<dynamic>.from(details.map((x) => x.toJson())),
        "date_added": dateAdded.toIso8601String(),
        "requested": requested,
      };

  String? get matchMethod {
    if (method == 'T') {
      return 'Top artists or tracks';
    } else if (method == 'F') {
      return 'Favourite song';
    }
    return "We recommend";
  }

  bool get requested {
    if (friends == 'F') {
      return true;
    } else if (friends == 'P') {
      return true;
    } else {
      return false;
    }
  }
}
