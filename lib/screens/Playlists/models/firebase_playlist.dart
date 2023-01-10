import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:soul_date/models/Spotify/base_model.dart';
import 'package:soul_date/models/Spotify/playlist_model.dart';

import '../../../models/profile_model.dart';

class FirebasePlaylist {
  final Profile sender;
  final SpotifyData item;
  final List<Profile> audience;
  final DateTime dateSent;
  final bool opened;
  final String? caption;
  final String id;

  FirebasePlaylist(
      {required this.sender,
      required this.item,
      required this.audience,
      required this.dateSent,
      required this.opened,
      required this.caption,
      required this.id});

  factory FirebasePlaylist.fromSnapshot(DocumentSnapshot json) {
    return FirebasePlaylist(
      id: json.id,
      sender: Profile.fromJson(json['sender']),
      item: SpotifyPlaylist.fromJson(json['track']),
      audience:
          List<Profile>.from(json['audience'].map((e) => Profile.fromJson(e))),
      dateSent: DateTime.parse(json['date_sent']),
      opened: json['opened'],
      caption: json['caption'],
    );
  }

  void play() {}
}
