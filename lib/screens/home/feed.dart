import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:flutter/material.dart';
import 'package:soul_date/components/appbar_home.dart';
import 'package:soul_date/components/image_circle.dart';
import 'package:soul_date/constants/constants.dart';
import 'package:soul_date/screens/home/components/current_playing.dart';

import 'components/meevy_playlists.dart';
import 'components/received_songs.dart';

class HomeFeed extends StatefulWidget {
  const HomeFeed({Key? key}) : super(key: key);

  @override
  State<HomeFeed> createState() => _HomeFeedState();
}

class _HomeFeedState extends State<HomeFeed> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            const SliverAppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                title: HomeAppBar(),
                pinned: true,
                expandedHeight: 220,
                flexibleSpace: FlexibleSpaceBar(
                  background: CurrentlyPlaying(
                    padding: EdgeInsets.only(
                        top: defaultMargin * 6,
                        right: defaultMargin,
                        left: defaultMargin),
                  ),
                ))
          ];
        },
        body: ListView(children: [
          const ReceivedSongsList(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultMargin * 2),
            child: MeevyPlaylistList(),
          )
        ]),
      ),
    );
  }
}




// Widget _buildSentSongs(BuildContext context) {
//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       Text(
//         "Songs Received",
//         style: Theme.of(context).textTheme.headline6,
//       ),
//       SizedBox(
//         height: defaultMargin,
//       ),
//       Container(
//         height: 150,
//         padding: const EdgeInsets.symmetric(
//             horizontal: defaultMargin, vertical: defaultPadding),
//         decoration: BoxDecoration(
//             color: Colors.white,
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.1),
//                 offset: const Offset(6.0, 6.0),
//                 blurRadius: 16.0,
//               ),
//             ],
//             borderRadius: BorderRadius.circular(10)),
//         child: Column(
//           children: [
//             Row(
//               children: [
//                 SoulCircleAvatar(imageUrl: defaultGirlUrl),
//                 SizedBox(
//                   width: defaultMargin,
//                 ),
//                 Text(
//                   "Hope Celestine",
//                   style: Theme.of(context).textTheme.bodyText1,
//                 )
//               ],
//             ),
//             const Divider()
//           ],
//         ),
//       )
//     ],
//   );
// }
