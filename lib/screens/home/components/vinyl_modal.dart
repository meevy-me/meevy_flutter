import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:soul_date/constants/constants.dart';
import 'package:soul_date/screens/home/models/vinyl_model.dart';
import 'package:soul_date/services/spotify_utils.dart';
import 'package:text_scroll/text_scroll.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class VinylModal extends StatelessWidget {
  const VinylModal({Key? key, required this.vinyl}) : super(key: key);
  final VinylModel vinyl;
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
                  imageUrl: vinyl.item.album.images.first.url,
                  width: 140,
                  height: 140,
                ),
                SizedBox(
                  height: defaultMargin,
                ),
                TextScroll(
                  vinyl.item.name,
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: defaultPadding),
                  child: Text(
                    vinyl.item.artists.first.name,
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
              VinylModalAction(
                icon: CupertinoIcons.heart_fill,
                text: "Like",
              ),
              VinylModalAction(
                onPress: () {
                  vinylPlay(context, vinyl);
                  Navigator.pop(context);
                },
                icon: CupertinoIcons.play_fill,
                text: "Play",
              ),
              VinylModalAction(
                icon: Icons.queue_music_outlined,
                text: "Add to Queue",
                onPress: () {
                  vinylQueue(context, vinyl);
                  Navigator.pop(context);
                },
              ),
              VinylModalAction(
                icon: Icons.playlist_add,
                onPress: () {
                  vinylPlaylist(context, vinyl);
                  Navigator.pop(context);
                },
                text: "Add to Mutual Playlist",
              ),
              VinylModalAction(
                onPress: () {
                  vinylOpenSpotify(context, vinyl);
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
