import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soul_date/controllers/SoulController.dart';
import 'package:soul_date/models/models.dart';
import 'package:soul_date/screens/home/models/vinyl_model.dart';
import 'package:soul_date/services/spotify.dart';
import '../../../models/spotify_spot_details.dart' as Spot;

final SoulController controller = Get.find<SoulController>();
void vinylPlay(BuildContext context, VinylModel vinyl,
    {List<VinylModel>? vinyls}) async {
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
          vinyl.sender, "Played your song: ${vinyl.item.name}");
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
  bool res = await Spotify().queueTrack(vinyl.item.uri);
  _statusCheck(context, res);
  if (!vinyl.opened) {
    FirebaseFirestore.instance
        .collection('sentTracks')
        .doc(vinyl.id)
        .update({'opened': true});

    controller.sendNotification(
        vinyl.sender, "Queued your song: ${vinyl.item.name}");
  }
}

String userID = controller.profile!.user.id.toString();

void trackLike(BuildContext context, Spot.Item item) {
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

void trackLikeRemove(BuildContext context, Spot.Item item) {
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
  return getPlaylistID(vinylModel.sender, controller.profile!);
}

void trackAddToPlaylist(
    {required Profile sender,
    required Profile receiver,
    required Spot.Item item}) {
  String playlistID = getPlaylistID(sender, receiver);
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
  trackAddToPlaylist(
      sender: vinyl.sender, receiver: controller.profile!, item: vinyl.item);
}

void vinylPlaylist(BuildContext context, VinylModel vinyl) async {
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
  Spotify().openSpotify(vinyl.item.uri, vinyl.item.externalUrls.spotify);
}

void trackPlaylistRemove(
    {required Profile sender,
    required Profile receiver,
    required Spot.Item item}) {
  String playlistID = getPlaylistID(sender, receiver);

  FirebaseFirestore.instance
      .collection('meevyPlaylists')
      .doc(playlistID)
      .collection('tracks')
      .doc(item.id)
      .delete();
}

void vinylPlaylistRemove(BuildContext context, VinylModel vinyl) {
  trackPlaylistRemove(
      sender: vinyl.sender, receiver: controller.profile!, item: vinyl.item);
}

Future<bool> isVinylLiked(VinylModel vinyl) async {
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
