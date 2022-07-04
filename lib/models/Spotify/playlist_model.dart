// To parse required this JSON data, do
//
//     final spotifyPlaylist = spotifyPlaylistFromJson(jsonString);

import 'dart:convert';

import 'package:soul_date/models/Spotify/base_model.dart';

SpotifyPlaylist spotifyPlaylistFromJson(String str) =>
    SpotifyPlaylist.fromJson(json.decode(str));

String spotifyPlaylistToJson(SpotifyPlaylist data) =>
    json.encode(data.toJson());

class SpotifyPlaylist extends SpotifyData {
  SpotifyPlaylist({
    required this.description,
    required this.externalUrls,
    required this.followers,
    required this.href,
    required this.id,
    required this.images,
    required this.name,
    required this.owner,
    required this.uri,
  });

  String description;
  ExternalUrls externalUrls;
  Followers followers;
  String href;
  String id;
  List<Image> images;
  String name;
  Owner owner;
  // dynamic primaryColor;
  // bool public;
  // String snapshotId;
  // Tracks tracks;
  // String type;
  String uri;

  factory SpotifyPlaylist.fromJson(Map<String, dynamic> json) =>
      SpotifyPlaylist(
        description: json["description"],
        externalUrls: ExternalUrls.fromJson(json["external_urls"]),
        followers: Followers.fromJson(json["followers"]),
        href: json["href"],
        id: json["id"],
        images: List<Image>.from(json["images"].map((x) => Image.fromJson(x))),
        name: json["name"],
        owner: Owner.fromJson(json["owner"]),
        uri: json["uri"],
      );

  Map<String, dynamic> toJson() => {
        "description": description,
        "external_urls": externalUrls.toJson(),
        "followers": followers.toJson(),
        "href": href,
        "id": id,
        "images": List<dynamic>.from(images.map((x) => x.toJson())),
        "name": name,
        "owner": owner.toJson(),
        "uri": uri,
      };

  @override
  String get caption => owner.displayName;

  @override
  String get image => images.first.url;

  @override
  String get itemName => name;

  @override
  String get type => "Playlist";

  @override
  String get url => externalUrls.spotify;
}

class ExternalUrls {
  ExternalUrls({
    required this.spotify,
  });

  String spotify;

  factory ExternalUrls.fromJson(Map<String, dynamic> json) => ExternalUrls(
        spotify: json["spotify"],
      );

  Map<String, dynamic> toJson() => {
        "spotify": spotify,
      };
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

class Image {
  Image({
    // required this.height,
    required this.url,
    // required this.width,
  });

  // int height;
  String url;
  // int width;

  factory Image.fromJson(Map<String, dynamic> json) => Image(
        // height: json["height"] == null ? null : json["height"],
        url: json["url"],
        // width: json["width"] == null ? null : json["width"],
      );

  Map<String, dynamic> toJson() => {
        // "height": height == null ? null : height,
        "url": url,
        // "width": width == null ? null : width,
      };
}

class Owner {
  Owner({
    required this.displayName,
    required this.externalUrls,
    required this.href,
    required this.id,
    required this.uri,
  });

  String displayName;
  ExternalUrls externalUrls;
  String href;
  String id;
  String uri;

  factory Owner.fromJson(Map<String, dynamic> json) => Owner(
        displayName: json["display_name"],
        externalUrls: ExternalUrls.fromJson(json["external_urls"]),
        href: json["href"],
        id: json["id"],
        uri: json["uri"],
      );

  Map<String, dynamic> toJson() => {
        "display_name": displayName,
        "external_urls": externalUrls.toJson(),
        "href": href,
        "id": id,
        "uri": uri,
      };
}
