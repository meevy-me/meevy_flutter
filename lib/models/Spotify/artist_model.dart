// To parserequired this JSON data, do
//
//     final spotifyArtist = spotifyArtistFromJson(jsonString);

import 'dart:convert';

import 'package:soul_date/models/Spotify/album_model.dart';
import 'package:soul_date/models/Spotify/base_model.dart';

SpotifyArtist spotifyArtistFromJson(String str) =>
    SpotifyArtist.fromJson(json.decode(str));

String spotifyArtistToJson(SpotifyArtist data) => json.encode(data.toJson());

class SpotifyArtist extends SpotifyData {
  SpotifyArtist({
    required this.externalUrls,
    required this.followers,
    required this.genres,
    required this.href,
    required this.id,
    required this.images,
    required this.name,
    required this.popularity,
    required this.type,
    required this.uri,
  });

  ExternalUrls externalUrls;
  Followers followers;
  List<String> genres;
  String href;
  String id;
  List<Image> images;
  String name;
  int popularity;
  @override
  String type;
  @override
  String uri;

  factory SpotifyArtist.fromJson(Map<String, dynamic> json) => SpotifyArtist(
        externalUrls: ExternalUrls.fromJson(json["external_urls"]),
        followers: Followers.fromJson(json["followers"]),
        genres: List<String>.from(json["genres"].map((x) => x)),
        href: json["href"],
        id: json["id"],
        images: List<Image>.from(json["images"].map((x) => Image.fromJson(x))),
        name: json["name"],
        popularity: json["popularity"],
        type: json["type"],
        uri: json["uri"],
      );

  Map<String, dynamic> toJson() => {
        "external_urls": externalUrls.toJson(),
        "followers": followers.toJson(),
        "genres": List<dynamic>.from(genres.map((x) => x)),
        "href": href,
        "id": id,
        "images": List<dynamic>.from(images.map((x) => x.toJson())),
        "name": name,
        "popularity": popularity,
        "type": type,
        "uri": uri,
      };

  @override
  String get caption => genres.take(2).join(", ");

  @override
  String get image => images.first.url;

  @override
  String get itemName => name;

  @override
  String get url => externalUrls.spotify;
}

class Followers {
  Followers({
    required this.href,
    required this.total,
  });

  dynamic href;
  int total;

  factory Followers.fromJson(Map<String, dynamic> json) => Followers(
        href: json["href"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "href": href,
        "total": total,
      };
}
