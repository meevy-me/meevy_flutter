import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:soul_date/animations/animations.dart';
import 'package:soul_date/components/pulse.dart';
import 'package:soul_date/screens/home/components/friends_send_modal.dart';
import 'package:soul_date/screens/my_spot_screen.dart';
import 'package:soul_date/services/navigation.dart';
import 'package:soul_date/services/spotify_utils.dart';
import 'package:text_scroll/text_scroll.dart';

import '../../../components/icon_container.dart';
import '../../../components/image_circle.dart';
import '../../../constants/constants.dart';
import '../../../models/spotify_spot_details.dart' as Spotify;
import 'current_vinyl_actions.dart';

class CurrentVinyl extends StatelessWidget {
  const CurrentVinyl({Key? key, required this.profileID}) : super(key: key);
  final int? profileID;
  @override
  Widget build(BuildContext context) {
    return profileID != null
        ? buildCurrentVinyl(context, profileID: profileID!)
        : const LoadingPulse();
  }
}

Widget buildCurrentVinyl(BuildContext context, {required int profileID}) {
  return StreamBuilder<Spotify.Item?>(
      stream: FirebaseDatabase.instance
          .ref()
          .child('currentlyPlaying')
          .child(profileID.toString())
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

class _CurrentlySelected extends StatefulWidget {
  const _CurrentlySelected({
    Key? key,
    this.item,
  }) : super(key: key);

  final Spotify.Item? item;

  @override
  State<_CurrentlySelected> createState() => _CurrentlySelectedState();
}

class _CurrentlySelectedState extends State<_CurrentlySelected> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return widget.item != null
        ? SizedBox(
            width: size.width,
            child: Row(children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: CachedNetworkImage(
                  imageUrl: widget.item!.album.images.first.url,
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
                      color: Theme.of(context).colorScheme.primaryContainer,
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
                                    widget.item!.name,
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
                                    widget.item!.artists.join(", "),
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
                                  widget.item!.album.name,
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
                                      FutureBuilder<bool>(
                                          future: isTrackLiked(widget.item!),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                    ConnectionState.done &&
                                                snapshot.data != null) {
                                              var status = snapshot.data!;
                                              return MusicActions(
                                                text:
                                                    status ? "Unlike" : "Like",
                                                iconData: status
                                                    ? CupertinoIcons
                                                        .heart_slash_fill
                                                    : CupertinoIcons.heart_fill,
                                                onPress: () {
                                                  if (status) {
                                                    trackLikeRemove(
                                                        context, widget.item!);
                                                  } else {
                                                    trackLike(
                                                        context, widget.item!);
                                                  }
                                                  setState(() {});
                                                },
                                              );
                                            }
                                            return LoadingPulse();
                                          }),
                                      // MusicActions(
                                      //   icon: SvgPicture.asset(
                                      //     'assets/images/playlist_add.svg',
                                      //     width: 20,
                                      //     height: 20,
                                      //     color: Colors.white,
                                      //   ),
                                      //   iconData: CupertinoIcons.music_albums_fill,
                                      //   onPress: () {},
                                      // ),
                                      MusicActions(
                                        text: "Send",
                                        iconData:
                                            CupertinoIcons.paperplane_fill,
                                        onPress: () {
                                          showModalBottomSheet(
                                            context: context,
                                            builder: (context) => FriendsModal(
                                              item: widget.item!,
                                            ),
                                          );
                                        },
                                      ),
                                      MusicActions(
                                        iconData: CupertinoIcons.sparkles,
                                        text: "Spot",
                                        icon: SvgPicture.asset(
                                          'assets/images/status.svg',
                                          color: Theme.of(context).primaryColor,
                                          width: 20,
                                        ),
                                        onPress: () {
                                          Navigation.push(context,
                                              customPageTransition:
                                                  PageTransition(
                                                      child: MySpotScreen(
                                                          details:
                                                              widget.item!),
                                                      type: PageTransitionType
                                                          .fadeIn));
                                        },
                                      )
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
