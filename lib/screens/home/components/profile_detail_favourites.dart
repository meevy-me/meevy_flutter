import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soul_date/components/cached_image_error.dart';
import 'package:soul_date/components/image_circle.dart';
import 'package:soul_date/components/pulse.dart';
import 'package:soul_date/controllers/SoulController.dart';
import 'package:soul_date/models/SpotifySearch/spotify_favourite_item.dart';
import 'package:soul_date/services/spotify.dart';

import '../../../constants/constants.dart';
import '../../../models/models.dart';

class ProfileDetailFavourites extends StatefulWidget {
  const ProfileDetailFavourites({
    Key? key,
    required this.profile,
  }) : super(key: key);
  final Profile profile;
  @override
  State<ProfileDetailFavourites> createState() =>
      _ProfileDetailFavouritesState();
}

class _ProfileDetailFavouritesState extends State<ProfileDetailFavourites> {
  late Future<List<SpotifyFavouriteItem>> _trackFuture;
  late Future<List<SpotifyFavouriteItem>> _playlistFuture;
  final SoulController soulController = Get.find<SoulController>();

  @override
  void initState() {
    _trackFuture = soulController.getProfileFavourite(widget.profile.id);
    _playlistFuture =
        soulController.getProfileFavourite(widget.profile.id, type: 'playlist');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: scaffoldPadding,
          decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20)),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    CupertinoIcons.sparkles,
                    color: Theme.of(context).primaryColor,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: defaultPadding),
                    child: Text(
                      "Favourite Song",
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: scaffoldPadding.top / 2,
              ),
              FutureBuilder<List<SpotifyFavouriteItem>>(
                  future: _trackFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const LoadingPulse();
                    } else if (snapshot.connectionState ==
                            ConnectionState.done &&
                        snapshot.data != null &&
                        snapshot.data!.isEmpty) {
                      return Padding(
                        padding:
                            const EdgeInsets.symmetric(vertical: defaultMargin),
                        child: Center(
                          child: Text(
                            "No favourites yet",
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ),
                      );
                    } else if (snapshot.connectionState ==
                            ConnectionState.done &&
                        snapshot.data != null &&
                        snapshot.data!.isNotEmpty) {
                      return FittedBox(
                        child: _FavouriteWidget(
                          item: snapshot.data!.first,
                        ),
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  }),
            ],
          ),
        ),
      ],
    );
  }
}

class _FavouriteWidget extends StatelessWidget {
  const _FavouriteWidget({
    Key? key,
    this.likeable = true,
    required this.item,
  }) : super(key: key);

  final bool likeable;
  final SpotifyFavouriteItem item;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Spotify().openSpotify(item.uri, item.href),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SoulCircleAvatar(
            imageUrl: item.imageUrl,
            radius: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: defaultMargin),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      item.title,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    Container(
                      height: 5,
                      width: 5,
                      margin:
                          const EdgeInsets.symmetric(horizontal: defaultMargin),
                      decoration: BoxDecoration(
                          color: Colors.black, shape: BoxShape.circle),
                    ),
                    Text(
                      item.subTitle,
                      style: Theme.of(context).textTheme.bodyText1,
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
