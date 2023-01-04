import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:flutter/material.dart';
import 'package:soul_date/components/appbar_home.dart';
import 'package:soul_date/components/image_circle.dart';
import 'package:soul_date/constants/constants.dart';
import 'package:soul_date/screens/home/components/current_playing.dart';

import 'components/meevy_playlists.dart';
import 'components/received_songs.dart';

class HomeFeed extends StatefulWidget {
  const HomeFeed({Key? key}) : super(key: key);

  @override
  State<HomeFeed> createState() => _HomeFeedState();
}

class _HomeFeedState extends State<HomeFeed> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            const SliverAppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                title: HomeAppBar(),
                pinned: true,
                expandedHeight: 220,
                flexibleSpace: FlexibleSpaceBar(
                  background: CurrentlyPlaying(
                    padding: EdgeInsets.only(
                        top: defaultMargin * 6,
                        right: defaultMargin,
                        left: defaultMargin),
                  ),
                ))
          ];
        },
        body: ListView(children: [
          const ReceivedSongsList(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultMargin * 2),
            child: MeevyPlaylistList(),
          )
        ]),
      ),
    );
  }
}
