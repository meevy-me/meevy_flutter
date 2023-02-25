import 'dart:math';

import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:soul_date/components/icon_container.dart';
import 'package:soul_date/components/image_circle.dart';
import 'package:soul_date/models/Spotify/base_model.dart';
import 'package:soul_date/services/formatting.dart';
import 'package:soul_date/services/spotify_utils.dart';
import 'package:text_scroll/text_scroll.dart';

import '../../../constants/constants.dart';
import '../../../models/models.dart';

class TrackSummary extends StatefulWidget {
  const TrackSummary(
      {Key? key, required this.friends, required this.playlistID})
      : super(key: key);
  final Friends friends;
  final String playlistID;

  @override
  State<TrackSummary> createState() => _TrackSummaryState();
}

class _TrackSummaryState extends State<TrackSummary> {
  double _screenWidth = 0.0; // initial screen width
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
  }

  void _afterLayout(_) {
    setState(() {
      _screenWidth = MediaQuery.of(context).size.width;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<SpotifyData>>(
        stream: FirebaseFirestore.instance
            .collection('meevyPlaylists')
            .doc(widget.playlistID)
            .collection('tracks')
            .orderBy('date_added', descending: true)
            .snapshots()
            .map((event) => event.docs
                .map((e) => Item.fromJson(e.data()['track']))
                .toList()),
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            return AnimatedContainer(
              width: _screenWidth,
              duration: const Duration(seconds: 1),
              padding: const EdgeInsets.symmetric(
                  horizontal: defaultMargin, vertical: defaultMargin / 1.5),
              margin: scaffoldPadding,
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(20)),
              // color: Theme.of(context).colorScheme.primaryContainer,
              // color: Colors.red,
              child: snapshot.data!.isNotEmpty
                  ? Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RowSuper(innerDistance: -10, children: [
                          for (int i = 0;
                              i < snapshot.data!.take(3).length;
                              i++)
                            SoulCircleAvatar(
                              imageUrl: snapshot.data![i].image,
                              radius: 15,
                            ),
                          snapshot.data!.length != 3
                              ? Container(
                                  height: 9.2 * pi,
                                  width: 9.2 * pi,
                                  decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.6),
                                      shape: BoxShape.circle),
                                  child: Center(
                                    child: Text(
                                      '+${snapshot.data!.length - 3}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .copyWith(fontSize: 16),
                                    ),
                                  ),
                                )
                              : const SizedBox.shrink()
                        ]),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: defaultMargin),
                            child: TextScroll(
                              joinList(
                                  snapshot.data!.map((e) => e.caption).toList(),
                                  count: 3),
                              delayBefore: const Duration(seconds: 2),
                              velocity: const Velocity(
                                  pixelsPerSecond: Offset(30, 0)),
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ),
                        ),
                        IconContainer(
                          onPress: () {
                            mutualPlaylistPlayAll(context, widget.playlistID);
                          },
                          icon: const Icon(
                            CupertinoIcons.play_fill,
                            color: Colors.white,
                            size: 25,
                          ),
                          size: 35,
                          color: Theme.of(context).colorScheme.tertiary,
                        )
                      ],
                    )
                  : SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: defaultPadding),
                        child: Center(
                          child: Text(
                            "Mutual Playlist is empty :( Share and add your first track",
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ),
                      ),
                    ),
            );
          } else {
            return const SizedBox.shrink();
          }
        });
  }
}
