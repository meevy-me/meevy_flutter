import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soul_date/components/profile_action_button.dart';
import 'package:soul_date/components/profile_tab_button.dart';
import 'package:soul_date/controllers/SoulController.dart';
import 'package:soul_date/screens/favourite_playlists.dart';
import 'package:soul_date/screens/favourite_song.dart';
import 'package:soul_date/screens/my_images.dart';
import 'package:soul_date/screens/profile2.dart';

import '../constants/constants.dart';

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
                        CupertinoIcons.person,
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
                      CupertinoIcons.heart,
                      size: iconSize,
                      color: defaultGrey,
                    ),
                    activeIcon: const Icon(
                      CupertinoIcons.heart_fill,
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

class _FavouriteDetails extends StatelessWidget {
  const _FavouriteDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SoulController>(builder: (controller) {
      return Column(
        children: [
          ProfileActionButton(
              color: spotifyGreen,
              iconData: CupertinoIcons.music_mic,
              title: "Songs",
              onTap: () {
                Get.to(() => const FavouriteSongScreen());
              },
              subtitle: controller.favouriteTrack == null
                  ? "No favourite song. :("
                  : "${controller.favouriteTrack!.details.name} - ${controller.favouriteTrack!.details.artists.join(', ')}"),
          ProfileActionButton(
              color: spotifyGreen,
              iconData: CupertinoIcons.music_albums,
              title: "Playlists",
              onTap: () {
                Get.to(() => const FavouritePlaylistScreen());
              },
              subtitle: controller.favouritePlaylist.isEmpty
                  ? "No favourite Playlist. :("
                  : controller.favouritePlaylist.first!.details!.name)
        ],
      );
    });
  }
}
