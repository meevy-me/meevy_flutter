enum SpotifyDataType { album, playlist, track, user }

abstract class SpotifyData {
  String get itemName;
  String get image;
  String get caption;
  String get type;
  String get url;
  String get uri;

  String get id;

  Map<String, dynamic> toJson();

  SpotifyDataType get spotifyDataType => SpotifyDataType.track;
}
