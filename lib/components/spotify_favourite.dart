import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:soul_date/constants/constants.dart';
import 'package:soul_date/models/SpotifySearch/spotify_search.dart';

class SpotifyFavouriteWidget extends StatelessWidget {
  const SpotifyFavouriteWidget({Key? key, this.item, required this.onRemove})
      : super(key: key);
  final Item? item;
  final Function(Item item) onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      constraints: const BoxConstraints(minWidth: 300),
      child: item == null
          ? DottedBorder(
              child: const Center(child: Icon(Icons.add)),
              borderType: BorderType.RRect,
              radius: const Radius.circular(20),
              dashPattern: const [6, 8],
              strokeCap: StrokeCap.round,
            )
          : Column(
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        imageUrl: item!.album.images.first.url,
                        width: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(
                      width: defaultMargin,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FittedBox(
                            fit: BoxFit.contain,
                            child: Text(item!.name,
                                style: Theme.of(context).textTheme.bodyText1),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: defaultPadding),
                            child: Text(
                              item!.artists.join(", "),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Text(
                            item!.album.name,
                            style: Theme.of(context).textTheme.caption,
                          )
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: defaultPadding,
                ),
                InkWell(
                  onTap: () {
                    onRemove(item!);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.close,
                        color: Colors.red,
                      ),
                      const SizedBox(
                        width: defaultMargin,
                      ),
                      Text(
                        "Remove ${item!.name}",
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(
                            color: Colors.red,
                            overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                )
              ],
            ),
    );
  }
}
