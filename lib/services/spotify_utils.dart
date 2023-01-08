import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soul_date/constants/constants.dart';
import 'package:soul_date/controllers/SoulController.dart';
import 'package:soul_date/models/Spotify/base_model.dart';
import 'package:soul_date/models/models.dart';
import 'package:soul_date/screens/home/models/chat_model.dart';
import 'package:soul_date/screens/home/models/vinyl_model.dart';
import 'package:soul_date/services/network.dart';
import 'package:soul_date/services/spotify.dart';
import '../../../models/spotify_spot_details.dart' as Spot;

void vinylPlay(BuildContext context, VinylModel vinyl,
    {List<VinylModel>? vinyls}) async {
  final SoulController controller = Get.find<SoulController>();
  bool res = await Spotify().startTrack({
    "uris": vinyls != null
        ? vinyls.map((e) => e.item.uri).toList()
        : [vinyl.item.uri],
  });

  if (!res) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Ooops:) An error has occured")));
  } else {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Great:) That was a success")));

    if (!vinyl.opened) {
      FirebaseFirestore.instance
          .collection('sentTracks')
          .doc(vinyl.id)
          .update({'opened': true});

      controller.sendNotification(
          vinyl.sender, "Played your song: ${vinyl.item.itemName}");
    }
  }
}

void _statusCheck(BuildContext context, bool status) {
  if (!status) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Ooops:) An error has occured")));
  } else {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Great:) That was a success")));
  }
}

void vinylQueue(BuildContext context, VinylModel vinyl) async {
  final SoulController controller = Get.find<SoulController>();

  bool res = await Spotify().queueTrack(vinyl.item.uri);
  _statusCheck(context, res);
  if (!vinyl.opened) {
    FirebaseFirestore.instance
        .collection('sentTracks')
        .doc(vinyl.id)
        .update({'opened': true});

    controller.sendNotification(
        vinyl.sender, "Queued your song: ${vinyl.item.itemName}");
  }
}

void trackLike(BuildContext context, SpotifyData item) {
  final SoulController controller = Get.find<SoulController>();

  String userID = controller.profile!.user.id.toString();
  DateTime now = DateTime.now();
  FirebaseFirestore.instance
      .collection('likedPlaylist')
      .doc(userID)
      .set({"updated_at": now.toIso8601String()}, SetOptions(merge: true));
  FirebaseFirestore.instance
      .collection('likedPlaylist')
      .doc(userID)
      .collection('tracks')
      .doc(item.id)
      .set({"track": item.toJson(), "date_added": now.toIso8601String()});

  ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Yayy:) Track added to your playlist")));
}

void vinylLike(BuildContext context, VinylModel vinyl) {
  // DateTime now = DateTime.now();

  trackLike(context, vinyl.item);
}

void trackLikeRemove(BuildContext context, SpotifyData item) {
  final SoulController controller = Get.find<SoulController>();

  String userID = controller.profile!.user.id.toString();
  FirebaseFirestore.instance
      .collection('likedPlaylist')
      .doc(userID)
      .collection('tracks')
      .doc(item.id)
      .delete();
}

void vinylLikeRemove(BuildContext context, VinylModel vinyl) {
  trackLikeRemove(context, vinyl.item);
}

String getPlaylistID(Profile sender, Profile receiver) {
  int senderID = sender.user.id;
  int profileId = receiver.user.id;
  if (sender.user.id < receiver.user.id) {
    return "$senderID - $profileId";
  } else {
    return "$profileId - $senderID";
  }
}

String _getPlaylistID(VinylModel vinylModel) {
  final SoulController controller = Get.find<SoulController>();

  String userID = controller.profile!.user.id.toString();
  return getPlaylistID(vinylModel.sender, controller.profile!);
}

void trackAddToPlaylist(
    {required Profile sender,
    required Profile receiver,
    required SpotifyData item}) {
  String playlistID = getPlaylistID(sender, receiver);
  log(playlistID);
  FirebaseFirestore.instance
      .collection('meevyPlaylists')
      .doc(playlistID)
      .collection('tracks')
      .doc(item.id)
      .set({
    "track": item.toJson(),
    "date_added": DateTime.now().toIso8601String()
  });
}

void _addToPlaylist(String playlistID, VinylModel vinyl) {
  final SoulController controller = Get.find<SoulController>();

  String userID = controller.profile!.user.id.toString();
  trackAddToPlaylist(
      sender: vinyl.sender, receiver: controller.profile!, item: vinyl.item);
}

