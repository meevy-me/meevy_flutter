// To parse this JSON data, do
//
//     final match = matchFromJson(jsonString);

import 'dart:convert';

import 'package:get/get.dart';
import 'package:soul_date/controllers/SoulController.dart';
import 'package:soul_date/models/details_model.dart';
import 'package:soul_date/models/profile_model.dart';

List<Match> matchFromJson(String str) =>
    List<Match>.from(json.decode(str).map((x) => Match.fromJson(x)));

String matchToJson(List<Match> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Match {
  Match({
    required this.matched,
    required this.method,
    required this.details,
    // required this.dateAdded,
    // required this.friends,
  });

  Profile matched;
  List<Details> details;
  String method;
  // DateTime dateAdded;
  // String friends;
  factory Match.fromJson(Map<String, dynamic> json) {
    json['match'] as List;
    return Match(
        matched: Profile.fromJson(json["user"]),
        method: json['method'],
        details: List<Details>.from(json['match'].map((x) {
          return Details.fromJson(x);
        }))
        // dateAdded: DateTime.parse(json["date_added"]),
        // friends: json["isFriend"],
        );
  }

  Map<String, dynamic> toJson() => {
        // "profile": profile.toJson(),
        // "matched": matched.toJson(),
        // "method": method,
        "details": List<dynamic>.from(details.map((x) => x.toJson())),
        // "date_added": dateAdded.toIso8601String(),
        "requested": requested,
      };

  String? get matchMethod {
    // if (method == 'T') {
    return "Top artist or track";
    // } else if (method == 'F') {
    //   return 'Favourite song';
    // }
    // return "We recommend";
  }

  Future<bool> get requested async {
    final SoulController controller = Get.find<SoulController>();
    return controller.isFriendRequested(matched);
  }
}
