import 'package:soul_date/models/Spotify/base_model.dart';

abstract class FirebasePlaylist {
  String get name;
  String get description;

  void play();

  Future<List<SpotifyData>> getPlaylistTracks();
}
