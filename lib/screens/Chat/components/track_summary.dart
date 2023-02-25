import 'dart:async';
import 'dart:math';

import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:soul_date/components/icon_container.dart';
import 'package:soul_date/components/image_circle.dart';
import 'package:soul_date/models/Spotify/base_model.dart';
import 'package:soul_date/screens/Chat/components/expanded_track_summary.dart';
import 'package:soul_date/screens/Playlists/components/playlist_song_card.dart';
import 'package:soul_date/services/formatting.dart';
import 'package:soul_date/services/spotify_utils.dart';
import 'package:text_scroll/text_scroll.dart';

import '../../../constants/constants.dart';
import '../../../models/models.dart';
import 'collapsed_track_summary.dart';

class TrackSummary extends StatefulWidget {
  const TrackSummary(
      {Key? key, required this.friends, required this.playlistID})
      : super(key: key);
  final Friends friends;
  final String playlistID;

  @override
  State<TrackSummary> createState() => _TrackSummaryState();
}

class _TrackSummaryState extends State<TrackSummary>
    with SingleTickerProviderStateMixin {
  double _screenWidth = 0.0; // initial screen width

  bool expanded = false;
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
    Size size = MediaQuery.of(context).size;
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
            return GestureDetector(
              onTap: () {
                setState(() {
                  expanded = true;
                });
              },
              child: AnimatedSize(
                duration: const Duration(milliseconds: 800),
                alignment: Alignment.topCenter,
                child: Container(
                    // width: _screenWidth,
                    height: expanded ? size.height * 0.7 : 50,
                    padding: const EdgeInsets.symmetric(
                        horizontal: defaultMargin,
                        vertical: defaultMargin / 1.5),
                    margin: scaffoldPadding,
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(20)),
                    // color: Theme.of(context).colorScheme.primaryContainer,
                    // color: Colors.red,
                    child: expanded
                        ? ExpandedTrackSummary(
                            friends: widget.friends,
                            items: snapshot.data!,
                            playlistID: widget.playlistID,
                            onCollapse: () {
                              setState(() {
                                expanded = false;
                              });
                            },
                          )
                        : CollapsedTrackSummary(
                            items: snapshot.data!,
                            playlistID: widget.playlistID,
                          )),
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        });
  }
}
