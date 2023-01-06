import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:clay_containers/clay_containers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:soul_date/components/cached_image_error.dart';
import 'package:soul_date/components/home_appbar_action.dart';
import 'package:soul_date/components/icon_container.dart';
import 'package:soul_date/components/image_circle.dart';
import 'package:soul_date/components/meevy_playlist_card.dart';
import 'package:soul_date/constants/constants.dart';
import 'package:soul_date/models/meevy_playlists.dart';
import 'package:soul_date/models/models.dart';

import '../components/meevy_favourite_card.dart';

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
                        height: 155,
                        child: FutureBuilder<QuerySnapshot>(
                            future: FirebaseFirestore.instance
                                .collection('meevyPlaylists')
                                .where('__name__', isGreaterThanOrEqualTo: '1')
                                .where('__name__', isLessThan: '1' '\uf8ff')
                                .get(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                      ConnectionState.done &&
                                  snapshot.data != null) {
                                return ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: snapshot.data!.size,
                                  itemBuilder: (context, index) {
                                    var doc = snapshot.data!.docs[index];
                                    MeevyPlaylist meevyPlaylist =
                                        MeevyPlaylist.fromSnapshot(doc);
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          right: defaultMargin),
                                      child: MeevyPlaylistCard(
                                          meevyPlaylist: meevyPlaylist),
                                    );
                                  },
                                );
                              }
                              return SpinKitPulse(
                                color: Theme.of(context).primaryColor,
                              );
                            })),
                  )
                ],
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: 5,
              primary: false,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: defaultMargin),
                  child: Container(
                    padding: scaffoldPadding,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              offset: Offset(1, 1),
                              blurRadius: 1,
                              color: Colors.grey.withOpacity(0.3)),
                        ],
                        borderRadius: BorderRadius.circular(20)),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: SoulCachedNetworkImage(
                            imageUrl: defaultArtistUrl,
                            width: 50,
                            height: 50,
                          ),
                        ),
                        const SizedBox(
                          width: defaultMargin,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Hidden Gems",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(fontSize: 15),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: defaultPadding),
                              child: Row(
                                children: [
                                  SoulCircleAvatar(
                                    imageUrl: defaultGirlUrl,
                                    radius: 10,
                                  ),
                                  const SizedBox(
                                    width: defaultPadding,
                                  ),
                                  Text(
                                    "Colinreece Kipkorir",
                                    style: Theme.of(context).textTheme.caption,
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                        const Spacer(),
                        IconContainer(
                          size: 35,
                          icon: Icon(
                            CupertinoIcons.play_fill,
                            color: Colors.white,
                            size: 25,
                          ),
                          color: Theme.of(context).primaryColor,
                        )
                      ],
                    ),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
