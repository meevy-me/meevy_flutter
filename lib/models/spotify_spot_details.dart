// To parse this JSON data, do
//
//     final spotifyDetails = spotifyDetailsFromJson(jsonString);

import 'dart:convert';

import 'Spotify/base_model.dart';

SpotifyDetails spotifyDetailsFromJson(String str) =>
    SpotifyDetails.fromJson(json.decode(str));

String spotifyDetailsToJson(SpotifyDetails data) => json.encode(data.toJson());

class SpotifyDetails {
  SpotifyDetails({
    // required this.context,
    required this.item,
  });

  // Context? context;
  Item item;

  factory SpotifyDetails.fromJson(Map<String, dynamic> json) {
    return SpotifyDetails(
      // context:
      //     json['context'] == null ? null : Context.fromJson(json["context"]),
      item: json.containsKey('item')
          ? Item.fromJson(json['item'])
          : Item.fromJson(json),
    );
  }
  Map<String, dynamic> toJson() => {
        "item": item.toJson(),
      };
}

class Context {
  Context({
    required this.externalUrls,
    required this.href,
    required this.type,
    required this.uri,
  });

  ExternalUrls externalUrls;
  String href;
  String type;
  String uri;

  factory Context.fromJson(Map<String, dynamic> json) => Context(
        externalUrls: ExternalUrls.fromJson(json["external_urls"]),
        href: json["href"],
        type: json["type"],
        uri: json["uri"],
      );

  Map<String, dynamic> toJson() => {
        "external_urls": externalUrls.toJson(),
        "href": href,
        "type": type,
        "uri": uri,
      };
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

class Item extends SpotifyData {
  Item({
    required this.album,
    required this.artists,
    required this.discNumber,
    required this.durationMs,
    required this.explicit,
    required this.externalIds,
    required this.externalUrls,
    required this.href,
    required this.id,
    required this.isLocal,
    required this.name,
    required this.popularity,
    required this.trackNumber,
    required this.type,
    required this.uri,
  });

  Album album;
  List<Artist> artists;
  int discNumber;
  int durationMs;
  bool explicit;
  ExternalIds externalIds;
  ExternalUrls externalUrls;
  String href;
  @override
  String id;
  bool isLocal;
  String name;
  int popularity;
  int trackNumber;
  @override
  String type;
  @override
  String uri;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        album: Album.fromJson(json["album"]),
        artists:
            List<Artist>.from(json["artists"].map((x) => Artist.fromJson(x))),
        discNumber: json["disc_number"],
        durationMs: json["duration_ms"],
        explicit: json["explicit"],
        externalIds: ExternalIds.fromJson(json["external_ids"]),
        externalUrls: ExternalUrls.fromJson(json["external_urls"]),
        href: json["href"],
        id: json["id"],
        isLocal: json["is_local"],
        name: json["name"],
        popularity: json["popularity"],
        trackNumber: json["track_number"],
        type: json["type"],
        uri: json["uri"],
      );

  @override
  Map<String, dynamic> toJson() => {
        "album": album.toJson(),
        "artists": List<dynamic>.from(artists.map((x) => x.toJson())),
        "disc_number": discNumber,
        "duration_ms": durationMs,
        "explicit": explicit,
        "external_ids": externalIds.toJson(),
        "external_urls": externalUrls.toJson(),
        "href": href,
        "id": id,
        "is_local": isLocal,
        "name": name,
        "popularity": popularity,
        "track_number": trackNumber,
        "type": type,
        "uri": uri,
      };

  @override
  String toString() {
    return name;
  }

  @override
  String get caption => artists.join(", ");

  @override
  String get image => album.images.first.url;

  @override
  String get itemName => name;

  @override
  String get url => externalUrls.spotify;
}

class Album {
  Album({
    required this.albumType,
    required this.artists,
    required this.href,
    required this.id,
    required this.images,
    required this.name,
    // required this.releaseDate,
    required this.releaseDatePrecision,
    required this.totalTracks,
    required this.type,
    required this.uri,
    required this.externalUrls,
  });

  String albumType;
  List<Artist> artists;
  // List<String> availableMarkets;
  ExternalUrls externalUrls;
  String href;
  String id;
  List<Image> images;
  String name;
  // DateTime releaseDate;
  String releaseDatePrecision;
  int totalTracks;
  String type;
  String uri;

  factory Album.fromJson(Map<String, dynamic> json) => Album(
        albumType: json["album_type"],
        artists:
            List<Artist>.from(json["artists"].map((x) => Artist.fromJson(x))),

        externalUrls: ExternalUrls.fromJson(json["external_urls"]),
        href: json["href"],
        id: json["id"],
        images: List<Image>.from(json["images"].map((x) => Image.fromJson(x))),
        name: json["name"],
        // releaseDate: DateTime.parse(json["release_date"]),
        releaseDatePrecision: json["release_date_precision"],
        totalTracks: json["total_tracks"],
        type: json["type"],
        uri: json["uri"],
      );

  Map<String, dynamic> toJson() => {
        "album_type": albumType,
        "artists": List<dynamic>.from(artists.map((x) => x.toJson())),
        // "available_markets": List<dynamic>.from(availableMarkets.map((x) => x)),
        "external_urls": externalUrls.toJson(),
        "href": href,
        "id": id,
        "images": List<dynamic>.from(images.map((x) => x.toJson())),
        "name": name,
        // "release_date":
        //     "${releaseDate.year.toString().padLeft(4, '0')}-${releaseDate.month.toString().padLeft(2, '0')}-${releaseDate.day.toString().padLeft(2, '0')}",
        "release_date_precision": releaseDatePrecision,
        "total_tracks": totalTracks,
        "type": type,
        "uri": uri,
      };
}

class Artist {
  Artist({
    required this.externalUrls,
    required this.href,
    required this.id,
    required this.name,
    required this.uri,
  });

  ExternalUrls externalUrls;
  String href;
  String id;
  String name;
  // String type;
  String uri;

  factory Artist.fromJson(Map<String, dynamic> json) => Artist(
        externalUrls: ExternalUrls.fromJson(json["external_urls"]),
        href: json["href"],
        id: json["id"],
        name: json["name"],
        // type: json["type"],
        uri: json["uri"],
      );

  Map<String, dynamic> toJson() => {
        "external_urls": externalUrls.toJson(),
        "href": href,
        "id": id,
        "name": name,
        // "type": type,
        "uri": uri,
      };

  @override
  String toString() {
    return name;
  }
}

class Image {
  Image({
    required this.height,
    required this.url,
    required this.width,
  });

  int height;
  String url;
  int width;

  factory Image.fromJson(Map<String, dynamic> json) => Image(
        height: json["height"],
        url: json["url"],
        width: json["width"],
      );

  Map<String, dynamic> toJson() => {
        "height": height,
        "url": url,
        "width": width,
      };
}

class ExternalIds {
  ExternalIds({
    required this.isrc,
  });

  String isrc;

  factory ExternalIds.fromJson(Map<String, dynamic> json) => ExternalIds(
        isrc: json["isrc"],
      );

  Map<String, dynamic> toJson() => {
        "isrc": isrc,
      };
}
