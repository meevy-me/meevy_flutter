// To parse this JSON data, do
//
//     final match = matchFromJson(jsonString);

import 'dart:convert';

import 'package:soul_date/models/details_model.dart';
import 'package:soul_date/models/models.dart';

List<Match> matchFromJson(String str) =>
    List<Match>.from(json.decode(str).map((x) => Match.fromJson(x)));

String matchToJson(List<Match> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Match {
  Match({
    required this.profile,
    required this.matches,
  });

  Profile profile;
  List<MatchElement> matches;

  factory Match.fromJson(Map<String, dynamic> json) => Match(
        profile: Profile.fromJson(json["profile"]),
        matches: List<MatchElement>.from(
            json["matches"].map((x) => MatchElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "profile": profile.toJson(),
        "matches": List<dynamic>.from(matches.map((x) => x.toJson())),
      };

  List<Details> get allItems {
    return matches.expand((element) => element.matches).toList();
  }
}

class MatchElement {
  MatchElement({
    required this.matches,
    required this.method,
  });

  List<Details> matches;
  String method;

  factory MatchElement.fromJson(Map<String, dynamic> json) => MatchElement(
        matches: List<Details>.from(
            json["matches"].map((x) => Details.fromJson(jsonDecode(x)))),
        method: json["method"],
      );

  Map<String, dynamic> toJson() => {
        "matches": List<dynamic>.from(matches.map((x) => x)),
        "method": method,
      };

  @override
  String toString() {
    return method;
  }
}
