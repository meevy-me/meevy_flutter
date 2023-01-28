import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:soul_date/components/image_circle.dart';
import 'package:text_scroll/text_scroll.dart';

import '../../constants/constants.dart';
import '../../models/models.dart';

class ListeningActivity extends StatefulWidget {
  const ListeningActivity({
    Key? key,
    required this.profile,
    required this.friends,
  }) : super(key: key);

  final Profile profile;
  final Friends friends;

  @override
  State<ListeningActivity> createState() => _ListeningActivityState();
}

class _ListeningActivityState extends State<ListeningActivity>
    with AutomaticKeepAliveClientMixin<ListeningActivity> {
  Item? item;
  @override
  void initState() {
    FirebaseDatabase.instance
        .ref()
        .child('currentlyPlaying')
        .child(widget.profile.user.id.toString())
        .onValue
        .listen((event) {
      final data =
          jsonDecode(jsonEncode(event.snapshot.value)) as Map<String, dynamic>?;
      if (data != null) {
        if (mounted) {
          setState(() {
            item = Item.fromJson(data);
          });
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return item != null
        ? Padding(
            padding: const EdgeInsets.only(top: defaultMargin / 2),
            child: Row(
              children: [
                const Icon(
                  FontAwesomeIcons.spotify,
                  color: spotifyGreen,
                  size: 15,
                ),
                const SizedBox(
                  width: defaultPadding,
                ),
                SoulCircleAvatar(
                  imageUrl: item!.album.images.first.url,
                  radius: 10,
                ),
                const SizedBox(
                  width: defaultPadding,
                ),
                Expanded(
                  child: TextScroll(
                    "${item!.name} - ${item!.artists.join(", ")}",
                    style: Theme.of(context).textTheme.caption!.copyWith(
                        fontSize: 12,
                        color: spotifyGreen,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          )
        : const SizedBox.shrink();
    // : Row(
    //     children: [
    //       const Icon(
    //         FontAwesomeIcons.spotify,
    //         color: Colors.grey,
    //         size: 15,
    //       ),
    //       const SizedBox(
    //         width: defaultPadding,
    //       ),
    //       Text(
    //         "No current listening activity",
    //         style: Theme.of(context).textTheme.caption,
    //       )
    //     ],
    //   );
  }

  @override
  bool get wantKeepAlive => true;
}
