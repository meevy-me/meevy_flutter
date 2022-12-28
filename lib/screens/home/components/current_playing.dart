import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:marquee/marquee.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:soul_date/components/buttons.dart';
import 'package:soul_date/components/icon_container.dart';
import 'package:soul_date/constants/constants.dart';
import 'package:soul_date/screens/profile_home.dart';
import 'package:text_scroll/text_scroll.dart';
import '../../../components/image_circle.dart';
import '../../../controllers/SoulController.dart';
import '../../../models/spotify_spot_details.dart' as Spotify;
import '../../../services/images.dart';

class CurrentlyPlaying extends StatelessWidget {
  const CurrentlyPlaying({Key? key, this.padding = scaffoldPadding})
      : super(key: key);
  final EdgeInsets padding;
  Color textColor(Color bgColor) {
    if (bgColor.computeLuminance() > 0.5) {
      return Colors.black;
    } else {
      return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return StreamBuilder<Spotify.Item?>(
        stream: FirebaseDatabase.instance
            .ref()
            .child('currentlyPlaying')
            //TODO: USE My current listening
            .child('1')
            .onValue
            .map((event) {
          final data = jsonDecode(jsonEncode(event.snapshot.value))
              as Map<String, dynamic>?;
          if (data != null) {
            return Spotify.Item.fromJson(data);
          }
          return null;
        }),
        builder: (context, snapshot) {
          return snapshot.hasData && snapshot.data != null
              ? FutureBuilder<PaletteGenerator?>(
                  future: snapshot.data != null
                      ? getImageColors(snapshot.data!.album.images.first.url)
                      : null,
                  builder: (context, color) {
                    Color colorText =
                        textColor(color.data!.dominantColor!.color);
                    return Column(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 1250),
                          padding: scaffoldPadding,
                          decoration: BoxDecoration(
                              color: color.data != null &&
                                      color.data!.dominantColor != null
                                  ? color.data!.dominantColor!.color
                                      .withOpacity(0.6)
                                  : Theme.of(context).colorScheme.outline),
                          child: Padding(
                            padding: padding,
                            child: Column(
                              children: [
                                // _AppBar(
                                //   textColor: colorText,
                                // ),
                                const SizedBox(
                                  height: defaultMargin * 2,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 110,
                                      height: 110,
                                      child: CachedNetworkImage(
                                        fit: BoxFit.fitWidth,
                                        imageUrl: snapshot
                                            .data!.album.images.first.url,
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            // vertical: defaultPadding,
                                            horizontal: defaultMargin),
                                        child: LimitedBox(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Icon(
                                                    FontAwesomeIcons.spotify,
                                                    size: 15,
                                                    color: color.data!
                                                        .dominantColor!.color,
                                                  ),
                                                  const SizedBox(
                                                    width: defaultPadding,
                                                  ),
                                                  Text(
                                                    "Currently playing on spotify",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .caption!
                                                        .copyWith(
                                                            color: colorText),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: defaultPadding,
                                              ),
                                              TextScroll(snapshot.data!.name,
                                                  velocity: Velocity(
                                                      pixelsPerSecond:
                                                          Offset(2, 0)),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1!
                                                      .copyWith(
                                                          color: colorText,
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical:
                                                            defaultPadding),
                                                child: TextScroll(
                                                  snapshot.data!.artists
                                                      .join(", "),
                                                  velocity: Velocity(
                                                      pixelsPerSecond:
                                                          Offset(2, 0)),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1!
                                                      .copyWith(
                                                          color: colorText,
                                                          fontSize: 15),
                                                ),
                                              ),
                                              TextScroll(
                                                snapshot.data!.album.name,
                                                velocity: Velocity(
                                                    pixelsPerSecond:
                                                        Offset(2, 0)),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1!
                                                    .copyWith(
                                                        color: colorText,
                                                        fontSize: 13),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    _ActionButton(
                                      color: color.data!.dominantColor!.color,
                                      icon: const Icon(
                                        CupertinoIcons.heart_fill,
                                        color: Colors.white,
                                      ),
                                      text: "Like",
                                    ),
                                    const SizedBox(
                                      width: defaultMargin,
                                    ),
                                    _ActionButton(
                                      color: color.data!.dominantColor!.color,
                                      icon: const Icon(
                                        CupertinoIcons.paperplane_fill,
                                        color: Colors.white,
                                      ),
                                      text: "Send",
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  })
              : const Padding(
                  padding: scaffoldPadding,
                  child: HomeAppBar(),
                );
        });
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    Key? key,
    required this.color,
    required this.icon,
    required this.text,
    this.onPress,
  }) : super(key: key);
  final Color? color;
  final Widget icon;
  final String text;
  final void Function()? onPress;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: defaultMargin),
        decoration: BoxDecoration(
            color: color ?? Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(20)),
        child: Row(
          children: [
            icon,
            const SizedBox(
              width: defaultPadding,
            ),
            Text(
              text,
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({Key? key, this.textColor}) : super(key: key);
  final Color? textColor;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RichText(
            text: TextSpan(children: [
          TextSpan(
              text: "Hello, ",
              style: Theme.of(context)
                  .textTheme
                  .headline5!
                  .copyWith(fontWeight: FontWeight.w600, color: textColor)),
          TextSpan(
              text: "Edwin",
              style: Theme.of(context)
                  .textTheme
                  .headline5!
                  .copyWith(color: textColor, fontWeight: FontWeight.w600))
        ])),
        GetBuilder<SoulController>(builder: (controller) {
          return controller.profile != null
              ? Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MyProfileScreen()));
                      },
                      child: SoulCircleAvatar(
                        imageUrl: controller.profile!.images.last.image,
                        radius: 18,
                      ),
                    ),
                  ],
                )
              : const SizedBox.shrink();
        }),
      ],
    );
  }
}
