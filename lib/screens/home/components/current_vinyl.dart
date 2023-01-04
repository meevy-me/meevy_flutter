import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:soul_date/screens/home/components/friends_send_modal.dart';
import 'package:text_scroll/text_scroll.dart';

import '../../../components/icon_container.dart';
import '../../../components/image_circle.dart';
import '../../../constants/constants.dart';
import '../../../models/spotify_spot_details.dart' as Spotify;

class CurrentVinyl extends StatelessWidget {
  const CurrentVinyl({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return buildCurrentVinyl(context);
  }
}

Widget buildCurrentVinyl(BuildContext context) {
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
        return Column(
          children: [
            _CurrentlySelected(
              item: snapshot.data,
            ),
          ],
        );
      });
}

class _MusicActions extends StatelessWidget {
  const _MusicActions({
    Key? key,
    required this.iconData,
    this.onPress,
    this.icon,
    required this.text,
  }) : super(key: key);
  final IconData iconData;
  final void Function()? onPress;
  final Widget? icon;
  final String text;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: defaultMargin),
      child: InkWell(
        onTap: onPress,
        child: Container(
          padding: const EdgeInsets.symmetric(
              horizontal: defaultMargin, vertical: defaultPadding),
          decoration: BoxDecoration(
              color: const Color(0xFF613A3F),
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [defaultBoxShadow]),
          child: Center(
            child: Row(
              children: [
                Icon(
                  iconData,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(
                  width: defaultPadding,
                ),
                Text(
                  text,
                  style: Theme.of(context).textTheme.caption!.copyWith(
                      color: Colors.white, fontWeight: FontWeight.w600),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CurrentlySelected extends StatelessWidget {
  const _CurrentlySelected({
    Key? key,
    this.item,
  }) : super(key: key);

  final Spotify.Item? item;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return item != null
        ? SizedBox(
            width: size.width,
            child: Row(children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: CachedNetworkImage(
                  imageUrl: item!.album.images.first.url,
                  height: 110,
                  width: 110,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(
                width: defaultMargin,
              ),
              Expanded(
                child: Container(
                  height: 120,
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      horizontal: defaultMargin, vertical: defaultMargin * 2),
                  decoration: BoxDecoration(
                      gradient: defaultGradient,
                      boxShadow: [],
                      borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            FittedBox(
                              child: Row(
                                children: [
                                  Text(
                                    item!.name,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                  ),
                                  Container(
                                    height: 7,
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: defaultMargin,
                                    ),
                                    width: 7,
                                    decoration: const BoxDecoration(
                                        color: Colors.grey,
                                        shape: BoxShape.circle),
                                  ),
                                  TextScroll(
                                    item!.artists.join(", "),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: defaultPadding / 2),
                              child: FittedBox(
                                child: Text(
                                  item!.album.name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: defaultPadding),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      _MusicActions(
                                        text: "Like",
                                        iconData: CupertinoIcons.heart_fill,
                                        onPress: () {},
                                      ),
                                      // _MusicActions(
                                      //   icon: SvgPicture.asset(
                                      //     'assets/images/playlist_add.svg',
                                      //     width: 20,
                                      //     height: 20,
                                      //     color: Colors.white,
                                      //   ),
                                      //   iconData: CupertinoIcons.music_albums_fill,
                                      //   onPress: () {},
                                      // ),
                                      _MusicActions(
                                        text: "Send",
                                        iconData:
                                            CupertinoIcons.paperplane_fill,
                                        onPress: () {
                                          showModalBottomSheet(
                                            context: context,
                                            builder: (context) => FriendsModal(
                                              item: item!,
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ]),
          )
        : SizedBox.shrink();
  }
}
