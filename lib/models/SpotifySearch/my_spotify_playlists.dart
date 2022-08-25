// To parse this JSON data, do
//
//     final mySpotifyPlaylists = mySpotifyPlaylistsFromJson(jsonString);

import 'dart:convert';

import 'package:soul_date/constants/constants.dart';
import 'package:soul_date/models/SpotifySearch/spotify_favourite_item.dart';

MySpotifyPlaylists mySpotifyPlaylistsFromJson(String str) =>
    MySpotifyPlaylists.fromJson(json.decode(str));

String mySpotifyPlaylistsToJson(MySpotifyPlaylists data) =>
    json.encode(data.toJson());

class MySpotifyPlaylists {
  MySpotifyPlaylists({
    required this.href,
    required this.items,
    required this.limit,
    required this.next,
    required this.offset,
    required this.previous,
    required this.total,
  });

  String href;
  List<PlaylistItem> items;
  int limit;
  String? next;
  int offset;
  dynamic previous;
  int total;

  factory MySpotifyPlaylists.fromJson(Map<String, dynamic> json) =>
      MySpotifyPlaylists(
        href: json["href"],
        items: List<PlaylistItem>.from(
            json["items"].map((x) => PlaylistItem.fromJson(x))),
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

class PlaylistItem extends SpotifyFavouriteItem {
  PlaylistItem({
    required this.collaborative,
    required this.description,
    required this.externalUrls,
    required this.href,
    required this.id,
    required this.images,
    required this.name,
    required this.owner,
    required this.primaryColor,
    required this.public,
    required this.snapshotId,
    required this.tracks,
    required this.type,
    required this.uri,
  });

  bool collaborative;
  String description;
  ExternalUrls externalUrls;
  @override
  String href;
  @override
  String id;
  List<Image> images;
  String name;
  Owner owner;
  dynamic primaryColor;
  bool public;
  String snapshotId;
  Tracks tracks;
  String type;
  @override
  String uri;

  factory PlaylistItem.fromJson(Map<String, dynamic> json) => PlaylistItem(
        collaborative: json["collaborative"],
        description: json["description"],
        externalUrls: ExternalUrls.fromJson(json["external_urls"]),
        href: json["href"],
        id: json["id"],
        images: List<Image>.from(json["images"].map((x) => Image.fromJson(x))),
        name: json["name"],
        owner: Owner.fromJson(json["owner"]),
        primaryColor: json["primary_color"],
        public: json["public"],
        snapshotId: json["snapshot_id"],
        tracks: Tracks.fromJson(json["tracks"]),
        type: json["type"],
        uri: json["uri"],
      );

  @override
  Map<String, dynamic> toJson() => {
        "collaborative": collaborative,
        "description": description,
        "external_urls": externalUrls.toJson(),
        "href": href,
        "id": id,
        "images": List<dynamic>.from(images.map((x) => x.toJson())),
        "name": name,
        "owner": owner.toJson(),
        "primary_color": primaryColor,
        "public": public,
        "snapshot_id": snapshotId,
        "tracks": tracks.toJson(),
        "type": type,
        "uri": uri,
      };

  @override
  String get caption => "${tracks.total.toString()} songs";

  @override
  String get imageUrl =>
      images.isNotEmpty ? images.first.url : defaultAvatarUrl;

  @override
  String get subTitle => owner.displayName;

  @override
  String get title => name;
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

class Image {
  Image({
    required this.height,
    required this.url,
    required this.width,
  });

  dynamic height;
  String url;
  dynamic width;

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

class Owner {
  Owner({
    required this.displayName,
    required this.externalUrls,
    required this.href,
    required this.id,
    required this.type,
    required this.uri,
  });

  String displayName;
  ExternalUrls externalUrls;
  String href;
  String id;
  String type;
  String uri;

  factory Owner.fromJson(Map<String, dynamic> json) => Owner(
        displayName: json["display_name"],
        externalUrls: ExternalUrls.fromJson(json["external_urls"]),
        href: json["href"],
        id: json["id"],
        type: json["type"],
        uri: json["uri"],
      );

  Map<String, dynamic> toJson() => {
        "display_name": displayName,
        "external_urls": externalUrls.toJson(),
        "href": href,
        "id": id,
        "type": type,
        "uri": uri,
      };
}

class Tracks {
  Tracks({
    required this.href,
    required this.total,
  });

  String href;
  int total;

  factory Tracks.fromJson(Map<String, dynamic> json) => Tracks(
        href: json["href"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "href": href,
        "total": total,
      };
}
