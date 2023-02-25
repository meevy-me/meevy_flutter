import 'package:soul_date/main.dart';
import 'package:soul_date/models/Spotify/base_model.dart';
import 'package:soul_date/services/spotify.dart';

class SpotifyFormatText {
  final String type;
  final String id;

  SpotifyFormatText({required this.type, required this.id});
}

class SpotifyHelper {
  static Future<bool> play(SpotifyData item) async {
    if (item.spotifyDataType != SpotifyDataType.user) {
      Map<String, dynamic> body = {};
      if (item.spotifyDataType == SpotifyDataType.track) {
        body = {
          "uris": [item.uri]
        };
      } else if (item.spotifyDataType == SpotifyDataType.album ||
          item.spotifyDataType == SpotifyDataType.playlist ||
          item.spotifyDataType == SpotifyDataType.artist) {
        body = {"context_uris": item.uri};
      }
      return await Spotify().startTrack(body);
    }
    return false;
  }

  static Future<bool> queue(SpotifyData item) async {
    if (item.spotifyDataType == SpotifyDataType.track) {
      return await Spotify().queueTrack(item.uri);
    }
    return false;
  }

  static SpotifyFormatText parseUrl(String url) {
    if (isSpotifyLink(url)) {
      var text = url.replaceAll("https://open.spotify.com/", "");
      var keys = text.split("/");
      var field = keys[0];

      var fieldId = keys[1];
      if (fieldId.contains("?")) {
        fieldId = fieldId.split("?")[0];
      }
      return SpotifyFormatText(type: field, id: fieldId);
    }

    throw "Not a valid spotify url";
  }
}
