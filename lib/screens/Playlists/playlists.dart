import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soul_date/constants/constants.dart';

import '../../components/meevy_favourite_card.dart';
import 'components/mutual_playlist_list.dart';
import 'components/shared_playlist_list.dart';

class PlaylistsPage extends StatefulWidget {
  const PlaylistsPage({Key? key}) : super(key: key);

  @override
  State<PlaylistsPage> createState() => _PlaylistsPageState();
}

class _PlaylistsPageState extends State<PlaylistsPage>
    with AutomaticKeepAliveClientMixin<PlaylistsPage> {
  int? profileID;

  @override
  void initState() {
    getProfileID();
    super.initState();
  }

  void getProfileID() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    int id = preferences.getInt('profileID')!;
    setState(() {
      profileID = id;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Your Playlists",
          style: Theme.of(context).textTheme.headline5,
        ),
        actions: const [
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: defaultMargin),
          //   child: AppbarIconContainer(
          //     iconData: FeatherIcons.search,
          //     onPress: () {},
          //   ),
          // )
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: scaffoldPadding,
          children: [
            FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('likedPlaylist')
                    .doc(profileID.toString())
                    .get(),
                builder: (context, snapshot) {
                  return MeevyFavouriteCard(
                    profileID: profileID,
                  );
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
                        height: 155,
                        child: MutualPlaylistList(
                          profileID: profileID,
                        )),
                  )
                ],
              ),
            ),
            SharedPlaylistList(
              profileID: profileID,
            )
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => false;
}
