import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soul_date/animations/page_transition.dart';
import 'package:soul_date/components/image_circle.dart';
import 'package:soul_date/components/profile_action_button.dart';
import 'package:soul_date/components/profile_tab_button.dart';
import 'package:soul_date/components/pulse.dart';
import 'package:soul_date/controllers/SoulController.dart';
import 'package:soul_date/models/favourite_model.dart';
import 'package:soul_date/screens/Playlists/models/meevy_playlist_detail.dart';
import 'package:soul_date/screens/Playlists/playlists_detail.dart';
import 'package:soul_date/screens/favourite_playlists.dart';
import 'package:soul_date/screens/favourite_song.dart';
import 'package:soul_date/screens/my_images.dart';
import 'package:soul_date/screens/profile_update.dart';
import 'package:soul_date/services/formatting.dart';
import 'package:soul_date/services/navigation.dart';

import '../constants/constants.dart';
import '../models/Spotify/base_model.dart';
import '../models/models.dart';
import '../services/modal.dart';
import '../services/spotify_utils.dart';
import 'Modals/invite_modal.dart';

class ProfileTabView extends StatefulWidget {
  const ProfileTabView({
    Key? key,
  }) : super(key: key);

  @override
  State<ProfileTabView> createState() => _ProfileTabViewState();
}

class _ProfileTabViewState extends State<ProfileTabView> {
  final SoulController controller = Get.find<SoulController>();
  int activeTab = 0;
  List<Widget> children = [const _ProfileDetails(), const _FavouriteDetails()];
  @override
  void initState() {
    controller.getFavouriteSong();
    controller.getFavouritePlaylist();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const double iconSize = 25;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: defaultMargin),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                  onTap: () {
                    setState(() {
                      activeTab = 0;
                    });
                  },
                  child: ProfileTabButton(
                      color: Theme.of(context).primaryColor,
                      icon: const Icon(
                        CupertinoIcons.person_fill,
                        color: defaultGrey,
                        size: iconSize,
                      ),
                      activeIcon: Icon(
                        CupertinoIcons.person_fill,
                        color: Theme.of(context).primaryColor,
                        size: iconSize,
                      ),
                      active: activeTab == 0,
                      text: "Profile")),
              const SizedBox(
                width: defaultMargin * 2,
              ),
              GestureDetector(
                  onTap: () {
                    setState(() {
                      activeTab = 1;
                    });
                  },
                  child: ProfileTabButton(
                    color: spotifyGreen,
                    icon: const Icon(
                      CupertinoIcons.sparkles,
                      size: iconSize,
                      color: defaultGrey,
                    ),
                    activeIcon: const Icon(
                      CupertinoIcons.sparkles,
                      size: iconSize,
                      color: spotifyGreen,
                    ),
                    active: activeTab == 1,
                    text: "Favourites",
                  ))
            ],
          ),
          const SizedBox(
            height: defaultMargin * 2,
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            child: children[activeTab],
          )
        ],
      ),
    );
  }
}

class _ProfileDetails extends StatelessWidget {
  const _ProfileDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SoulController>(builder: (controller) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _LikedActionButton(),

          ProfileActionButton(
            iconData: CupertinoIcons.person,
            title: "Profile",
            subtitle: "Manage your profile",
            onTap: () {
              Get.to(() => const ProfileUpdate());
            },
          ),
          ProfileActionButton(
            iconData: CupertinoIcons.photo_on_rectangle,
            title: "Images",
            subtitle: "View and manage your public images",
            onTap: () {
              Get.to(() => const MyImages());
            },
          ),
          ProfileActionButton(
            iconData: CupertinoIcons.share,
            title: "Invite",
            subtitle: "Invite Your friends to Meevy",
            onTap: () {
              showModal(context, const InviteModal());
            },
          ),
          // ProfileActionButton(
          //   iconData: CupertinoIcons.staroflife,
          //   title: "Top Items",
          //   subtitle: "Top songs & artists",
          //   onTap: () {},
          // ),
        ],
      );
    });
  }
}

class _LikedActionButton extends StatefulWidget {
  const _LikedActionButton({
    Key? key,
  }) : super(key: key);

