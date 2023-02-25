import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:soul_date/main.dart';
import 'package:soul_date/models/Spotify/base_model.dart';
import 'package:soul_date/models/models.dart';
import 'package:soul_date/services/notifications.dart';
import 'package:soul_date/services/spotify.dart';
import 'package:soul_date/services/spotify_helper.dart';

void sendMessage(
    {required Friends friends,
    required String msg,
    type = 'text',
    SpotifyData? spotifyData,
    Message? replyTo}) async {
  if (isSpotifyLink(msg) && spotifyData == null) {
    var parsedUrl = SpotifyHelper.parseUrl(msg);
    spotifyData = await Spotify().getItem(parsedUrl.type, parsedUrl.id);
  }

  Map<String, dynamic> toSend = {
    "sender": friends.currentProfile.user.id.toString(),
    "message": msg,
    "date_sent": FieldValue.serverTimestamp(),
    "reply_to": replyTo?.toJson(),
    "type": spotifyData != null ? 'spotify' : 'text',
    "spotifyData": spotifyData?.toJson()
  };
  await FirebaseFirestore.instance
      .collection('chatMessages')
      .doc(friends.id.toString())
      .collection('messages')
      .doc()
      .set(toSend);
  FirebaseFirestore.instance
      .collection('chats')
      .doc(friends.id.toString())
      .update(
          {"last_message": toSend, "timestamp": FieldValue.serverTimestamp()});

  sendNotification(friends.friendsProfile, msg);
  // controllesendNotification(receiver, msg);
}
