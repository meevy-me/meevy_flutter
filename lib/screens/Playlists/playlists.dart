import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:soul_date/components/home_appbar_action.dart';
import 'package:soul_date/constants/constants.dart';

import '../../components/meevy_favourite_card.dart';
import 'components/mutual_playlist_list.dart';
import 'components/shared_playlist_list.dart';

class PlaylistsPage extends StatelessWidget {
  const PlaylistsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Your Playlists",
          style: Theme.of(context).textTheme.headline5,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: defaultMargin),
            child: AppbarIconContainer(
              iconData: FeatherIcons.search,
              onPress: () {},
            ),
          )
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: scaffoldPadding,
          children: [
            FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('likedPlaylist')
                    .doc('1')
                    .get(),
                builder: (context, snapshot) {
                  return MeevyFavouriteCard();
                }),
            const SizedBox(
              height: defaultMargin,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: defaultMargin),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Mutual Playlists",
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: defaultMargin),
                    child: SizedBox(
                        height: 155, child: const MutualPlaylistList()),
                  )
                ],
              ),
            ),
            SharedPlaylistList()
          ],
        ),
      ),
    );
  }
}
