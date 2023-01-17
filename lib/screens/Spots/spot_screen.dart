import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import 'package:share_extend/share_extend.dart';
import 'package:soul_date/animations/animations.dart';
import 'package:soul_date/components/image_circle.dart';
import 'package:soul_date/constants/constants.dart';
import 'package:soul_date/controllers/SoulController.dart';
import 'package:soul_date/controllers/SpotController.dart';
import 'package:soul_date/models/spots.dart';
import 'package:soul_date/screens/Spots/share_item.dart';
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

  //Implement Dispose

  // Uint8List? bytes;
  // void exportSpot(BuildContext context, Spot spot) async {
  //   bytes = await imageController.capture();
  //   try {
  //     if (bytes != null) {
  //       var tempDir = await getApplicationDocumentsDirectory();
  //       String filePath = '${tempDir.path}/spot.png';

  //       File file = File(filePath);
  //       if (!file.existsSync()) {
  //         file.create(recursive: true);
  //       }
  //       File image = await file.writeAsBytes(bytes!.toList());
  //       final box = context.findRenderObject() as RenderBox?;
  //       ShareExtend.share(image.path, "image",
  //           subject: spot.details.item.name,
  //           sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
  //     }
  //   } catch (e) {
  //     log(e.toString());
  //   }
  // }

  @override
  void initState() {
    setState(() {
      widget.spots.spots = widget.spots.spots.reversed.toList();
    });
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
                                          "${DateTime.now().difference(spot.dateAdded).inHours} Hrs ago.",
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
                                            icon: const Icon(
                                                CupertinoIcons.share_solid,
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
              color: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: defaultMargin),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
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
                        controller.spotify
                            .playTrack(spot.details.item.uri, context: context);
                      },
                      icon: const Icon(
                        FontAwesomeIcons.spotify,
                        color: Colors.white,
                      ),
                      label: const Text("Sync"))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
