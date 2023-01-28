import 'dart:convert';

import 'package:jiffy/jiffy.dart';
import 'package:soul_date/models/spotify_spot_details.dart';
import 'profile_model.dart';

List<Spot> spotFromJson(String str) =>
    List<Spot>.from(json.decode(str).map((x) => Spot.fromJson(x)));

class Spot {
  Profile profile;
  SpotifyDetails details;
  DateTime dateAdded;
  String caption;
  int id;
  Spot(
      {required this.profile,
      required this.id,
      required this.details,
      required this.dateAdded,
      required this.caption});

  factory Spot.fromJson(Map<String, dynamic> json) => Spot(
      id: json['id'],
      profile: Profile.fromJson(json['profile']),
      caption: json['caption'],
      details: SpotifyDetails.fromJson(json['spotifyDetails']),
      dateAdded: DateTime.parse(json["date_posted"]));

  Map<String, dynamic> toJson() => {
        // "profile": profile.toJson(),
        "spotifyDetails": details.toJson(),
        "date_posted": dateAdded.toIso8601String(),
        "caption": caption,
      };

  String get datePosted {
    // var diff = DateTime.now().subtract(dateAdded.);
    return Jiffy(dateAdded).fromNow();
  }
}

List<SpotsView> spotsViewFromJson(String str) =>
    List<SpotsView>.from(json.decode(str).map((x) => SpotsView.fromJson(x)));

String spotsViewToJson(List<SpotsView> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SpotsView {
  Profile profile;
  List<Spot> spots;

  SpotsView({required this.profile, required this.spots});
  factory SpotsView.fromJson(Map<String, dynamic> json) => SpotsView(
      profile: Profile.fromJson(json["profile"]),
      spots: List<Spot>.from(json["spots"].map((x) => Spot.fromJson(x))));

  Map<String, dynamic> toJson() => {
        // "profile": profile.toJson(),
        "spots": List<dynamic>.from(spots.map((x) => x.toJson())),
      };

  @override
  String toString() {
    return profile.name;
  }
}
