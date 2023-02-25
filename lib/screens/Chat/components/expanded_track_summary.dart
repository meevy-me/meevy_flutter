import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:soul_date/animations/animations.dart';
import 'package:soul_date/components/icon_container.dart';
import 'package:soul_date/models/Spotify/base_model.dart';
import 'package:soul_date/screens/Playlists/components/playlist_song_card.dart';
import 'package:soul_date/services/spotify_utils.dart';

import '../../../constants/constants.dart';
import '../../../models/models.dart';

class ExpandedTrackSummary extends StatefulWidget {
  const ExpandedTrackSummary(
      {Key? key,
      required this.items,
      required this.onCollapse,
      required this.friends,
      required this.playlistID})
      : super(key: key);
  final List<SpotifyData> items;
  final void Function() onCollapse;
  final Friends friends;
  final String playlistID;

  @override
  State<ExpandedTrackSummary> createState() => _ExpandedTrackSummaryState();
}

class _ExpandedTrackSummaryState extends State<ExpandedTrackSummary> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          children: [
            IconContainer(
                onPress: widget.onCollapse,
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.white,
                  size: 35,
                )),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: defaultMargin),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${widget.friends.currentProfile.name} & ${widget.friends.friendsProfile.name}",
                    style: Theme.of(context)
                        .textTheme
                        .headline6!
                        .copyWith(color: Colors.white),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: defaultMargin),
                    child: Text(
                      "${widget.items.length} songs",
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(fontSize: 13, color: Colors.white),
                    ),
                  )
                ],
              ),
              IconContainer(
                icon: const Icon(
                  CupertinoIcons.play_fill,
                  size: 30,
                  color: Colors.white,
                ),
                size: 40,
                color: spotifyGreen,
                onPress: () =>
                    mutualPlaylistPlayAll(context, widget.playlistID),
              )
            ],
          ),
        ),
        Expanded(
          child: NotificationListener(
            onNotification: (notification) {
              if (notification is ScrollEndNotification) {
                if (notification.metrics.pixels ==
                    notification.metrics.maxScrollExtent - 10) {
                  widget.onCollapse();
                }
              }
              return false;
            },
            child: DelayedDisplay(
              delay: const Duration(milliseconds: 800),
              child: ListView.builder(
                controller: _scrollController,
                itemCount: widget.items.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: defaultMargin),
                    child: PlaylistDetailSongCard(
                        spotifyData: widget.items[index],
                        sender: widget.friends.friendsProfile),
                  );
                },
              ),
            ),
          ),
        )
      ],
    );
  }
}
