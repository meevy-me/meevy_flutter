import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:soul_date/animations/animations.dart';
import 'package:soul_date/controllers/SoulController.dart';
import 'package:soul_date/models/Spotify/base_model.dart';
import 'package:soul_date/models/images.dart';
import 'package:soul_date/screens/Playlists/models/firebase_playlist.dart';
import 'package:soul_date/screens/Playlists/models/meevy_playlist_detail.dart';
import 'package:soul_date/screens/Playlists/playlists_detail.dart';
import 'package:soul_date/services/formatting.dart';
import 'package:soul_date/services/navigation.dart';
import 'package:soul_date/services/network_utils.dart';
import 'package:soul_date/services/spotify_utils.dart';

import '../../../components/cached_image_error.dart';
import '../../../components/icon_container.dart';
import '../../../components/image_circle.dart';
import '../../../constants/constants.dart';

class SharedPlaylistCard extends StatefulWidget {
  const SharedPlaylistCard({
    Key? key,
    required this.documentId,
  }) : super(key: key);

  final String documentId;

  @override
  State<SharedPlaylistCard> createState() => _SharedPlaylistCardState();
}

class _SharedPlaylistCardState extends State<SharedPlaylistCard> {
  final SoulController soulController = Get.find<SoulController>();
  Future<List<SpotifyData>> getTracks() async {
    var data = await soulController.spotify.playlistTracks(widget.documentId);
    return data;
  }

  // final SoulController soulController = Get.find<SoulController>();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('sentPlaylists')
            .doc(widget.documentId)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data != null) {
            FirebasePlaylist firebasePlaylist =
                FirebasePlaylist.fromSnapshot(snapshot.data!);

            return InkWell(
              onTap: () => Navigation.push(context,
                  customPageTransition: PageTransition(
                      child: PlaylistDetailPage(
                        onPlay: () => sharedPlaylistPlayAll(
                            context, firebasePlaylist.item),
                        tracksFn: getTracks,
                        meevyBasePlaylist: MeevyBasePlaylist(
                            imageUrl: firebasePlaylist.item.image,
                            name: utf8Format(firebasePlaylist.item.itemName),
                            description:
                                utf8Format(firebasePlaylist.item.caption),
                            contributors: [firebasePlaylist.sender]),
                      ),
                      type: PageTransitionType.fromBottom)),
              child: Container(
                padding: scaffoldPadding,
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          offset: const Offset(1, 1),
                          blurRadius: 1,
                          color: Colors.grey.withOpacity(0.3)),
                    ],
                    borderRadius: BorderRadius.circular(20)),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: SoulCachedNetworkImage(
                        imageUrl: firebasePlaylist.item.image,
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
                          firebasePlaylist.item.itemName,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(fontSize: 15),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: defaultPadding),
                          child: Row(
                            children: [
                              FutureBuilder<ProfileImages>(
                                  future: getProfileImages(
                                      firebasePlaylist.sender.id),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                            ConnectionState.done &&
                                        snapshot.data != null) {
                                      return SoulCircleAvatar(
                                        imageUrl: snapshot.data!.image,
                                        radius: 10,
                                      );
                                    }
                                    return const SpinKitPulse(
                                      color: Colors.grey,
                                    );
                                  }),
                              const SizedBox(
                                width: defaultPadding,
                              ),
                              Text(
                                firebasePlaylist.sender.name,
                                style: Theme.of(context).textTheme.caption,
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    const Spacer(),
                    IconContainer(
                      onPress: () =>
                          sharedPlaylistPlayAll(context, firebasePlaylist.item),
                      size: 35,
                      icon: const Icon(
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
          }
          return const SpinKitPulse(
            color: Colors.grey,
          );
        });
  }
}
