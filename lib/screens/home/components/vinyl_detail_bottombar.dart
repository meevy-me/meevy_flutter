import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:soul_date/screens/home/models/vinyl_model.dart';
import 'package:soul_date/services/color_utils.dart';
import 'package:soul_date/services/images.dart';
import 'package:soul_date/services/spotify_utils.dart';

import '../../../constants/constants.dart';

class VinylBottomBar extends StatefulWidget {
  const VinylBottomBar({Key? key, required this.vinylModel}) : super(key: key);
  final VinylModel vinylModel;

  @override
  State<VinylBottomBar> createState() => _VinylBottomBarState();
}

class _VinylBottomBarState extends State<VinylBottomBar> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PaletteGenerator>(
        future: getImageColors(widget.vinylModel.item.album.images.first.url),
        builder: (context, snapshot) {
          final Color bgColor =
              snapshot.hasData && snapshot.data!.dominantColor != null
                  ? snapshot.data!.dominantColor!.color
                  : Theme.of(context).primaryColor;
          final double luminance = computeLuminance(bgColor);
          final Color iconColor = luminance > 0.5
              ? Theme.of(context).colorScheme.primaryContainer
              : Colors.white;
          return AnimatedContainer(
            duration: const Duration(seconds: 1),
            curve: Curves.fastOutSlowIn,
            height: 50,
            padding: const EdgeInsets.symmetric(
                horizontal: defaultMargin, vertical: defaultPadding),
            margin: scaffoldPadding,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FutureBuilder<bool>(
                      future: isVinylLiked(widget.vinylModel),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done &&
                            snapshot.data != null) {
                          return _VinylBottomItem(
                            color: bgColor,
                            onPress: () {
                              if (!snapshot.data!) {
                                vinylLike(context, widget.vinylModel);
                              } else {
                                vinylLikeRemove(context, widget.vinylModel);
                              }
                              setState(() {});
                            },
                            iconColor: iconColor,
                            iconData: snapshot.data!
                                ? CupertinoIcons.heart_slash_fill
                                : CupertinoIcons.heart_fill,
                            title: "Like",
                          );
                        }
                        return const SpinKitPulse(
                          color: Colors.grey,
                        );
                      }),
                  _VinylBottomItem(
                    color: bgColor,
                    onPress: () {
                      trackPlay(context, widget.vinylModel.item);
                    },
                    iconColor: iconColor,
                    iconData: CupertinoIcons.play_arrow_solid,
                    title: "Play",
                  ),
                  FutureBuilder<bool>(
                      future: isTrackInPlaylist(
                          item: widget.vinylModel.item,
                          sender: widget.vinylModel.sender),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done &&
                            snapshot.data != null) {
                          return _VinylBottomItem(
                            color: bgColor,
                            onPress: () {
                              snapshot.data!
                                  ? vinylPlaylistRemove(
                                      context, widget.vinylModel)
                                  : vinylPlaylist(context, widget.vinylModel);
                              setState(() {});
                            },
                            iconColor: iconColor,
                            iconData: snapshot.data!
                                ? Icons.playlist_remove
                                : Icons.playlist_add,
                            title: snapshot.data! ? "Remove" : "Add",
                          );
                        }
                        return const SpinKitPulse(
                          color: Colors.grey,
                        );
                      }),
                  _VinylBottomItem(
                    color: bgColor,
                    onPress: () {
                      vinylQueue(context, widget.vinylModel.item);
                    },
                    iconColor: iconColor,
                    iconData: Icons.queue_music,
                    title: "Queue",
                  ),
                ],
              ),
            ),
          );
        });
  }
}

class _VinylBottomItem extends StatelessWidget {
  const _VinylBottomItem({
    Key? key,
    required this.iconData,
    this.onPress,
    required this.title,
    required this.color,
    required this.iconColor,
  }) : super(key: key);
  // final Widget icon;
  final void Function()? onPress;
  final IconData iconData;
  final String title;
  final Color color;
  final Color iconColor;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      child: AnimatedContainer(
        width: 40,
        height: 40,
        // padding: const EdgeInsets.all(defaultPadding),
        duration: const Duration(seconds: 1),
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        child: Center(
          child: Center(
            child: Icon(
              iconData,
              color: iconColor,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }
}
