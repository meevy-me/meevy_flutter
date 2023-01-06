import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:soul_date/controllers/SoulController.dart';
import 'package:soul_date/models/messages.dart';
import 'package:soul_date/models/profile_model.dart';
import 'package:soul_date/models/spotify_spot_details.dart' as Spotify;
import 'package:soul_date/services/formatting.dart';
import 'package:text_scroll/text_scroll.dart';
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
                Expanded(
                  child: Padding(
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

                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: defaultMargin),
                          child: _ChatMessage(
                              friends: widget.friend, currentProfile: profile),
                        ),

                        ListeningActivity(
                            profile: profile, friends: widget.friend)
                        // _ChatMessage(
                        //   friends: widget.friend,
                        //   currentProfile: currentProfile(),
                        // ),
                      ],
                    ),
                  ),
                ),
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
                TextScroll(
                  "${item!.name} - ${item!.artists.join(", ")}",
                  style: Theme.of(context).textTheme.caption!.copyWith(
                      fontSize: 12,
                      color: spotifyGreen,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          )
        : SizedBox.shrink();
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

class _ChatMessage extends StatelessWidget {
  const _ChatMessage({
    Key? key,
    required this.friends,
    required this.currentProfile,
  }) : super(key: key);
  final Friends friends;
  final Profile currentProfile;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chats')
            .doc(friends.id.toString())
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            DocumentSnapshot data = snapshot.data as DocumentSnapshot;
            Map<String, dynamic>? json = data.data() as Map<String, dynamic>?;
            if (json != null && json.containsKey('last_message')) {
              json['last_message'].addAll({'id': "some_id_lol"});

              friends.lastMessage = Message.fromJson(json['last_message']);
            }
            if (friends.lastMessage != null) {
              var chatText = SoulChatText(text: friends.lastMessage!.content);
              return Row(
                children: [
                  !chatText.valid
                      ? Container(
                          margin: const EdgeInsets.only(right: defaultPadding),
                          height: 6,
                          width: 6,
                          decoration: BoxDecoration(
                              color: friends.lastMessage!.sender ==
                                      currentProfile.user.id
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey,
                              shape: BoxShape.circle),
                        )
                      : Padding(
                          padding: const EdgeInsets.only(right: defaultPadding),
                          child: Icon(
                            Icons.music_note,
                            size: 12,
                            color: friends.lastMessage!.sender ==
                                    currentProfile.user.id
                                ? Theme.of(context).primaryColor
                                : Colors.grey,
                          ),
                        ),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: size.width * 0.6),
                    child: Text(
                      friends.lastMessage != null
                          ? SoulChatText(text: friends.lastMessage!.content)
                                  .valid
                              ? "Sent a ${SoulChatText(text: friends.lastMessage!.content).format}"
                              : friends.lastMessage!.content
                          : "👋 Say Hello",
                      style: Theme.of(context).textTheme.caption!.copyWith(
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF2A2A2A),
                          overflow: TextOverflow.ellipsis),
                    ),
                  ),
                ],
              );
            }
          }
          return Text(
            "👋 Say Hello",
            style: Theme.of(context).textTheme.caption,
          );
        });
  }
}
