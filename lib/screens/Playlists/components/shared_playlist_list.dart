import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:soul_date/components/pulse.dart';
import 'package:soul_date/screens/Playlists/components/shared_playlist_card.dart';

import '../../../components/cached_image_error.dart';
import '../../../components/icon_container.dart';
import '../../../components/image_circle.dart';
import '../../../constants/constants.dart';

class SharedPlaylistList extends StatelessWidget {
  const SharedPlaylistList({
    Key? key,
    required this.profileID,
  }) : super(key: key);
  final int? profileID;

  @override
  Widget build(BuildContext context) {
    return profileID != null
        ? StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('userSentPlaylists')
                .doc(profileID.toString())
                .collection('sentPlaylists')
                .snapshots(),
            builder: (context, snapshot) {
              // print(snapshot.data);
              if (snapshot.data != null) {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.size,
                  primary: false,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: defaultMargin),
                      child: SharedPlaylistCard(
                        documentId: snapshot.data!.docs[index].id,
                      ),
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return Text(
                  "An error has occured",
                  style: Theme.of(context)
                      .textTheme
                      .caption!
                      .copyWith(color: Colors.red),
                );
              }
              return SpinKitPulse(
                color: Theme.of(context).primaryColor,
              );
            })
        : LoadingPulse();
  }
}
