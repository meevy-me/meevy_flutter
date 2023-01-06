import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:soul_date/models/images.dart';
import 'package:soul_date/models/meevy_playlists.dart';
import 'package:soul_date/services/network_utils.dart';

import '../constants/constants.dart';
import 'image_circle.dart';

class MeevyPlaylistCard extends StatelessWidget {
  const MeevyPlaylistCard({
    Key? key,
    required this.meevyPlaylist,
  }) : super(key: key);

  final MeevyPlaylist meevyPlaylist;

  @override
  Widget build(BuildContext context) {
    return Column(
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: 130,
              width: 120,
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(20)),
            ),
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
            ),
            // Container(
            //   height: 90,
            //   width: 90,
            //   decoration: BoxDecoration(
            //       color: Colors.white.withOpacity(0.4), shape: BoxShape.circle),
            // ),
            Container(
              height: 120,
              width: 120,
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1), shape: BoxShape.circle),
            ),
            Positioned(
              left: defaultMargin * 2,
              top: defaultMargin * 2,
              child: FutureBuilder<ProfileImages>(
                  future: getProfileImages(meevyPlaylist.profile1),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done &&
                        snapshot.data != null) {
                      return SoulCircleAvatar(
                        imageUrl: snapshot.data!.image,
                        radius: 28,
                      );
                    }
                    return SpinKitPulse(
                      color: Colors.grey,
                    );
                  }),
            ),
            Positioned(
              right: defaultMargin * 2,
              bottom: defaultMargin * 2,
              child: FutureBuilder<ProfileImages>(
                  future: getProfileImages(meevyPlaylist.profile2),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done &&
                        snapshot.data != null) {
                      return SoulCircleAvatar(
                        imageUrl: snapshot.data!.image,
                        radius: 28,
                      );
                    }
                    return const SpinKitPulse(
                      color: Colors.grey,
                    );
                  }),
            )
          ],
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: Text(
              meevyPlaylist.name,
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
        )
      ],
    );
  }
}
