import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:soul_date/constants/constants.dart';
import 'package:soul_date/models/SpotifySearch/spotify_favourite_item.dart';

class SpotifyFavouriteWidget extends StatelessWidget {
  const SpotifyFavouriteWidget(
      {Key? key, this.item, required this.onRemove, this.height = 120})
      : super(key: key);
  final SpotifyFavouriteItem? item;
  final Function(SpotifyFavouriteItem item) onRemove;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      constraints: const BoxConstraints(minWidth: 300),
      padding: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              ClipRRect(
                  // clipBehavior: Clip.none,
                  borderRadius: BorderRadius.circular(10),
                  child: item != null
                      ? CachedNetworkImage(
                          imageUrl: item!.imageUrl,
                          width: 55,
                          height: 55,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          height: 55,
                          width: 55,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey.withOpacity(0.5),
                              border: Border.all(color: spotifyGreen)))),
              const SizedBox(
                width: defaultMargin,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    item != null
                        ? FittedBox(
                            fit: BoxFit.contain,
                            child: Text(item!.title,
                                style: Theme.of(context).textTheme.bodyText1),
                          )
                        : Container(
                            height: 10,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.grey.withOpacity(0.5)),
                          ),
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: defaultPadding),
                      child: item != null
                          ? Text(
                              item!.subTitle,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2!
                                  .copyWith(fontWeight: FontWeight.bold),
                            )
                          : Container(
                              height: 5,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.grey.withOpacity(0.5)),
                            ),
                    ),
                    item != null
                        ? Text(
                            item!.caption,
                            style: Theme.of(context).textTheme.caption,
                          )
                        : Container(
                            height: 5,
                            width: 30,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.grey.withOpacity(0.5)),
                          ),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(
            height: defaultPadding,
          ),
        ],
      ),
    );
  }
}
