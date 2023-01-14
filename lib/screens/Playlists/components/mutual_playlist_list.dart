import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:soul_date/components/meevy_playlist_card.dart';
import 'package:soul_date/models/meevy_playlists.dart';

import '../../../constants/constants.dart';

class MutualPlaylistList extends StatelessWidget {
  const MutualPlaylistList({
    Key? key,
    required this.profileID,
  }) : super(key: key);
  final int profileID;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('meevyPlaylists')
            .where('__name__',
                isGreaterThanOrEqualTo: "${profileID.toString()}-")
            .where('__name__', isLessThan: "${profileID.toString()}-z")
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data != null) {
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: snapshot.data!.size,
              itemBuilder: (context, index) {
                var doc = snapshot.data!.docs[index];
                MeevyPlaylist meevyPlaylist = MeevyPlaylist.fromSnapshot(doc);
                return Padding(
                  padding: const EdgeInsets.only(right: defaultMargin),
                  child: MeevyPlaylistCard(meevyPlaylist: meevyPlaylist),
                );
              },
            );
          }
          return SpinKitPulse(
            color: Theme.of(context).primaryColor,
          );
        });
  }
}