void vinylPlaylist(BuildContext context, VinylModel vinyl) async {
  final SoulController controller = Get.find<SoulController>();

  String userID = controller.profile!.user.id.toString();
  String playlistID = getPlaylistID(vinyl.sender, controller.profile!);

  var doc = await FirebaseFirestore.instance
      .collection('meevyPlaylists')
      .doc(playlistID)
      .get();

  if (doc.exists) {
    _addToPlaylist(playlistID, vinyl);
  } else {
    Map<String, dynamic> playlistMetadata = {
      "creator": controller.profile!.toJson(),
      "imageUrl": "",
      "name": "${vinyl.sender.name} & ${controller.profile!.name}",
      "created_at": DateTime.now().toIso8601String(),
      "members": [vinyl.sender.user.id, controller.profile!.user.id],
    };
    FirebaseFirestore.instance
        .collection('meevyPlaylists')
        .doc(playlistID)
        .set(playlistMetadata);
    _addToPlaylist(playlistID, vinyl);
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Yayy:) Track added to your playlist")));
  }
}

void vinylOpenSpotify(BuildContext context, VinylModel vinyl) {
  Spotify().openSpotify(vinyl.item.uri, vinyl.item.url);
}

void trackPlaylistRemove(
    {required Profile sender,
    required Profile receiver,
    required SpotifyData item}) {
  String playlistID = getPlaylistID(sender, receiver);

  FirebaseFirestore.instance
      .collection('meevyPlaylists')
      .doc(playlistID)
      .collection('tracks')
      .doc(item.id)
      .delete();
}

void vinylPlaylistRemove(BuildContext context, VinylModel vinyl) {
  final SoulController controller = Get.find<SoulController>();

  String userID = controller.profile!.user.id.toString();
  trackPlaylistRemove(
      sender: vinyl.sender, receiver: controller.profile!, item: vinyl.item);
}

Future<bool> isVinylLiked(VinylModel vinyl) async {
  final SoulController controller = Get.find<SoulController>();

  String userID = controller.profile!.user.id.toString();
  var ref = FirebaseFirestore.instance
      .collection('likedPlaylist')
      .doc(controller.profile!.user.id.toString())
      .collection('tracks')
      .doc(vinyl.item.id);

  var doc = await ref.get();
  return doc.exists;
}

Future<bool> isVinylInPlaylist(VinylModel vinyl) async {
  String playlistID = _getPlaylistID(vinyl);

  var ref = FirebaseFirestore.instance
      .collection('meevyPlaylists')
      .doc(playlistID)
      .collection('tracks')
      .doc(vinyl.item.id);

  var doc = await ref.get();
  return doc.exists;
}

Future<SpotifyData?> dataFromUrl(
  String url,
) async {
  Spotify _spotify = Spotify();
  if (url.contains("https://open.spotify.com/")) {
    var text = url.replaceAll("https://open.spotify.com/", "");
    var keys = text.split("/");
    var field = keys[0];

    var fieldId = keys[1];
    if (fieldId.contains("?")) {
      fieldId = fieldId.split("?")[0];
    }

    SpotifyData? data = await _spotify.getItem(field, fieldId);
    return data;
  }
  return null;
}

void sendSpotifyItem(
    {required SpotifyData item,
    required List<Friends> friends,
    String caption = ""}) async {
  HttpClient client = HttpClient();

  var res = await client.get(profileMeUrl);
  if (res.statusCode <= 210) {
    Profile me = Profile.fromJson(json.decode(res.body));

    Map<String, dynamic> sendToProfile = {
      "track": item.toJson(),
      "audience": friends.map((e) => e.friendsProfile.toJson()).toList(),
      "date_sent": DateTime.now().toString(),
      "opened": false,
      "sender": me.toJson(),
      "caption": caption
    };

    if (item.spotifyDataType == SpotifyDataType.track) {
      var doc_ref = await FirebaseFirestore.instance
          .collection('sentTracks')
          .add(sendToProfile);
      VinylChat vinylChat =
          VinylChat(sender: me, message: caption, dateSent: DateTime.now());

      FirebaseFirestore.instance
          .collection('sentTracks')
          .doc(doc_ref.id)
          .collection('messages')
          .add(vinylChat.toJson());

      for (var element in friends) {
        FirebaseFirestore.instance
            .collection('userSentTracks')
            .doc(element.friendsProfile.user.id.toString())
            .collection('sentTracks')
            .doc(doc_ref.id)
            .set({"date_sent": DateTime.now().toString()});
      }
    } else if (item.spotifyDataType == SpotifyDataType.playlist) {
      var doc_ref = await FirebaseFirestore.instance
          .collection('sentPlaylists')
          .doc(item.id);

      doc_ref.set(sendToProfile);

      // FirebaseFirestore.instance
      //     .collection('sentPlaylists')
      //     .doc(doc_ref.id)
      //     .collection('messages')
      //     .add({
      //   "sender": me.toJson(),
      //   "message": caption,
      //   "date_sent": DateTime.now()
      // });
      for (var element in friends) {
        FirebaseFirestore.instance
            .collection('userSentPlaylists')
            .doc(element.friendsProfile.user.id.toString())
            .collection('sentPlaylists')
            .doc(doc_ref.id)
            .set({"date_sent": DateTime.now().toString()});
      }
    }
  }
}