  @override
  State<_LikedActionButton> createState() => _LikedActionButtonState();
}

class _LikedActionButtonState extends State<_LikedActionButton> {
  final SoulController controller = Get.find<SoulController>();

  Future<List<SpotifyData>> getTracks() async {
    var collection = await FirebaseFirestore.instance
        .collection('likedPlaylist')
        .doc(controller.profile!.user.id.toString())
        .collection('tracks')
        .orderBy('date_added', descending: true)
        .get();
    return collection.docs.map((e) {
      // print(e.data());
      var item = Item.fromJson(e.data()['track']);
      return item;
    }).toList();
  }

  late Future<List<SpotifyData>> _future;

  @override
  void initState() {
    _future = getTracks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<SpotifyData>>(
        future: _future,
        builder: (context, snapshot) {
          return ProfileActionButton(
            iconData: CupertinoIcons.heart,
            title: "Liked Songs",
            child1: snapshot.data != null
                ? RowSuper(
                    innerDistance: -10,
                    children: snapshot.data!
                        .take(3)
                        .map((e) => SoulCircleAvatar(
                              imageUrl: e.image,
                              radius: 12,
                            ))
                        .toList())
                : null,
            subtitle: snapshot.data != null && snapshot.data!.isNotEmpty
                ? "Contains ${snapshot.data!.length} tracks"
                : "Songs you have liked while using meevy",
            onTap: () {
              if (snapshot.data != null && snapshot.data!.isNotEmpty) {
                Navigation.push(context,
                    customPageTransition: PageTransition(
                        child: PlaylistDetailPage(
                          onPlay: () {
                            favouritesPlayAll(context);
                          },
                          tracksFn: getTracks,
                          meevyBasePlaylist: MeevyBasePlaylist(
                              name: "Meevy Favourites",
                              description:
                                  "Songs you have liked while using meevy",
                              contributors: [controller.profile!]),
                        ),
                        type: PageTransitionType.fromBottom));
              }
            },
          );
        });
  }
}

class _FavouriteDetails extends StatefulWidget {
  const _FavouriteDetails({Key? key}) : super(key: key);

  @override
  State<_FavouriteDetails> createState() => _FavouriteDetailsState();
}

class _FavouriteDetailsState extends State<_FavouriteDetails> {
  final SoulController soulController = Get.find<SoulController>();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FutureBuilder<FavouriteTrack?>(
            future: soulController.getFavouriteSong(),
            builder: (context, snapshot) {
              return snapshot.connectionState == ConnectionState.done
                  ? ProfileActionButton(
                      color: spotifyGreen,
                      iconData: CupertinoIcons.music_mic,
                      title: "Songs",
                      onTap: () {
                        Get.to(() => const FavouriteSongScreen());
                      },
                      child1: snapshot.data != null
                          ? SoulCircleAvatar(
                              imageUrl:
                                  snapshot.data!.details.album.images.first.url,
                              radius: 12,
                            )
                          : null,
                      subtitle: snapshot.data == null
                          ? "No favourite song. :("
                          : snapshot.data!.details.name)
                  : const LoadingPulse(
                      color: spotifyGreen,
                    );
            }),
        FutureBuilder<List<FavouritePlaylist>>(
            future: soulController.getFavouritePlaylist(),
            builder: (context, snapshot) {
              return snapshot.connectionState == ConnectionState.done &&
                      snapshot.data != null
                  ? ProfileActionButton(
                      color: spotifyGreen,
                      iconData: CupertinoIcons.music_albums,
                      title: "Playlists",
                      onTap: () {
                        Get.to(() => const FavouritePlaylistScreen());
                      },
                      child1: snapshot.data != null
                          ? RowSuper(
                              innerDistance: -10,
                              children: snapshot.data!
                                  .take(4)
                                  .map((e) => SoulCircleAvatar(
                                        imageUrl: e.details!.imageUrl,
                                        radius: 10,
                                      ))
                                  .toList())
                          : null,
                      subtitle: snapshot.data!.isEmpty
                          ? "No favourite Playlist. :("
                          : joinList(snapshot.data!, count: 1))
                  : const LoadingPulse(
                      color: spotifyGreen,
                    );
            })
      ],
    );
  }
}
