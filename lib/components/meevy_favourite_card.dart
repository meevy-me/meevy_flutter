import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soul_date/animations/animations.dart';
import 'package:soul_date/components/image_circle.dart';
import 'package:soul_date/components/pulse.dart';
import 'package:soul_date/controllers/SoulController.dart';
import 'package:soul_date/models/Spotify/base_model.dart';
import 'package:soul_date/screens/Playlists/models/meevy_playlist_detail.dart';
import 'package:soul_date/screens/Playlists/playlists_detail.dart';
import 'package:soul_date/services/navigation.dart';
import 'package:soul_date/services/spotify_utils.dart';

import '../constants/constants.dart';
import '../models/spotify_spot_details.dart';
import 'icon_container.dart';

class MeevyFavouriteCard extends StatefulWidget {
  const MeevyFavouriteCard({
    Key? key,
    required this.profileID,
  }) : super(key: key);

  final int? profileID;
  @override
  State<MeevyFavouriteCard> createState() => _MeevyFavouriteCardState();
}

class _MeevyFavouriteCardState extends State<MeevyFavouriteCard> {
  Future<List<SpotifyData>> getTracks() async {
    var collection = await FirebaseFirestore.instance
        .collection('likedPlaylist')
        .doc(widget.profileID.toString())
        .collection('tracks')
        .orderBy('date_added', descending: true)
        .get();
    return collection.docs.map((e) {
      // print(e.data());
      var item = Item.fromJson(e.data()['track']);
      return item;
    }).toList();
  }

  void onPlay() {
    favouritesPlayAll(context);
  }

  final SoulController soulController = Get.find<SoulController>();
  @override
  Widget build(BuildContext context) {
    return widget.profileID != null
        ? FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('likedPlaylist')
                .doc(widget.profileID.toString())
                .get(),
            builder: (context, snapshot) {
              return GestureDetector(
                onTap: () => Navigation.push(context,
                    customPageTransition: PageTransition(
                        child: PlaylistDetailPage(
                          onPlay: onPlay,
                          tracksFn: getTracks,
                          meevyBasePlaylist: MeevyBasePlaylist(
                              name: "Meevy Favourites",
                              description:
                                  "Songs you have liked while using meevy",
                              contributors: [soulController.profile!]),
                        ),
                        type: PageTransitionType.fromBottom)),
                child: Container(
                  padding: scaffoldPadding,
                  height: 100,
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor),
                            child: const Center(
                                child: Icon(CupertinoIcons.heart_fill,
                                    color: Colors.white, size: 40)),
                          )),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: defaultMargin),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Meevy Favourites",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6!
                                  .copyWith(color: Colors.white),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: defaultPadding),
                              child: FutureBuilder<QuerySnapshot>(
                                  future: FirebaseFirestore.instance
                                      .collection('likedPlaylist')
                                      .doc(widget.profileID.toString())
                                      .collection('tracks')
                                      // .orderBy('date_added')
                                      .get(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.done) {
                                      List<Item> items = snapshot.data!.docs
                                          .map((e) =>
                                              Item.fromJson(e.get('track')))
                                          .toList();
                                      // print(data);
                                      // List<Item> items = data.map((key, value) => Item.fromJson(json))
                                      return Row(
                                        children: [
                                          RowSuper(
                                            innerDistance: -10,
                                            children: [
                                              for (Item item in items.take(4))
                                                SoulCircleAvatar(
                                                  imageUrl: item
                                                      .album.images.first.url,
                                                  radius: 12,
                                                )
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: defaultPadding),
                                            child: Text(
                                              "Contains ${items.length} tracks",
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .caption!
                                                  .copyWith(color: Colors.grey),
                                            ),
                                          )
                                        ],
                                      );
                                    }

                                    return const SpinKitPulse(
                                      color: Colors.grey,
                                      size: 15,
                                    );
                                  }),
                            )
                          ],
                        ),
                      ),
                      const Spacer(),
                      IconContainer(
                        onPress: () {
                          favouritesPlayAll(context);
                        },
                        icon: const Icon(
                          CupertinoIcons.play_fill,
                          color: Colors.white,
                          size: 30,
                        ),
                        color: Theme.of(context).primaryColor,
                        size: 40,
                      )
                    ],
                  ),
                ),
              );
            })
        : LoadingPulse();
  }
}
