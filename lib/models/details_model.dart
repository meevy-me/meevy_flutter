import 'dart:convert';

import 'package:soul_date/constants/constants.dart';
import 'package:soul_date/models/match_base.dart';
import 'package:soul_date/models/models.dart';

List<Details> detailsFromJson(String str) =>
    List<Details>.from(json.decode(str).map((x) => Details.fromJson(x)));

class Details extends SoulMatch {
  Details(
      {this.href,
      this.image,
      this.artistId,
      this.artistName,
      this.spotifyLink,
      this.id,
      this.uri,
      this.name,
      this.type,
      this.total,
      this.genres,
      this.images,
      this.spotify,
      this.popularity,
      this.album});

  String? href;
  String? image;
  String? artistId;
  String? artistName;
  String? spotifyLink;
  String? id;
  String? uri;
  String? name;
  String? type;
  int? total;
  dynamic genres;
  dynamic images;
  String? spotify;
  int? popularity;
  Album? album;

  factory Details.fromJson(Map<String, dynamic> data) {
    return Details(
        href: data["href"],
        image: data["image"],
        artistId: data["artistID"],
        artistName: data["artistName"],
        spotifyLink: data["spotifyLink"],
        id: data["id"],
        uri: data["uri"],
        name: data["name"],
        type: data["type"],
        total: data["total"],
        genres: data["genres"],
        images: data['images'],
        spotify: data["spotify"],
        popularity: data["popularity"],
        album:
            data.containsKey('album') ? Album.fromJson(data['album']) : null);
  }

  String get detailImage {
    if (image != null) {
      return image!;
    } else if (images != null && images is List) {
      return images[0]['url'];
    } else if (album != null) {
      return album!.images.first.url;
    } else {
      return secondaryAvatarUrl;
    }
  }

  Map<String, dynamic> toJson() => {
        "href": href,
        "image": image,
        "artistID": artistId,
        "artistName": artistName,
        "spotifyLink": spotifyLink,
        "id": id,
        "uri": uri,
        "name": name,
        "total": total,
        "genres": genres,
        "images": images,
        "spotify": spotify,
        "popularity": popularity,
      };

  @override
  String get matchImage {
    return detailImage;
  }

  @override
  String get matchMethod {
    return "Top Artists";
  }

  @override
  String get matchName {
    return artistName ?? name!;
  }

  @override
  String get matchUri {
    return spotifyLink!;
  }
}

class ImagesImage {
  ImagesImage({
    required this.url,
    this.width,
    this.height,
  });

  String url;
  int? width;
  int? height;

  factory ImagesImage.fromJson(Map<String, dynamic> json) => ImagesImage(
        url: json["url"],
        width: json["width"],
        height: json["height"],
      );

  Map<String, dynamic> toJson() => {
        "url": url,
        "width": width,
        "height": height,
      };
}
