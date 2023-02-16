import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:soul_date/components/cached_image_error.dart';
import 'package:soul_date/components/icon_container.dart';
import 'package:soul_date/components/pulse.dart';
import 'package:soul_date/components/spotify_favourite.dart';
import 'package:soul_date/constants/constants.dart';
import 'package:soul_date/controllers/SoulController.dart';
import 'package:soul_date/models/SpotifySearch/spotify_favourite_item.dart';
import 'package:soul_date/models/models.dart';
import 'package:soul_date/services/spotify.dart';

class ProfileFavouritesModal extends StatefulWidget {
  const ProfileFavouritesModal({Key? key, required this.profile})
      : super(key: key);
  final Profile profile;

  @override
  State<ProfileFavouritesModal> createState() => _ProfileFavouritesModalState();
}

class _ProfileFavouritesModalState extends State<ProfileFavouritesModal> {
  final SoulController soulController = Get.find<SoulController>();
  late Future<List<SpotifyFavouriteItem>> _trackFuture;
  late Future<List<SpotifyFavouriteItem>> _playlistFuture;

  @override
  void initState() {
    _trackFuture = soulController.getProfileFavourite(widget.profile.id);
    _playlistFuture =
        soulController.getProfileFavourite(widget.profile.id, type: 'playlist');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.5,
      padding: scaffoldPadding * 2,
      decoration:
          BoxDecoration(color: Theme.of(context).colorScheme.primaryContainer),
      child: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Favourite Song",
                style: Theme.of(context)
                    .textTheme
                    .headline6!
                    .copyWith(color: Colors.white),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: defaultMargin),
                child: FutureBuilder<List<SpotifyFavouriteItem>>(
                    future: _trackFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const LoadingPulse();
                      } else if (snapshot.connectionState ==
                              ConnectionState.done &&
                          snapshot.data != null &&
                          snapshot.data!.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: defaultMargin),
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
                        return _FavouriteWidget(
                          item: snapshot.data!.first,
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    }),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultMargin),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Favourite Playlists",
                  style: Theme.of(context)
                      .textTheme
                      .headline6!
                      .copyWith(color: Colors.white),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: defaultMargin),
                  child: FutureBuilder<List<SpotifyFavouriteItem>>(
                      future: _playlistFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done &&
                            snapshot.data != null &&
                            snapshot.data!.isNotEmpty) {
                          return ListView.separated(
                            primary: false,
                            separatorBuilder: (context, index) {
                              return const SizedBox(
                                height: defaultMargin,
                              );
                            },
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return _FavouriteWidget(
                                likeable: false,
                                item: snapshot.data![index],
                              );
                            },
                            itemCount: snapshot.data!.length,
                          );
                        } else if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const LoadingPulse();
                        } else if (snapshot.connectionState ==
                                ConnectionState.done &&
                            snapshot.data != null &&
                            snapshot.data!.isEmpty) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: defaultMargin),
                            child: Center(
                              child: Text(
                                "No favourites yet",
                                style: Theme.of(context).textTheme.caption,
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      }),
                )
              ],
            ),
          )
        ],
      ),
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
        children: [
          SoulCachedNetworkImage(
            imageUrl: item.imageUrl,
            height: 70,
            width: 70,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultMargin),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(color: Colors.white),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: defaultPadding),
                    child: Text(
                      item.subTitle,
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          color: Colors.grey, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Text(
                    item.caption,
                    style: Theme.of(context).textTheme.caption,
                  )
                ],
              ),
            ),
          ),
          const SizedBox(
            width: defaultMargin,
          ),
          // likeable
          //     ? IconContainer(
          //         icon: const Icon(
          //           CupertinoIcons.heart_fill,
          //           color: Colors.white,
          //         ),
          //         size: 35,
          //         color: Theme.of(context).primaryColor,
          //       )
          //     : IconContainer(
          //         icon: const Icon(
          //           FontAwesomeIcons.spotify,
          //           color: Colors.white,
          //         ),
          //         size: 35,
          //         color: spotifyGreen,
          //       )
        ],
      ),
    );
  }
}
