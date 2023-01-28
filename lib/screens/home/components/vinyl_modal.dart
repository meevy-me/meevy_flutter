import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:soul_date/constants/constants.dart';
import 'package:soul_date/controllers/SoulController.dart';
import 'package:soul_date/models/Spotify/base_model.dart';
import 'package:soul_date/screens/home/models/vinyl_model.dart';
import 'package:soul_date/services/spotify_utils.dart';
import 'package:text_scroll/text_scroll.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../../../models/profile_model.dart';

class VinylModal extends StatefulWidget {
  const VinylModal({
    Key? key,
    required this.spotifyData,
    required this.sender,
    this.vinylModel,
    this.addToPlaylist,
  }) : super(key: key);
  final SpotifyData spotifyData;
  final Profile sender;
  final VinylModel? vinylModel;
  final void Function()? addToPlaylist;

  @override
  State<VinylModal> createState() => _VinylModalState();
}

class _VinylModalState extends State<VinylModal> {
  final SoulController soulController = Get.find<SoulController>();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: scaffoldPadding,
      constraints: BoxConstraints(
          minHeight: size.height * 0.7, maxHeight: size.height * 0.8),
      decoration:
          BoxDecoration(color: Theme.of(context).colorScheme.primaryContainer),
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultMargin * 2),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CachedNetworkImage(
                  imageUrl: widget.spotifyData.image,
                  width: 140,
                  height: 140,
                ),
                const SizedBox(
                  height: defaultMargin,
                ),
                TextScroll(
                  widget.spotifyData.itemName,
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: defaultPadding),
                  child: Text(
                    widget.spotifyData.caption,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(color: Colors.white),
                  ),
                )
              ],
            ),
          ),
          Column(
            children: [
              FutureBuilder<bool>(
                  future: isTrackLiked(widget.spotifyData),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done &&
                        snapshot.data != null) {
                      return VinylModalAction(
                        icon: snapshot.data!
                            ? CupertinoIcons.heart_slash_fill
                            : CupertinoIcons.heart_fill,
                        text: snapshot.data! ? "Remove from liked" : "Like",
                        onPress: () {
                          if (!snapshot.data!) {
                            trackLike(context, widget.spotifyData,
                                sender: widget.sender);
                          } else {
                            trackLikeRemove(context, widget.spotifyData);
                          }
                          Navigator.pop(context);
                        },
                      );
                    }
                    return const SpinKitPulse(
                      color: Colors.grey,
                    );
                  }),
              VinylModalAction(
                onPress: () {
                  trackPlay(context, widget.spotifyData,
                      vinyl: widget.vinylModel);
                  Navigator.pop(context);
                },
                icon: CupertinoIcons.play_fill,
                text: "Play",
              ),
              VinylModalAction(
                icon: Icons.queue_music_outlined,
                text: "Add to Queue",
                onPress: () {
                  vinylQueue(context, widget.spotifyData,
                      vinyl: widget.vinylModel);
                  Navigator.pop(context);
                },
              ),
              FutureBuilder<bool>(
                  future: isTrackInPlaylist(
                      sender: widget.sender, item: widget.spotifyData),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done &&
                        snapshot.data != null) {
                      return VinylModalAction(
                        icon: snapshot.data!
                            ? Icons.playlist_remove
                            : Icons.playlist_add,
                        onPress: () {
                          snapshot.data!
                              ? trackPlaylistRemove(
                                  sender: widget.sender,
                                  receiver: soulController.profile!,
                                  item: widget.spotifyData)
                              : trackAddToPlaylist(
                                  sender: widget.sender,
                                  receiver: soulController.profile!,
                                  item: widget.spotifyData);
                          Navigator.pop(context);
                        },
                        text: snapshot.data!
                            ? "Remove from Mutual Playlist"
                            : "Add to Mutual Playlist",
                      );
                    }
                    return const SpinKitPulse(
                      color: Colors.grey,
                    );
                  }),
              VinylModalAction(
                onPress: () {
                  trackOpenSpotify(context, widget.spotifyData);
                  Navigator.pop(context);
                },
                icon: FontAwesomeIcons.spotify,
                text: "Open on Spotify",
              ),
            ],
          )
        ],
      ),
    );
  }
}

class VinylModalAction extends StatefulWidget {
  const VinylModalAction({
    Key? key,
    required this.icon,
    this.onPress,
    required this.text,
  }) : super(key: key);

  final IconData icon;
  final void Function()? onPress;
  final String text;

  @override
  State<VinylModalAction> createState() => _VinylModalActionState();
}

class _VinylModalActionState extends State<VinylModalAction> {
  @override
  Widget build(BuildContext context) {
    return ZoomTapAnimation(
      onTap: widget.onPress,
      begin: 1.0,
      end: 0.93,
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: defaultMargin, vertical: defaultMargin * 2),
        child: Row(
          children: [
            Icon(
              widget.icon,
              size: 30,
              color: Colors.grey,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: defaultMargin * 2),
              child: Text(
                widget.text,
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(color: Colors.white, fontSize: 14),
              ),
            )
          ],
        ),
      ),
    );
  }
}
