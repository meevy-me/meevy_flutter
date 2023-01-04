import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soul_date/controllers/SoulController.dart';
import 'package:soul_date/screens/home/models/vinyl_model.dart';
import 'package:soul_date/services/spotify.dart';

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

void vinylLike(BuildContext context, VinylModel vinyl) {}

void vinylPlaylist(BuildContext context, VinylModel vinyl) {}

void vinylOpenSpotify(BuildContext context, VinylModel vinyl) {
  Spotify().openSpotify(vinyl.item.uri, vinyl.item.externalUrls.spotify);
}
