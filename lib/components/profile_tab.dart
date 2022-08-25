import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:soul_date/components/profile_action_button.dart';
import 'package:soul_date/components/profile_tab_button.dart';
import 'package:soul_date/controllers/SoulController.dart';
import 'package:soul_date/screens/favourite_playlists.dart';
import 'package:soul_date/screens/favourite_song.dart';
import 'package:soul_date/screens/my_images.dart';
import 'package:soul_date/screens/profile_edit.dart';

import '../constants/constants.dart';
import 'buttons.dart';

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
              Get.to(() => const ProfileEdit());
            },
          ),
          ProfileActionButton(
            iconData: CupertinoIcons.photo,
            title: "Images",
            subtitle: "View and manage your public images",
            onTap: () {
              Get.to(() => const MyImages());
            },
          ),
          ProfileActionButton(
            iconData: Icons.logout,
            title: "Logout",
            subtitle: "Logout from app",
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) => Dialog(
                        child: SizedBox(
                          height: 100,
                          child: Padding(
                            padding: scaffoldPadding,
                            child: Column(
                              children: [
                                Text(
                                  "Do you want to logout?",
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                                const SizedBox(
                                  height: defaultMargin,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      onTap: () => Get.back(),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.close,
                                            color: Colors.grey,
                                          ),
                                          const SizedBox(
                                            width: defaultPadding,
                                          ),
                                          Text(
                                            "Cancel",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText2!
                                                .copyWith(color: Colors.grey),
                                          )
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      width: defaultMargin * 2,
                                    ),
                                    PrimaryButton(
                                        onPress: () {
                                          controller.logout();
                                        },
                                        text: "Logout")
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ));
            },
          ),
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
              iconData: FontAwesomeIcons.recordVinyl,
              title: "Song",
              onTap: () {
                Get.to(() => const FavouriteSongScreen());
              },
              subtitle: controller.favouriteTrack == null
                  ? "No favourite song. :("
                  : "${controller.favouriteTrack!.details.name} - ${controller.favouriteTrack!.details.artists.join(', ')}"),
          ProfileActionButton(
              color: spotifyGreen,
              iconData: CupertinoIcons.music_albums_fill,
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
