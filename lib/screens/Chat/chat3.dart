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
import 'package:soul_date/services/spotify.dart';
import 'package:soul_date/services/spotify_utils.dart';
import 'package:text_scroll/text_scroll.dart';

import '../../models/models.dart';
import 'components/track_summary.dart';

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

  SpotifyData? spotifyTrack;
  Message? replyTo;

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
                          repliedMessage: (message) {
                            setState(() {
                              replyTo = message;
                              _bottomHeight = 100;
                            });
                          },
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
                  replyTo: replyTo,
                  spotifyData: spotifyTrack,
                  onTrackDismiss: () {
                    setState(() {
                      spotifyTrack = null;
                      _bottomHeight = 75;
                    });
                  },
                  onReplyDismiss: () {
                    setState(() {
                      replyTo = null;
                      _bottomHeight = 75;
                    });
                  },
                  textEditingController: textEditingController,
                  friend: widget.friend,
                  onSuffixTap: () async {
                    SpotifyDetails? _currentlyPlaying =
                        await Spotify().currentlyPlaying();
                    if (_currentlyPlaying != null) {
                      setState(() {
                        spotifyTrack = _currentlyPlaying.item;
                        // _bottomHeight = 100;
                      });
                    }
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
