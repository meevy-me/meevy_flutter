import 'dart:convert';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:soul_date/components/buttons.dart';
import 'package:soul_date/components/image_circle.dart';
import 'package:soul_date/constants/constants.dart';
import 'package:soul_date/controllers/SpotController.dart';
import 'package:soul_date/models/spotify_spot_details.dart';

class MySpotScreen extends StatefulWidget {
  const MySpotScreen({Key? key, required this.details}) : super(key: key);
  final SpotifyDetails details;

  @override
  State<MySpotScreen> createState() => _MySpotScreenState();
}

class _MySpotScreenState extends State<MySpotScreen> {
  final TextEditingController caption = TextEditingController();
  final SpotController controller = Get.find<SpotController>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,
      body: ListView(
        children: [
          Stack(children: [
            SpotScreenBackground(
              size: size,
              details: widget.details,
            ),
            SafeArea(
              child: SizedBox(
                height: size.height * 0.9,
                child: Padding(
                  padding: scaffoldPadding,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(1),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Theme.of(context).primaryColor)),
                                child: const SoulCircleAvatar(
                                  imageUrl: defaultGirlUrl,
                                  radius: 18,
                                ),
                              ),
                              const SizedBox(
                                width: defaultMargin,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "My Spot",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .copyWith(color: Colors.white),
                                  ),
                                  // Text(
                                  //   "${DateTime.now().difference(spot.dateAdded).inHours} Hrs ago.",
                                  //   style: Theme.of(context)
                                  //       .textTheme
                                  //       .caption!
                                  //       .copyWith(color: Colors.white),
                                  // )
                                ],
                              )
                            ],
                          ),
                          IconButton(
                              onPressed: () {
                                Get.back();
                              },
                              icon: const Icon(
                                Icons.close,
                                color: Colors.white,
                              ))
                        ],
                      ),
                      Expanded(
                        child: Center(
                          child: _SongWithImage(
                            details: widget.details,
                            controller: caption,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ]),
          _BottomSection(
            controller: caption,
            details: widget.details,
            spotController: controller,
          )
        ],
      ),
    );
  }
}

class _BottomSection extends StatelessWidget {
  const _BottomSection({
    required this.controller,
    required this.details,
    Key? key,
    required this.spotController,
  }) : super(key: key);
  final TextEditingController controller;
  final SpotifyDetails details;
  final SpotController spotController;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.symmetric(horizontal: defaultMargin),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                showModalBottomSheet(
                    backgroundColor: Colors.transparent,
                    context: context,
                    builder: (context) {
                      return Container(
                          height: 700,
                          padding: scaffoldPadding * 2,
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(20)),
                          child: Column(
                            children: [
                              TextFormField(
                                controller: controller,
                                maxLines: 2,
                                autofocus: true,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2!
                                    .copyWith(color: Colors.white),
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white.withOpacity(0.2),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide(
                                            color: Theme.of(context)
                                                .primaryColor)),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    hintText: "Add Caption to text",
                                    hintStyle:
                                        Theme.of(context).textTheme.caption),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: defaultMargin * 3),
                                child: PrimaryButton(
                                    onPress: () {
                                      Navigator.pop(context);
                                    },
                                    text: "Add Caption"),
                              )
                            ],
                          ));
                    });
              },
              child: controller.text.isNotEmpty
                  ? Text(
                      controller.text,
                      style: Theme.of(context).textTheme.caption,
                      overflow: TextOverflow.ellipsis,
                    )
                  : Row(
                      children: [
                        const Icon(
                          FontAwesomeIcons.penToSquare,
                          color: Colors.grey,
                          size: 18,
                        ),
                        const SizedBox(
                          width: defaultPadding,
                        ),
                        Text(
                          "Add Caption",
                          style: Theme.of(context).textTheme.caption,
                        )
                      ],
                    ),
            ),
          ),
          ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).primaryColor,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20))),
              onPressed: () async {
                spotController.createSpot(
                  {
                    "spotifyDetails": json.encode(details.toJson()),
                    "caption": controller.text,
                  },
                  context: context,
                );
              },
              icon: const Icon(
                FontAwesomeIcons.spotify,
                color: Colors.white,
              ),
              label: const Text("Post"))
        ],
      ),
    );
  }
}

class _SongWithImage extends StatelessWidget {
  const _SongWithImage(
      {Key? key, required this.details, required this.controller})
      : super(key: key);

  final SpotifyDetails details;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: CachedNetworkImage(
              imageUrl: details.item.album.images[0].url,
              height: 300,
              width: 300,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: defaultMargin * 2),
          child: _SongDetails(
            details: details,
          ),
        ),
      ],
    );
  }
}

class _SongDetails extends StatelessWidget {
  const _SongDetails({
    Key? key,
    required this.details,
  }) : super(key: key);

  final SpotifyDetails details;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Row(
        children: [
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
                  Flexible(
                    child: Text(
                      details.item.name,
                      style: Theme.of(context)
                          .textTheme
                          .headline6!
                          .copyWith(color: Colors.white),
                    ),
                  ),
                  const SizedBox(
                    height: defaultMargin / 2,
                  ),
                  Text(
                    details.item.artists.join(", "),
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(color: Colors.white),
                  ),
                  const SizedBox(
                    height: defaultMargin,
                  ),
                  Text(
                    details.item.album.name,
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
  }
}

class SpotScreenBackground extends StatelessWidget {
  const SpotScreenBackground({
    Key? key,
    required this.size,
    required this.details,
  }) : super(key: key);

  final Size size;
  final SpotifyDetails details;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius:
              const BorderRadius.vertical(bottom: Radius.circular(20)),
          child: SizedBox(
            height: size.height * 0.9,
            width: size.width,
            child: Container(
              color: Colors.black.withOpacity(0),
              child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: details.item.album.images[0].url),
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
