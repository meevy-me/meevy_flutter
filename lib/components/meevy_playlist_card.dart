import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:soul_date/animations/animations.dart';
import 'package:soul_date/controllers/SoulController.dart';
import 'package:soul_date/models/Spotify/base_model.dart';
import 'package:soul_date/models/images.dart';
import 'package:soul_date/models/meevy_playlists.dart';
import 'package:soul_date/screens/Playlists/models/meevy_playlist_detail.dart';
import 'package:soul_date/screens/Playlists/playlists_detail.dart';
import 'package:soul_date/services/navigation.dart';
import 'package:soul_date/services/network_utils.dart';
import 'package:soul_date/models/spotify_spot_details.dart';
import 'package:soul_date/services/spotify_utils.dart';
import '../constants/constants.dart';
import '../models/profile_model.dart';
import 'image_circle.dart';

class MeevyPlaylistCard extends StatefulWidget {
  const MeevyPlaylistCard({
    Key? key,
    required this.meevyPlaylist,
  }) : super(key: key);

  final MeevyPlaylist meevyPlaylist;

  @override
  State<MeevyPlaylistCard> createState() => _MeevyPlaylistCardState();
}

class _MeevyPlaylistCardState extends State<MeevyPlaylistCard> {
  final SoulController soulController = Get.find<SoulController>();
  Future<List<SpotifyData>> getTracks() async {
    var collection = await FirebaseFirestore.instance
        .collection('meevyPlaylists')
        .doc(widget.meevyPlaylist.id)
        .collection('tracks')
        .orderBy('date_added', descending: true)
        .get();
    return collection.docs.map((e) {
      var item = Item.fromJson(e.data()['track']);
      return item;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        Profile? profile = await soulController
            .getOtherProfile(await widget.meevyPlaylist.friendID);
        if (profile != null) {
          Navigation.push(context,
              customPageTransition: PageTransition(
                  child: PlaylistDetailPage(
                      onPlay: () => mutualPlaylistPlayAll(
                          context, widget.meevyPlaylist.id),
                      tracksFn: getTracks,
                      meevyBasePlaylist: MeevyBasePlaylist(
                          name: widget.meevyPlaylist.name,
                          description: widget.meevyPlaylist.description,
                          contributors: [
                            profile,
                            soulController.profile!,
                          ])),
                  type: PageTransitionType.fromBottom));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("An error has occured")));
        }
      },
      child: Column(
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
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle),
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
                    color: Colors.white.withOpacity(0.1),
                    shape: BoxShape.circle),
              ),
              Positioned(
                left: defaultMargin * 2,
                top: defaultMargin * 2,
                child: FutureBuilder<ProfileImages>(
                    future: getProfileImages(widget.meevyPlaylist.profile1),
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
                    future: getProfileImages(widget.meevyPlaylist.profile2),
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
                widget.meevyPlaylist.name,
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
          )
        ],
      ),
    );
  }
}
