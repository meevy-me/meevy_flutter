import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import 'package:soul_date/animations/animations.dart';
import 'package:soul_date/components/Modals/spot_buddy_modal.dart';
import 'package:soul_date/components/image_circle.dart';
import 'package:soul_date/components/pulse.dart';
import 'package:soul_date/constants/constants.dart';
import 'package:soul_date/controllers/SoulController.dart';
import 'package:soul_date/controllers/SpotController.dart';
import 'package:soul_date/models/models.dart';
import 'package:soul_date/models/spot_buddy_model.dart';
import 'package:soul_date/models/spots.dart';
import 'package:soul_date/screens/Spots/share_item.dart';
import 'package:soul_date/services/modal.dart';
import 'package:soul_date/services/navigation.dart';
import 'package:widgets_to_image/widgets_to_image.dart';

import 'components/spot_background.dart';
import 'components/spot_song_image.dart';

class SpotScreen extends StatefulWidget {
  const SpotScreen({Key? key, required this.spots}) : super(key: key);
  final SpotsView spots;

  @override
  State<SpotScreen> createState() => _SpotScreenState();
}

class _SpotScreenState extends State<SpotScreen> {
  final SoulController controller = Get.find<SoulController>();
  final SpotController spotController = Get.find<SpotController>();
  final WidgetsToImageController imageController = WidgetsToImageController();
  // late Future<List<SpotBuddy>> _future;

  @override
  void initState() {
    // setState(() {
    //   widget.spots.spots = widget.spots.spots.reversed.toList();
    //   // _future = controller.getSpotBuddies(widget.spots.spots[currentIndex].id);
    // });
    super.initState();
  }

  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    Spot spot = widget.spots.spots[currentIndex];

    Size size = MediaQuery.of(context).size;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            GestureDetector(
              onTapDown: (details) {
                var dx = details.globalPosition.dx;
                if (dx > size.width / 2) {
                  if (currentIndex < widget.spots.spots.length - 1) {
                    setState(() {
                      currentIndex += 1;
                    });
                  } else {
                    Get.back();
                  }
                } else {
                  if (currentIndex != 0) {
                    setState(() {
                      currentIndex -= 1;
                    });
                  } else {
                    Get.back();
                  }
                }
              },
              child: Stack(children: [
                SpotScreenBackground(
                  item: spot.details.item,
                ),
                SafeArea(
                  child: SizedBox(
                    height: size.height * 0.9,
                    child: Padding(
                      padding: scaffoldPadding,
                      child: Column(
                        children: [
                          Visibility(
                            child: Row(
                              children: List<Widget>.generate(
                                  widget.spots.spots.length,
                                  (index) => Flexible(
                                        child: Container(
                                          height: 5,
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 1),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              color: index == currentIndex
                                                  ? Colors.white70
                                                  : Colors.grey),
                                        ),
                                      )),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: defaultMargin),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(1),
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              color: Theme.of(context)
                                                  .primaryColor)),
                                      child: SoulCircleAvatar(
                                        imageUrl:
                                            spot.profile.profilePicture.image,
                                        radius: 18,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: defaultMargin,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          spot.profile.name,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1!
                                              .copyWith(color: Colors.white),
                                        ),
                                        Text(
                                          spot.datePosted,
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption!
                                              .copyWith(color: Colors.white),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          Get.back();
                                        },
                                        icon: const Icon(
                                          Icons.close,
                                          color: Colors.white,
                                        )),
                                    const SizedBox(
                                      width: defaultPadding,
                                    ),
                                    // IconButton(
                                    //     onPressed: () {
                                    //       exportSpot(context, spot);
                                    //     },
                                    //     icon: const Icon(
                                    //       Icons.share,
                                    //       color: Colors.white,
                                    //     )),

                                    widget.spots.profile.id ==
                                            controller.profile!.id
                                        ? IconButton(
                                            onPressed: () {
                                              Navigation.push(context,
                                                  customPageTransition:
                                                      PageTransition(
                                                          child: ShareScreen(
                                                            caption: widget
                                                                .spots
                                                                .spots[
                                                                    currentIndex]
                                                                .caption,
                                                            profile: widget
                                                                .spots.profile,
                                                            item: widget
                                                                .spots
                                                                .spots[
                                                                    currentIndex]
                                                                .details
                                                                .item,
                                                          ),
                                                          type:
                                                              PageTransitionType
                                                                  .fromBottom));
                                            },
                                            icon: const Icon(Icons.share,
                                                color: Colors.white))
                                        : const SizedBox.shrink(),
                                    widget.spots.profile.id ==
                                            controller.profile!.id
                                        ? IconButton(
                                            onPressed: () {
                                              spotController
                                                  .deleteSpot(spot.id);
                                            },
                                            icon: const Icon(
                                              CupertinoIcons.delete_solid,
                                              color: Colors.white,
                                            ))
                                        : const SizedBox.shrink(),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Center(
                  child: SongWithImage(
                    item: spot.details.item,
                    caption: spot.caption,
                  ),
                )
              ]),
            ),
            Container(
              // height: size.height * 0.1,
              color: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: defaultMargin),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      widget.spots.profile.id == controller.profile!.id
                          ? _SpotBuddy(
                              spot: spot,
                              // future: controller.getSpotBuddies(spot.id),
                            )
                          : Text(
                              "Sync To Spot",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(color: Colors.white),
                            ),
                      ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20))),
                          onPressed: () {
                            controller.spotify.playTrack(spot.details.item.uri,
                                context: context);
                          },
                          icon: const Icon(
                            FontAwesomeIcons.spotify,
                            color: Colors.white,
                          ),
                          label: const Text("Sync"))
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _SpotBuddy extends StatefulWidget {
  const _SpotBuddy({
    Key? key,
    required this.spot,
  }) : super(key: key);
  final Spot spot;

  @override
  State<_SpotBuddy> createState() => _SpotBuddyState();
}

class _SpotBuddyState extends State<_SpotBuddy> {
  final SoulController soulController = Get.find<SoulController>();
  // late Future<List<SpotBuddy>> _future;

  @override
  void initState() {
    // _future = ;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<SpotBuddy>>(
        future: soulController.getSpotBuddies(widget.spot.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data != null) {
            return snapshot.data!.isNotEmpty
                ? GestureDetector(
                    onTap: () => showModal(
                        context,
                        SpotBuddyModal(
                          buddies: snapshot.data!,
                          spot: widget.spot,
                        )),
                    child: Row(
                      children: [
                        RowSuper(
                          innerDistance: -10,
                          children: snapshot.data!
                              .map((e) => SoulCircleAvatar(
                                    imageUrl: e.profile.profilePicture.image,
                                    radius: 15,
                                  ))
                              .toList(),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: defaultPadding),
                          child: Text(
                              "${snapshot.data!.length} Spot ${snapshot.data!.length == 1 ? 'Buddy' : 'Buddies'}",
                              style: Theme.of(context).textTheme.caption),
                        )
                      ],
                    ),
                  )
                : Text(
                    "0 Spot Buddies :(",
                    style: Theme.of(context).textTheme.caption,
                  );
          }
          return const LoadingPulse();
        });
  }
}
