// To parse required this JSON data, do
//
//     final spotifyuser = spotifyuserFromJson(jsonString);

import 'dart:convert';

import 'package:soul_date/models/Spotify/album_model.dart';
import 'package:soul_date/models/Spotify/artist_model.dart';
import 'package:soul_date/models/Spotify/base_model.dart';

Spotifyuser spotifyuserFromJson(String str) =>
    Spotifyuser.fromJson(json.decode(str));

String spotifyuserToJson(Spotifyuser data) => json.encode(data.toJson());

class Spotifyuser extends SpotifyData {
  Spotifyuser({
    required this.displayName,
    required this.externalUrls,
    required this.followers,
    required this.href,
    required this.id,
    required this.images,
    required this.type,
    required this.uri,
  });

  String displayName;
  ExternalUrls externalUrls;
  Followers followers;
  String href;
  String id;
  List<dynamic> images;
  @override
  String type;
  String uri;

  factory Spotifyuser.fromJson(Map<String, dynamic> json) => Spotifyuser(
        displayName: json["display_name"],
        externalUrls: ExternalUrls.fromJson(json["external_urls"]),
        followers: Followers.fromJson(json["followers"]),
        href: json["href"],
        id: json["id"],
        images: List<dynamic>.from(json["images"].map((x) => x)),
        type: json["type"],
        uri: json["uri"],
      );

  Map<String, dynamic> toJson() => {
        "display_name": displayName,
        "external_urls": externalUrls.toJson(),
        "followers": followers.toJson(),
        "href": href,
        "id": id,
        "images": List<dynamic>.from(images.map((x) => x)),
        "type": type,
        "uri": uri,
      };

  @override
  String get caption => "";

  @override
  String get image => images.isNotEmpty ? images.first['url'] : "";

  @override
  String get itemName => displayName;

  @override
  String get url => externalUrls.spotify;
}
