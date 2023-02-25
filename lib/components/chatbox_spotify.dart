import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:soul_date/components/chatbox.dart';
import 'package:soul_date/components/icon_container.dart';
import 'package:soul_date/components/pulse.dart';
import 'package:soul_date/constants/constants.dart';
import 'package:soul_date/controllers/SoulController.dart';
import 'package:soul_date/models/Spotify/base_model.dart';
import 'package:soul_date/models/models.dart';
import 'package:soul_date/services/spotify.dart';
import 'package:soul_date/services/spotify_utils.dart';

class ChatSpotify extends StatefulWidget {
  const ChatSpotify({
    Key? key,
    required this.message,
    required this.width,
    required this.profile,
  }) : super(key: key);

  // final ChatBox widget;
  // final SpotifyData? spotifyData;
  final Message message;
  final double width;
  final Profile profile;

  @override
  State<ChatSpotify> createState() => _ChatSpotifyState();
}

class _ChatSpotifyState extends State<ChatSpotify>
    with AutomaticKeepAliveClientMixin {
  final SoulController soulController = Get.find<SoulController>();
  // SpotifyData? spotifyData;
  Future<SpotifyData?> getData() async {
    if (widget.message.content.contains("https://open.spotify.com/")) {
      var text =
          widget.message.content.replaceAll("https://open.spotify.com/", "");
      var keys = text.split("/");
      var field = keys[0];

      var fieldId = keys[1];
      if (fieldId.contains("?")) {
        fieldId = fieldId.split("?")[0];
      }
      return await soulController.spotify.getItem(field, fieldId);
    }
    return null;
  }

  late Future<SpotifyData?> _future;
  @override
  void initState() {
    _future = getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SpotifyData?>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data != null) {
            SpotifyData? spotifyData = snapshot.data;

            return GestureDetector(
              onTap: (() async {
                if (spotifyData != null) {
                  // if (await canLaunchUrlString(spotifyData!.url)) {
                  Spotify().openSpotify(spotifyData.uri, spotifyData.url);
                }
              }),
              child: SizedBox(
                width: widget.width,
                child: Column(
                  children: [
                    Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: CachedNetworkImage(
                            imageUrl: spotifyData!.image,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: defaultMargin / 2,
                              horizontal: defaultPadding),
                          child: Row(
                            children: [
                              const Icon(
                                FontAwesomeIcons.spotify,
                                color: spotifyGreen,
                                size: 15,
                              ),
                              const SizedBox(
                                width: defaultMargin,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      spotifyData.type.toUpperCase(),
                                      style:
                                          Theme.of(context).textTheme.caption,
                                    ),
                                    Text(
                                      spotifyData.itemName,
                                      style: Theme.of(context)
                                          .textTheme
                                          .caption!
                                          .copyWith(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      height: defaultPadding,
                                    ),
                                    Text(
                                      spotifyData.caption,
                                      style: Theme.of(context)
                                          .textTheme
                                          .caption!
                                          .copyWith(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    _SongActions(
                        spotifyData: spotifyData, profile: widget.profile)
                  ],
                ),
              ),
            );
          } else {
            return const LoadingPulse();
          }
        });
  }

  @override
  bool get wantKeepAlive => true;
}

class _SongActions extends StatefulWidget {
  const _SongActions({
    Key? key,
    required this.spotifyData,
    required this.profile,
  }) : super(key: key);

  final SpotifyData spotifyData;
  final Profile profile;

  @override
  State<_SongActions> createState() => _SongActionsState();
}

class _SongActionsState extends State<_SongActions> {
  final SoulController controller = Get.find<SoulController>();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconContainer(
          icon: Icon(
            CupertinoIcons.play_fill,
            color: Theme.of(context).colorScheme.tertiary,
            size: 25,
          ),
          color: Colors.white,
          size: 35,
          onPress: () => trackPlay(context, widget.spotifyData),
        ),
        FutureBuilder<bool>(
            future: isTrackLiked(widget.spotifyData),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.data != null) {
                bool isLiked = snapshot.data!;

                return IconContainer(
                  onPress: () {
                    isLiked
                        ? trackLikeRemove(context, widget.spotifyData)
                        : trackLike(context, widget.spotifyData);

                    setState(() {});
                  },
                  icon: Icon(
                    CupertinoIcons.heart_fill,
                    color:
                        isLiked ? Theme.of(context).primaryColor : Colors.grey,
                    size: 25,
                  ),
                  color: Colors.white,
                  size: 35,
                );
              }
              return const LoadingPulse();
            }),
        const SizedBox(
          width: defaultMargin * 2,
        ),
        FutureBuilder<bool>(
            future: isTrackInPlaylist(
                sender: widget.profile, item: widget.spotifyData),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.data != null) {
                bool isLiked = snapshot.data!;
                return IconContainer(
                  onPress: () async {
                    !isLiked
                        ? trackAddToPlaylist(
                            sender: widget.profile,
                            receiver: controller.profile!,
                            item: widget.spotifyData)
                        : trackPlaylistRemove(
                            sender: widget.profile,
                            receiver: controller.profile!,
                            item: widget.spotifyData);

                    setState(() {});
                  },
                  icon: Icon(
                    isLiked ? Icons.playlist_remove : Icons.playlist_add,
                    color:
                        isLiked ? Theme.of(context).primaryColor : Colors.grey,
                    size: 25,
                  ),
                  color: Colors.white,
                  size: 35,
                );
              }
              return const LoadingPulse();
            })
      ],
    );
  }
}
