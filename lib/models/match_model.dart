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
    required this.requested,
  });

  int id;
  Profile profile;
  Profile matched;
  String method;
  List<Details> details;
  DateTime dateAdded;
  bool requested;

  factory Match.fromJson(Map<String, dynamic> json) => Match(
        id: json["id"],
        profile: Profile.fromJson(json["profile"]),
        matched: Profile.fromJson(json["matched"]),
        method: json["method"],
        details:
            List<Details>.from(json["details"].map((x) => Details.fromJson(x))),
        dateAdded: DateTime.parse(json["date_added"]),
        requested: json["requested"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "profile": profile.toJson(),
        "matched": matched.toJson(),
        "method": method,
        "details": List<dynamic>.from(details.map((x) => x.toJson())),
        "date_added": dateAdded.toIso8601String(),
        "requested": requested,
      };

  String get matchMethod {
    List<String> methods = [];
    for (var element in details) {
      if (element.name != null) {
        if (!methods.contains("Top Tracks")) {
          methods.add("Top Tracks");
        }
      } else if (element.artistName != null) {
        methods.add("Top Artists");
      }
    }
    return methods.join(", ");
  }
}
