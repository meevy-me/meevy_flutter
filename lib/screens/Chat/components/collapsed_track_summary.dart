import 'dart:math';

import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:soul_date/components/icon_container.dart';
import 'package:soul_date/components/image_circle.dart';
import 'package:soul_date/models/Spotify/base_model.dart';
import 'package:soul_date/services/spotify_utils.dart';
import 'package:text_scroll/text_scroll.dart';

import '../../../constants/constants.dart';
import '../../../services/formatting.dart';

class CollapsedTrackSummary extends StatelessWidget {
  const CollapsedTrackSummary({
    Key? key,
    required this.items,
    required this.playlistID,
  }) : super(key: key);

  final List<SpotifyData> items;
  final String playlistID;

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      if (items.isNotEmpty) {
        return Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RowSuper(innerDistance: -10, children: [
              for (int i = 0; i < items.take(3).length; i++)
                SoulCircleAvatar(
                  imageUrl: items[i].image,
                  radius: 15,
                ),
              if (items.length > 3)
                items.length != 3
                    ? Container(
                        height: 9.2 * pi,
                        width: 9.2 * pi,
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.6),
                            shape: BoxShape.circle),
                        child: Center(
                          child: Text(
                            '+${items.length - 3}',
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
                padding: const EdgeInsets.symmetric(horizontal: defaultMargin),
                child: TextScroll(
                  joinList(items.map((e) => e.caption).toList(), count: 3),
                  delayBefore: const Duration(seconds: 2),
                  velocity: const Velocity(pixelsPerSecond: Offset(30, 0)),
                  style: Theme.of(context).textTheme.caption,
                ),
              ),
            ),
            IconContainer(
              onPress: () {
                mutualPlaylistPlayAll(context, playlistID);
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
        );
      } else {
        return SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: Center(
              child: Text(
                "Mutual Playlist is empty :( Share and add your first track",
                style: Theme.of(context).textTheme.caption,
              ),
            ),
          ),
        );
      }
    });
  }
}
