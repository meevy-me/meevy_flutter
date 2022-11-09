import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_extend/share_extend.dart';
import 'package:soul_date/components/image_circle.dart';
import 'package:soul_date/constants/constants.dart';
import 'package:soul_date/controllers/SoulController.dart';
import 'package:soul_date/controllers/SpotController.dart';
import 'package:soul_date/models/spots.dart';
import 'package:widgets_to_image/widgets_to_image.dart';

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
  Uint8List? bytes;
  void exportSpot(BuildContext context, Spot spot) async {
    bytes = await imageController.capture();
    try {
      if (bytes != null) {
        var tempDir = await getApplicationDocumentsDirectory();
        String filePath = '${tempDir.path}/spot.png';

        File file = File(filePath);
        if (!file.existsSync()) {
          file.create(recursive: true);
        }
        File image = await file.writeAsBytes(bytes!.toList());
        final box = context.findRenderObject() as RenderBox?;
        ShareExtend.share(image.path, "image",
            subject: spot.details.item.name,
            sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
      }
    } catch (e) {
      log(e.toString());
    }
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
                SpotScreenBackground(size: size, spot: spot),
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
                                              spotController
                                                  .deleteSpot(spot.id);
                                            },
                                            icon: const Icon(
                                              Icons.delete,
                                              color: Colors.white,
                                            ))
                                        : const SizedBox.shrink()
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
                  child: _SongWithImage(
                    spot: spot,
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

class _SongWithImage extends StatelessWidget {
  const _SongWithImage({
    Key? key,
    required this.spot,
  }) : super(key: key);

  final Spot spot;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Hero(
              tag: spot.details.item.album.images[0].url +
                  spot.profile.id.toString(),
              child: CachedNetworkImage(
                imageUrl: spot.details.item.album.images[0].url,
                height: size.height * 0.4,
                width: size.height * 0.4,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: defaultMargin * 2),
          child: _SongDetails(spot: spot),
        ),
        Center(
          child: Column(
            children: [
              Container(
                height: 5,
                margin: const EdgeInsets.only(bottom: defaultPadding),
                width: 30,
                decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(20)),
              ),
              Text(
                spot.caption,
                style: Theme.of(context)
                    .textTheme
                    .bodyText2!
                    .copyWith(color: Colors.white, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        )
      ],
    );
  }
}

class _SongDetails extends StatelessWidget {
  const _SongDetails({
    Key? key,
    required this.spot,
  }) : super(key: key);

  final Spot spot;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SoulController>(builder: (controller) {
      return InkWell(
        onTap: () => controller.spotify
            .openSpotify(spot.details.item.uri, spot.details.item.href),
        child: Row(
          children: [
            const Icon(
              FontAwesomeIcons.spotify,
              color: spotifyGreen,
            ),
            const SizedBox(
              width: defaultMargin,
            ),
            Container(
              width: 5,
              height: 100,
              decoration: BoxDecoration(
                  color: spotifyGreen, borderRadius: BorderRadius.circular(20)),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: defaultMargin),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      spot.details.item.name,
                      style: Theme.of(context)
                          .textTheme
                          .headline6!
                          .copyWith(color: Colors.white),
                    ),
                    const SizedBox(
                      height: defaultMargin / 2,
                    ),
                    Text(
                      spot.details.item.artists.join(", "),
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(color: Colors.white),
                    ),
                    const SizedBox(
                      height: defaultMargin,
                    ),
                    Text(
                      spot.details.item.album.name,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(color: Colors.white),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

class SpotScreenBackground extends StatelessWidget {
  const SpotScreenBackground({
    Key? key,
    required this.size,
    required this.spot,
  }) : super(key: key);

  final Size size;
  final Spot spot;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius:
              const BorderRadius.vertical(bottom: Radius.circular(20)),
          child: SizedBox(
            height: size.height,
            width: size.width,
            child: Container(
              color: Colors.black.withOpacity(0),
              child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: spot.details.item.album.images[0].url),
            ),
          ),
        ),
        Positioned.fill(
            child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            color: Colors.black.withOpacity(0.3),
          ),
        ))
      ],
    );
  }
}
