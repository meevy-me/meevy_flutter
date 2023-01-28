import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:flutter/material.dart';

import '../../../components/image_circle.dart';
import '../../../constants/constants.dart';

class MeevyPlaylistList extends StatelessWidget {
  const MeevyPlaylistList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: scaffoldPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "My Meevy Playlists",
            style: Theme.of(context).textTheme.headline5,
          ),
          const SizedBox(
            height: defaultMargin,
          ),
          SizedBox(
            height: 180,
            child: ListView.builder(
              itemCount: 4,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: defaultMargin),
                          height: 150,
                          width: 150,
                          color: Colors.red,
                        ),
                        Positioned(
                          right: defaultMargin + defaultPadding,
                          top: defaultPadding,
                          child: RowSuper(innerDistance: -10, children: const [
                            SoulCircleAvatar(
                              imageUrl: defaultArtistUrl,
                              radius: 15,
                            ),
                            SoulCircleAvatar(
                              imageUrl: defaultGirlUrl,
                              radius: 15,
                            )
                          ]),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: defaultPadding,
                    ),
                    Text(
                      "Favourites",
                      style: Theme.of(context).textTheme.bodyText1,
                    )
                  ],
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
