class SpotifyUser {
  final String id;
  final String image;
  final String displayName;
  final String uri;
  final String profileLink;
  final String country;
  SpotifyUser({
    required this.id,
    required this.image,
    required this.displayName,
    required this.uri,
    required this.profileLink,
    required this.country,
  });

  factory SpotifyUser.fromJson(Map<String, dynamic> json) {
    return SpotifyUser(
        id: json["id"],
        image: json['images'][0]['url'],
        displayName: json['display_name'],
        uri: json['uri'],
        profileLink: json['href'],
        country: json['country']);
  }

  @override
  String toString() {
    return "id: $id";
  }

  bool get isValid {
    return true;
  }
}
