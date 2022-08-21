import 'package:soul_date/models/SpotifySearch/my_spotify_playlists.dart';
import 'package:soul_date/models/SpotifySearch/spotify_search.dart';

class FavouriteTrack {
  final int id;
  final SongItem details;

  FavouriteTrack(this.id, this.details);
}

class FavouritePlaylist {
  final int id;
  final PlaylistItem details;

  FavouritePlaylist(this.id, this.details);
}
