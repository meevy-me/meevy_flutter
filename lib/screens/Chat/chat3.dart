import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:soul_date/components/icon_container.dart';
import 'package:soul_date/components/image_circle.dart';
import 'package:soul_date/constants/constants.dart';
import 'package:soul_date/models/Spotify/base_model.dart';
import 'package:soul_date/screens/Chat/components/chat_appbar.dart';
import 'package:soul_date/screens/Chat/components/chat_messages_list.dart';
import 'package:soul_date/screens/Chat/components/chat_textarea.dart';
import 'package:soul_date/services/formatting.dart';
import 'package:soul_date/services/spotify_utils.dart';
import 'package:text_scroll/text_scroll.dart';

import '../../models/models.dart';

class ChatMessagesPage extends StatefulWidget {
  const ChatMessagesPage({Key? key, required this.friend}) : super(key: key);
  final Friends friend;
  @override
  State<ChatMessagesPage> createState() => _ChatMessagesPageState();
}

class _ChatMessagesPageState extends State<ChatMessagesPage> {
  final TextEditingController textEditingController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  double _bottomHeight = 75;

  late String _playlistID;

  @override
  void initState() {
    _playlistID = getPlaylistID(
        widget.friend.friendsProfile, widget.friend.currentProfile);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double _keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      body: SizedBox(
        height: size.height,
        child: Stack(
          children: [
            Container(
                margin: const EdgeInsets.symmetric(horizontal: defaultPadding),
                height: size.height - _bottomHeight - _keyboardHeight,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                child: SafeArea(
                  child: Column(
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.symmetric(vertical: defaultMargin),
                        child: ChatAppBar(
                            friendsProfile: widget.friend.friendsProfile),
                      ),
                      TrackSummary(
                          friends: widget.friend, playlistID: _playlistID),
                      ChatMessagesList(
                          friend: widget.friend,
                          height: size.height * 0.9 -
                              80 -
                              _bottomHeight -
                              _keyboardHeight)
                    ],
                  ),
                )),
            Positioned(
              bottom: 0,
              child: Container(
                width: size.width,
                height: _bottomHeight,
                padding: scaffoldPadding,
                child: ChatInput(
                    textEditingController: textEditingController,
                    friend: widget.friend),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class TrackSummary extends StatelessWidget implements PreferredSizeWidget {
  const TrackSummary(
      {Key? key, required this.friends, required this.playlistID})
      : super(key: key);
  final Friends friends;
  final String playlistID;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<SpotifyData>>(
        stream: FirebaseFirestore.instance
            .collection('meevyPlaylists')
            .doc(playlistID)
            .collection('tracks')
            .orderBy('date_added', descending: true)
            .snapshots()
            .map((event) => event.docs
                .map((e) => Item.fromJson(e.data()['track']))
                .toList()),
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            return Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: defaultMargin, vertical: defaultMargin / 2),
              margin: scaffoldPadding,
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(20)),
              // color: Theme.of(context).colorScheme.primaryContainer,
              // color: Colors.red,
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RowSuper(
                      innerDistance: -10,
                      children: snapshot.data!
                          .map((e) => SoulCircleAvatar(
                                imageUrl: e.image,
                                radius: 15,
                              ))
                          .toList()),
                  Expanded(
                    child: Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: defaultMargin),
                      child: TextScroll(
                        joinList(snapshot.data!, count: 3),
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ),
                  ),
                  IconContainer(
                    onPress: () {
                      mutualPlaylistPlayAll(context, playlistID);
                    },
                    icon: const Icon(
                      CupertinoIcons.play_fill,
                      color: Colors.white,
                      size: 25,
                    ),
                    size: 35,
                    color: Theme.of(context).colorScheme.tertiary,
                  )
                ],
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        });
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(50);
}
