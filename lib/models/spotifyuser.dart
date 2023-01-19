import 'package:soul_date/constants/constants.dart';
import 'package:soul_date/models/Spotify/base_model.dart';

class SpotifyUser extends SpotifyData {
  @override
  final String id;
  @override
  final String image;
  final String displayName;
  @override
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
        image: json['images'].isNotEmpty
            ? json['images'][0]['url']
            : secondaryAvatarUrl,
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

  @override
  String get caption => "";

  @override
  String get itemName => displayName;

  @override
  Map<String, dynamic> toJson() {
    return {};
  }

  @override
  String get type => SpotifyDataType.user.toString();

  @override
  String get url => profileLink;
}
