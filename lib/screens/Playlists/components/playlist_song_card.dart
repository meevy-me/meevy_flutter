import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:soul_date/components/cached_image_error.dart';
import 'package:soul_date/models/Spotify/base_model.dart';
import 'package:text_scroll/text_scroll.dart';

import '../../../constants/constants.dart';

class PlaylistDetailSongCard extends StatelessWidget {
  const PlaylistDetailSongCard({
    Key? key,
    required this.spotifyData,
  }) : super(key: key);

  final SpotifyData spotifyData;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          SoulCachedNetworkImage(
            imageUrl: spotifyData.image,
            width: 50,
            height: 50,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultMargin),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextScroll(
                    spotifyData.itemName,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(color: Colors.white),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: defaultPadding),
                    child: Text(
                      spotifyData.caption,
                      style: Theme.of(context).textTheme.caption,
                    ),
                  )
                ],
              ),
            ),
          ),
          // const Spacer(),
          Icon(
            Icons.more_horiz,
          )
        ],
      ),
    );
  }
}
