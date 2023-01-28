import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:soul_date/models/spotify_spot_details.dart';

import '../../../constants/constants.dart';
import '../../../services/spotify.dart';

class SongWithImage extends StatelessWidget {
  const SongWithImage({
    Key? key,
    required this.item,
    this.caption,
  }) : super(key: key);

  final Item item;
  final String? caption;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: CachedNetworkImage(
              imageUrl: item.album.images[0].url,
              height: size.height * 0.4,
              width: size.height * 0.4,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: defaultMargin * 2),
          child: _SongDetails(
            item: item,
          ),
        ),
        caption != null
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: defaultMargin),
                  child: Column(
                    children: [
                      Container(
                        height: 5,
                        margin: const EdgeInsets.only(bottom: defaultPadding),
                        width: 30,
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      Text(
                        caption!,
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            color: Colors.white, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              )
            : const SizedBox.shrink()
      ],
    );
  }
}

class _SongDetails extends StatelessWidget {
  const _SongDetails({
    Key? key,
    required this.item,
  }) : super(key: key);

  final Item item;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onDoubleTap: () => Spotify().openSpotify(item.uri, item.href),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: defaultMargin),
        child: Row(
          children: [
            const Icon(
              FontAwesomeIcons.spotify,
              color: spotifyGreen,
            ),
            const SizedBox(
              width: defaultMargin,
            ),
            Container(
              width: 5,
              height: 100,
              decoration: BoxDecoration(
                  color: spotifyGreen, borderRadius: BorderRadius.circular(20)),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: defaultMargin),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: Theme.of(context)
                          .textTheme
                          .headline6!
                          .copyWith(color: Colors.white),
                    ),
                    const SizedBox(
                      height: defaultMargin / 2,
                    ),
                    Text(
                      item.artists.join(", "),
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(color: Colors.white),
                    ),
                    const SizedBox(
                      height: defaultMargin,
                    ),
                    Text(
                      item.album.name,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(color: Colors.white),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
