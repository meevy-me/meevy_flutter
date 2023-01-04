import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soul_date/controllers/SoulController.dart';
import 'package:soul_date/screens/home/models/vinyl_model.dart';
import 'package:soul_date/services/spotify.dart';

void vinylPlay(BuildContext context, VinylModel vinyl) async {
  final SoulController controller = Get.find<SoulController>();
  bool res = await Spotify().startTrack({
    "uris": [vinyl.item.uri],
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
