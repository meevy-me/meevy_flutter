// To parserequired  this JSON data, do
//
//     final spotifyAlbum = spotifyAlbumFromJson(jsonString);

import 'dart:convert';

import 'package:soul_date/models/Spotify/base_model.dart';

SpotifyAlbum spotifyAlbumFromJson(String str) =>
    SpotifyAlbum.fromJson(json.decode(str));

String spotifyAlbumToJson(SpotifyAlbum data) => json.encode(data.toJson());

class SpotifyAlbum extends SpotifyData {
  SpotifyAlbum({
    required this.artists,
    required this.copyrights,
    required this.externalIds,
    required this.externalUrls,
    required this.genres,
    required this.href,
    required this.id,
    required this.images,
    required this.label,
    required this.name,
    required this.popularity,
    required this.releaseDate,
    required this.releaseDatePrecision,
    required this.totalTracks,
    required this.tracks,
    required this.type,
    required this.uri,
  });

  List<Artist> artists;
  List<Copyright> copyrights;
  ExternalIds externalIds;
  ExternalUrls externalUrls;
  List<dynamic> genres;
  String href;
  String id;
  List<Image> images;
  String label;
  String name;
  int popularity;
  DateTime releaseDate;
  String releaseDatePrecision;
  int totalTracks;
  Tracks tracks;
  @override
  String type;
  @override
  String uri;

  factory SpotifyAlbum.fromJson(Map<String, dynamic> json) => SpotifyAlbum(
        artists:
            List<Artist>.from(json["artists"].map((x) => Artist.fromJson(x))),
        copyrights: List<Copyright>.from(
            json["copyrights"].map((x) => Copyright.fromJson(x))),
        externalIds: ExternalIds.fromJson(json["external_ids"]),
        externalUrls: ExternalUrls.fromJson(json["external_urls"]),
        genres: List<dynamic>.from(json["genres"].map((x) => x)),
        href: json["href"],
        id: json["id"],
        images: List<Image>.from(json["images"].map((x) => Image.fromJson(x))),
        label: json["label"],
        name: json["name"],
        popularity: json["popularity"],
        releaseDate: DateTime.parse(json["release_date"]),
        releaseDatePrecision: json["release_date_precision"],
        totalTracks: json["total_tracks"],
        tracks: Tracks.fromJson(json["tracks"]),
        type: json["type"],
        uri: json["uri"],
      );

  Map<String, dynamic> toJson() => {
        "artists": List<dynamic>.from(artists.map((x) => x.toJson())),
        "copyrights": List<dynamic>.from(copyrights.map((x) => x.toJson())),
        "external_ids": externalIds.toJson(),
        "external_urls": externalUrls.toJson(),
        "genres": List<dynamic>.from(genres.map((x) => x)),
        "href": href,
        "id": id,
        "images": List<dynamic>.from(images.map((x) => x.toJson())),
        "label": label,
        "name": name,
        "popularity": popularity,
        "release_date":
            "${releaseDate.year.toString().padLeft(4, '0')}-${releaseDate.month.toString().padLeft(2, '0')}-${releaseDate.day.toString().padLeft(2, '0')}",
        "release_date_precision": releaseDatePrecision,
        "total_tracks": totalTracks,
        "tracks": tracks.toJson(),
        "type": type,
        "uri": uri,
      };

  @override
  String get caption => artists.first.name;

  @override
  String get image {
    return images.first.url;
  }

  @override
  String get itemName => name;

  @override
  String get url => externalUrls.spotify;
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
  String uri;

  factory Artist.fromJson(Map<String, dynamic> json) => Artist(
        externalUrls: ExternalUrls.fromJson(json["external_urls"]),
        href: json["href"],
        id: json["id"],
        name: json["name"],
        uri: json["uri"],
      );

  Map<String, dynamic> toJson() => {
        "external_urls": externalUrls.toJson(),
        "href": href,
        "id": id,
        "name": name,
        "uri": uri,
      };

  @override
  String toString() {
    return name;
  }
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

class Copyright {
  Copyright({
    required this.text,
    required this.type,
  });

  String text;
  String type;

  factory Copyright.fromJson(Map<String, dynamic> json) => Copyright(
        text: json["text"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "text": text,
        "type": type,
      };
}

class ExternalIds {
  ExternalIds({
    required this.upc,
  });

  String upc;

  factory ExternalIds.fromJson(Map<String, dynamic> json) => ExternalIds(
        upc: json["upc"],
      );

  Map<String, dynamic> toJson() => {
        "upc": upc,
      };
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

class Tracks {
  Tracks({
    required this.href,
    required this.items,
    required this.limit,
    required this.next,
    required this.offset,
    required this.previous,
    required this.total,
  });

  String href;
  List<Item> items;
  int limit;
  dynamic next;
  int offset;
  dynamic previous;
  int total;

  factory Tracks.fromJson(Map<String, dynamic> json) => Tracks(
        href: json["href"],
        items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
        limit: json["limit"],
        next: json["next"],
        offset: json["offset"],
        previous: json["previous"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "href": href,
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
        "limit": limit,
        "next": next,
        "offset": offset,
        "previous": previous,
        "total": total,
      };
}

class Item {
  Item({
    required this.artists,
    required this.discNumber,
    required this.durationMs,
    required this.explicit,
    required this.externalUrls,
    required this.href,
    required this.id,
    required this.isLocal,
    required this.name,
    required this.previewUrl,
    required this.trackNumber,
    required this.uri,
  });

  List<Artist> artists;
  int discNumber;
  int durationMs;
  bool explicit;
  ExternalUrls externalUrls;
  String href;
  String id;
  bool isLocal;
  String name;
  String previewUrl;
  int trackNumber;
  String uri;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        artists:
            List<Artist>.from(json["artists"].map((x) => Artist.fromJson(x))),
        discNumber: json["disc_number"],
        durationMs: json["duration_ms"],
        explicit: json["explicit"],
        externalUrls: ExternalUrls.fromJson(json["external_urls"]),
        href: json["href"],
        id: json["id"],
        isLocal: json["is_local"],
        name: json["name"],
        previewUrl: json["preview_url"],
        trackNumber: json["track_number"],
        uri: json["uri"],
      );

  Map<String, dynamic> toJson() => {
        "artists": List<dynamic>.from(artists.map((x) => x.toJson())),
        "disc_number": discNumber,
        "duration_ms": durationMs,
        "explicit": explicit,
        "external_urls": externalUrls.toJson(),
        "href": href,
        "id": id,
        "is_local": isLocal,
        "name": name,
        "preview_url": previewUrl,
        "track_number": trackNumber,
        "uri": uri,
      };
}
