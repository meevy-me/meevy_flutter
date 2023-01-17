import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:soul_date/components/meevy_playlist_card.dart';
import 'package:soul_date/components/pulse.dart';
import 'package:soul_date/models/meevy_playlists.dart';

import '../../../constants/constants.dart';

class MutualPlaylistList extends StatelessWidget {
  const MutualPlaylistList({
    Key? key,
    required this.profileID,
  }) : super(key: key);
  final int? profileID;
  @override
  Widget build(BuildContext context) {
    return profileID != null
        ? FutureBuilder<QuerySnapshot>(
            future: FirebaseFirestore.instance
                .collection('meevyPlaylists')
                .where("members", arrayContains: profileID)
                .get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.data != null) {
                return snapshot.data!.size != 0
                    ? ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data!.size,
                        itemBuilder: (context, index) {
                          var doc = snapshot.data!.docs[index];
                          MeevyPlaylist meevyPlaylist =
                              MeevyPlaylist.fromSnapshot(doc);
                          return Padding(
                            padding:
                                const EdgeInsets.only(right: defaultMargin),
                            child:
                                MeevyPlaylistCard(meevyPlaylist: meevyPlaylist),
                          );
                        },
                      )
                    : Center(
                        child: Text(
                        "Its Empty:(. Create Mutual playlist by adding a song sent to you by a friend",
                        style: Theme.of(context).textTheme.caption,
                      ));
              }
              return SpinKitPulse(
                color: Theme.of(context).primaryColor,
              );
            })
        : const LoadingPulse();
  }
}
