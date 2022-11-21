import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:soul_date/controllers/SoulController.dart';
import 'package:soul_date/models/profile_model.dart';
import 'package:soul_date/models/spotify_spot_details.dart' as Spotify;
import '../constants/constants.dart';
import '../models/friend_model.dart';
import 'image_circle.dart';

class ChatItem extends StatefulWidget {
  const ChatItem({
    Key? key,
    required this.friend,
    required this.size,
  }) : super(key: key);

  final Friends friend;
  final Size size;

  @override
  State<ChatItem> createState() => _ChatItemState();
}

class _ChatItemState extends State<ChatItem> {
  final SoulController controller = Get.find<SoulController>();

  Profile currentProfile() {
    if (controller.profile!.id == widget.friend.profile1.id) {
      return widget.friend.profile2;
    } else {
      return widget.friend.profile1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SoulController>(
        id: 'profile',
        builder: (controller) {
          if (controller.profile != null) {
            Profile profile = currentProfile();

            return Row(
              children: [
                SoulCircleAvatar(
                  imageUrl: profile.images.last.image,
                  radius: 25,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: defaultMargin),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        profile.name,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      ListeningActivity(
                        profile: currentProfile(),
                        friends: widget.friend,
                      )
                    ],
                  ),
                ),
                const Spacer(),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: defaultMargin / 2),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: const [
                      // Container(
                      //   height: 6,
                      //   width: 6,
                      //   decoration: BoxDecoration(
                      //       color: Theme.of(context).primaryColor,
                      //       shape: BoxShape.circle),
                      // ),
                      // Padding(
                      //     padding: const EdgeInsets.symmetric(
                      //         vertical: defaultMargin / 2),
                      //     child: IconContainer(
                      //       icon: Icon(
                      //         Cu,
                      //         size: 20,
                      //         color: Theme.of(context).primaryColor,
                      //       ),
                      //     ))
                    ],
                  ),
                )
              ],
            );
          } else {
            return SpinKitRing(
              color: Theme.of(context).primaryColor,
              lineWidth: 2,
              size: 20,
            );
          }
        });
  }
}

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
  Spotify.Item? item;
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
            item = Spotify.Item.fromJson(data);
          });
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return item != null
        ? Padding(
            padding: const EdgeInsets.only(top: defaultMargin / 2),
            child: Row(
              children: [
                SoulCircleAvatar(
                  imageUrl: item!.album.images.first.url,
                  radius: 10,
                ),
                const SizedBox(
                  width: defaultPadding,
                ),
                Text(
                  "${item!.name} - ${item!.artists.join(",")}",
                  style: Theme.of(context).textTheme.caption!.copyWith(
                      fontSize: 12,
                      color: spotifyGreen,
                      fontWeight: FontWeight.w500),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          )
        : Text(
            widget.friends.lastMessage != null
                ? widget.friends.lastMessage!.content
                : "${widget.profile.name} is not active",
            style: Theme.of(context).textTheme.caption,
          );
  }

  @override
  bool get wantKeepAlive => true;
}
