import 'package:intl/intl.dart';
import 'package:soul_date/models/Spotify/base_model.dart';
import 'package:soul_date/models/friend_model.dart';
import 'package:soul_date/models/profile_model.dart';
import 'package:soul_date/services/date_format.dart';
import '../../../models/spotify_spot_details.dart' as Spotify;

class VinylModel {
  final Profile sender;
  final Spotify.Item item;
  final List<Profile> audience;
  final DateTime dateSent;
  final bool opened;
  final String? caption;
  final String id;

  factory VinylModel.fromJson(Map<String, dynamic> json, String id) {
    return VinylModel(
      id: id,
      sender: Profile.fromJson(json['sender']),
      item: Spotify.Item.fromJson(json['track']),
      audience:
          List<Profile>.from(json['audience'].map((e) => Profile.fromJson(e))),
      dateSent: DateTime.parse(json['date_sent']),
      opened: json['opened'],
      caption: json['caption'],
    );
  }

  VinylModel(
      {required this.sender,
      required this.item,
      this.caption,
      required this.id,
      required this.audience,
      required this.dateSent,
      required this.opened});

  String get date {
    return formatDate(dateSent, pattern: "Hm");
  }
}
