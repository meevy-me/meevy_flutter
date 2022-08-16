import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:soul_date/components/buttons.dart';
import 'package:soul_date/controllers/SoulController.dart';
import 'package:soul_date/screens/my_images.dart';
import 'package:soul_date/screens/profile_edit.dart';
import 'package:soul_date/screens/spotify_details.dart';

import '../constants/constants.dart';

class ProfileHome extends StatefulWidget {
  const ProfileHome({Key? key}) : super(key: key);

  @override
  State<ProfileHome> createState() => _ProfileHomeState();
}

class _ProfileHomeState extends State<ProfileHome> {
  final SoulController controller = Get.find<SoulController>();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SoulController>(
        id: 'profile',
        builder: (controller) {
          return Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                title: Text(
                  "My Profile",
                  style: Theme.of(context)
                      .textTheme
                      .headline6!
                      .copyWith(fontWeight: FontWeight.w600),
                ),
                centerTitle: true,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                elevation: 0,
              ),
              body: controller.profile != null
                  ? ListView(
                      padding: scrollPadding,
                      children: [
                        Column(
                          children: [
                            SizedBox(
                              height: 130,
                              width: 120,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: CachedNetworkImage(
                                  imageUrl: controller
                                          .profile!.images.isNotEmpty
                                      ? controller.profile!.images.last.image
                                      : defaultAvatarUrl,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: defaultMargin),
                              child: Column(
                                // crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    controller.profile!.name,
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),
                                  Text(
                                      controller.profile!.age.toString() +
                                          ' Yrs',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .copyWith(fontSize: 11))
                                ],
                              ),
                            )
                          ],
                        ),
                        ProfileButtons(
                          label: "My Profile",
                          icon: FontAwesomeIcons.penToSquare,
                          buttonLabel: "Edit",
                          onPress: () {
                            Get.to(() => const ProfileEdit());
                          },
                        ),
                        ProfileButtons(
                          label: "My Images",
                          onPress: () {
                            Get.to(() => const MyImages());
                          },
                          icon: FontAwesomeIcons.images,
                          buttonLabel:
                              controller.profile!.validImages.length.toString(),
                        ),
                        ProfileButtons(
                          label: "My Spotify",
                          color: spotifyGreen,
                          onPress: () {
                            Get.to(() => SpotifyDetailsPage(
                                spotifyUser: controller.spotify.currentUser!));
                          },
                          icon: FontAwesomeIcons.spotify,
                          buttonLabel:
                              controller.spotify.currentUser!.displayName,
                        ),
                        ProfileButtons(
                          label: "My Account",
                          color: Colors.red,
                          onPress: () {
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
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1,
                                              ),
                                              const SizedBox(
                                                height: defaultMargin,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
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
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .bodyText2!
                                                              .copyWith(
                                                                  color: Colors
                                                                      .grey),
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
                          icon: Icons.logout,
                          buttonLabel: "Logout",
                        ),
                      ],
                    )
                  : SpinKitRing(
                      color: Theme.of(context).primaryColor,
                      lineWidth: 2,
                      size: 20,
                    ));
        });
  }
}

class ProfileButtons extends StatelessWidget {
  const ProfileButtons({
    Key? key,
    required this.label,
    required this.buttonLabel,
    this.color,
    required this.icon,
    required this.onPress,
  }) : super(key: key);

  final String label;
  final String buttonLabel;
  final IconData icon;
  final Color? color;
  final Function onPress;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: defaultMargin),
      child: InkWell(
        onTap: () {
          onPress();
        },
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 0.2,
          child: Padding(
            padding: const EdgeInsets.symmetric(
                vertical: defaultMargin * 1.5, horizontal: defaultMargin),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(fontSize: 14),
                ),
                ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: 100),
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    elevation: 0.25,
                    child: Padding(
                      padding: const EdgeInsets.all(defaultMargin),
                      child: Row(
                        children: [
                          Icon(icon,
                              color: color ?? Theme.of(context).primaryColor),
                          const SizedBox(
                            width: defaultPadding,
                          ),
                          const SizedBox(
                            width: defaultMargin,
                          ),
                          Text(buttonLabel)
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
