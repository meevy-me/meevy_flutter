import 'package:soul_date/models/Spotify/album_model.dart';
import 'package:soul_date/models/Spotify/playlist_model.dart';
import 'package:soul_date/models/Spotify/user_model.dart';
import 'package:soul_date/models/models.dart' as models;
import 'package:soul_date/services/spotify_helper.dart';

enum SpotifyDataType { album, playlist, track, user, artist }

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

  static SpotifyData spotifyDataFactory(Map<String, dynamic> json) {
    if (json['type'] == 'track') {
      return models.Item.fromJson(json);
    } else if (json.containsKey('followers')) {
      return SpotifyPlaylist.fromJson(json);
    } else if (json['type'] == 'album') {
      return SpotifyAlbum.fromJson(json);
    }
    return Spotifyuser.fromJson(json);
  }

  bool get playable {
    if (spotifyDataType == SpotifyDataType.playlist ||
        spotifyDataType == SpotifyDataType.track ||
        spotifyDataType == SpotifyDataType.artist) {
      return true;
    }
    return false;
  }

  Future<bool> play() async {
    return await SpotifyHelper.play(this);
  }

  Future<bool> queue() async {
    return await SpotifyHelper.queue(this);
  }
}
