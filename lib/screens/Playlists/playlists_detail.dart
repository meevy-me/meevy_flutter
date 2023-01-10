import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:soul_date/components/cached_image_error.dart';
import 'package:soul_date/components/icon_container.dart';
import 'package:soul_date/components/image_circle.dart';
import 'package:soul_date/components/pulse.dart';
import 'package:soul_date/constants/constants.dart';
import 'package:soul_date/models/Spotify/base_model.dart';
import 'package:soul_date/models/meevy_playlists.dart';
import 'package:soul_date/screens/Playlists/models/firebase_playlist.dart';
import 'package:soul_date/screens/Playlists/models/meevy_playlist_detail.dart';
import 'package:text_scroll/text_scroll.dart';

import 'components/playlist_song_card.dart';

class PlaylistDetailPage extends StatelessWidget {
  const PlaylistDetailPage({
    Key? key,
    required this.meevyBasePlaylist,
    this.tracksFn,
  }) : super(key: key);
  final MeevyBasePlaylist meevyBasePlaylist;
  final Future<List<SpotifyData>> Function()? tracksFn;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(
            Icons.chevron_left,
            size: 30,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: scaffoldPadding,
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: defaultPadding),
                          child: Text(
                            meevyBasePlaylist.name,
                            style: Theme.of(context)
                                .textTheme
                                .headline4!
                                .copyWith(color: Colors.white),
                          ),
                        ),
                        Text(
                          meevyBasePlaylist.description,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2!
                              .copyWith(color: Colors.grey),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: defaultMargin),
                          child: Row(
                            children: [
                              RowSuper(
                                  children: meevyBasePlaylist.contributors
                                      .map((e) => SoulCircleAvatar(
                                            imageUrl: e.profilePicture.image,
                                            radius: 12,
                                          ))
                                      .toList()),
                              if (meevyBasePlaylist.caption != null)
                                Text(
                                  meevyBasePlaylist.caption!,
                                  style: Theme.of(context).textTheme.caption,
                                )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: defaultMargin),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              PlaylistDetailAction(
                                iconData: CupertinoIcons.play_fill,
                                onPress: (() {}),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: defaultMargin),
                                child: PlaylistDetailAction(
                                  iconData: FontAwesomeIcons.spotify,
                                  color: Theme.of(context).colorScheme.tertiary,
                                  onPress: (() {}),
                                ),
                              ),
                              PlaylistDetailAction(
                                  iconData: CupertinoIcons.hand_thumbsup_fill,
                                  onPress: () {})
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  meevyBasePlaylist.imageUrl != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: SoulCachedNetworkImage(
                            imageUrl: meevyBasePlaylist.imageUrl!,
                            width: 100,
                            height: 120,
                          ))
                      : const SizedBox.shrink()
                ],
              ),
              const SizedBox(
                height: defaultMargin * 2,
              ),
              Expanded(
                  child: FutureBuilder<List<SpotifyData>>(
                      future: tracksFn!(),
                      builder: (context, snapshot) {
                        if (snapshot.data != null &&
                            snapshot.connectionState == ConnectionState.done) {
                          List<SpotifyData> data = snapshot.data!;
                          return ListView.builder(
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              SpotifyData spotifyData = data[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: defaultMargin),
                                child: PlaylistDetailSongCard(
                                    spotifyData: spotifyData),
                              );
                            },
                          );
                        } else if (snapshot.data != null &&
                            snapshot.data!.isEmpty) {
                          return Text(
                            "There's nothing here",
                            style: Theme.of(context).textTheme.caption,
                          );
                        } else if (snapshot.hasError) {
                          Text(snapshot.error.toString());
                        }
                        return LoadingPulse();
                      }))
            ],
          ),
        ),
      ),
    );
  }
}

class PlaylistDetailAction extends StatelessWidget {
  const PlaylistDetailAction({
    Key? key,
    required this.iconData,
    required this.onPress,
    this.color,
  }) : super(key: key);
  final IconData iconData;
  final void Function()? onPress;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      child: Container(
        width: 70,
        padding: const EdgeInsets.all(defaultPadding),
        decoration: BoxDecoration(
            // color: color ?? Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(15)),
        child: Center(
            child: Icon(
          iconData,
          size: 30,
          color: Colors.white,
        )),
      ),
    );
  }
}
