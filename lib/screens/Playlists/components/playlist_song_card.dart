import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:soul_date/components/cached_image_error.dart';
import 'package:soul_date/models/Spotify/base_model.dart';
import 'package:soul_date/models/profile_model.dart';
import 'package:soul_date/screens/home/models/vinyl_model.dart';
import 'package:soul_date/services/spotify_utils.dart';
import 'package:text_scroll/text_scroll.dart';

import '../../../constants/constants.dart';
import '../../../services/modal.dart';
import '../../home/components/vinyl_modal.dart';

class PlaylistDetailSongCard extends StatelessWidget {
  const PlaylistDetailSongCard({
    Key? key,
    required this.spotifyData,
    required this.sender,
  }) : super(key: key);

  final SpotifyData spotifyData;
  final Profile? sender;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => trackPlay(context, spotifyData),
      child: Container(
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
            InkWell(
              onTap: () {
                showModal(
                    context,
                    VinylModal(
                      spotifyData: spotifyData,
                      sender: sender!,
                    ));
              },
              child: Icon(Icons.more_horiz, color: Colors.grey),
            )
          ],
        ),
      ),
    );
  }
}
