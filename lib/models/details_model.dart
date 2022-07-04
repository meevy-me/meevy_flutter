import 'dart:convert';

class Details {
  Details({
    this.href,
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
  });

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
    );
  }

  String get detailImage {
    if (image != null) {
      return image!;
    } else if (images != null && images is List) {
      return images[0]['url'];
    } else {
      return json.decode(images.replaceAll("'", '"')).first['url'];
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
