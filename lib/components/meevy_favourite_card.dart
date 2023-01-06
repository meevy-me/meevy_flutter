import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:soul_date/components/image_circle.dart';

import '../constants/constants.dart';
import '../models/spotify_spot_details.dart';
import 'icon_container.dart';

class MeevyFavouriteCard extends StatelessWidget {
  const MeevyFavouriteCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: scaffoldPadding,
      height: 100,
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(20)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: CachedNetworkImage(
                imageUrl: defaultArtistUrl,
                fit: BoxFit.cover,
                width: 80,
                height: 80,
              )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: defaultMargin),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Meevy Favourites",
                  style: Theme.of(context)
                      .textTheme
                      .headline6!
                      .copyWith(color: Colors.white),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: defaultPadding),
                  child: FutureBuilder<QuerySnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('likedPlaylist')
                          .doc('1')
                          .collection('tracks')
                          // .orderBy('date_added')
                          .get(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          List<Item> items = snapshot.data!.docs
                              .map((e) => Item.fromJson(e.get('track')))
                              .toList();
                          // print(data);
                          // List<Item> items = data.map((key, value) => Item.fromJson(json))
                          return Row(
                            children: [
                              RowSuper(
                                innerDistance: -10,
                                children: [
                                  for (Item item in items.take(4))
                                    SoulCircleAvatar(
                                      imageUrl: item.album.images.first.url,
                                      radius: 12,
                                    )
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: defaultPadding),
                                child: Text(
                                  "Contains ${items.length} tracks",
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .caption!
                                      .copyWith(color: Colors.grey),
                                ),
                              )
                            ],
                          );
                        }

                        return SpinKitPulse(
                          color: Colors.grey,
                          size: 15,
                        );
                      }),
                )
              ],
            ),
          ),
          const Spacer(),
          IconContainer(
            icon: Icon(
              CupertinoIcons.play_fill,
              color: Colors.white,
              size: 30,
            ),
            color: Theme.of(context).primaryColor,
            size: 40,
          )
        ],
      ),
    );
  }
}
