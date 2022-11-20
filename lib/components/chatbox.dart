import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:soul_date/components/chatbox_spotify.dart';
import 'package:soul_date/constants/constants.dart';
import 'package:soul_date/controllers/SoulController.dart';
import 'package:soul_date/models/Spotify/base_model.dart';
import 'package:soul_date/models/models.dart';
import 'package:swipe_to/swipe_to.dart';

class ChatBox extends StatefulWidget {
  const ChatBox({
    Key? key,
    required this.message,
    required this.onSwipe,
    required this.width,
    this.height,
    required this.profile,
  }) : super(key: key);

  final double width;
  final double? height;
  final Message message;
  final Function(Message message)? onSwipe;
  final Profile profile;

  @override
  State<ChatBox> createState() => _ChatBoxState();
}

class _ChatBoxState extends State<ChatBox> with AutomaticKeepAliveClientMixin {
  bool isText = true;
  bool mine = false;
  final SoulController soulController = Get.find<SoulController>();
  SpotifyData? spotifyData;
  @override
  void initState() {
    if (widget.message.sender != widget.profile.id) {
      mine = true;
    }
    matchText();

    super.initState();
  }

  matchText() async {
    if (widget.message.content.contains("https://open.spotify.com/")) {
      var text =
          widget.message.content.replaceAll("https://open.spotify.com/", "");
      var keys = text.split("/");
      var field = keys[0];

      var fieldId = keys[1];
      if (fieldId.contains("?")) {
        fieldId = fieldId.split("?")[0];
      }
      SpotifyData? data = await soulController.spotify.getItem(field, fieldId);
      setState(() {
        spotifyData = data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Radius r = const Radius.circular(10);
    return GestureDetector(
      onLongPress: () =>
          widget.onSwipe != null ? widget.onSwipe!(widget.message) : null,
      child: SwipeTo(
        onRightSwipe: widget.onSwipe != null
            ? () {
                widget.onSwipe!(widget.message);
              }
            : null,
        iconOnRightSwipe: CupertinoIcons.reply_thick_solid,
        iconSize: 20,
        child: Column(
          crossAxisAlignment:
              mine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            spotifyData == null
                ? Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: defaultMargin * 2,
                        vertical: defaultMargin + defaultPadding),
                    width: widget.width,
                    height: widget.height,
                    decoration: BoxDecoration(
                        color: mine
                            ? Theme.of(context).primaryColor
                            : Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: r,
                            topRight: r,
                            bottomLeft: mine ? r : r / 4,
                            bottomRight: mine ? r / 4 : r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.02),
                            offset: const Offset(6.0, 6.0),
                            blurRadius: 16.0,
                          ),
                        ]),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (widget.message.replyTo != null)
                          FutureBuilder<Message?>(
                              future: widget.message.repliedMessage(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData && snapshot.data != null) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: defaultPadding),
                                    child: ReplyChatBox(
                                        message: snapshot.data!,
                                        height: 50,
                                        profile: widget.profile,
                                        onClose: null),
                                  );
                                } else {
                                  return const SizedBox.shrink();
                                }
                              }),
                        Text(
                          widget.message.content,
                          textAlign: TextAlign.left,
                          style:
                              Theme.of(context).textTheme.bodyText1!.copyWith(
                                    color: mine ? Colors.white : null,
                                  ),
                        ),
                      ],
                    ),
                  )
                : ChatSpotify(
                    widget: widget,
                    spotifyData: spotifyData,
                    key: ValueKey(widget.message),
                  ),
            if (widget.onSwipe != null)
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: defaultMargin, horizontal: defaultMargin),
                child: Text(
                  DateFormat.jm().format(widget.message.datePosted),
                  style: Theme.of(context).textTheme.caption,
                ),
              )
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class ReplyChatBox extends StatelessWidget {
  ReplyChatBox(
      {Key? key,
      required this.message,
      this.width,
      this.height,
      required this.profile,
      required this.onClose})
      : super(key: key);
  final Message message;
  final double? width;
  final double? height;
  final Profile profile;
  final Function? onClose;
  SoulController controller = Get.find<SoulController>();
  @override
  Widget build(BuildContext context) {
    var replyto =
        message.sender == controller.profile!.id ? "Me" : profile.name;
    return Container(
      width: width,
      constraints: BoxConstraints(maxHeight: height!),
      padding:
          const EdgeInsets.symmetric(vertical: 2, horizontal: defaultMargin),
      decoration: BoxDecoration(
          color: Colors.white70.withOpacity(0.7),
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 15,
                width: 5,
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.circular(20)),
              ),
              const SizedBox(
                width: defaultMargin,
              ),
              Text(
                replyto,
                style: Theme.of(context).textTheme.caption,
              ),
              const Spacer(),
              if (onClose != null)
                IconButton(
                    onPressed: () {
                      if (onClose != null) {
                        onClose!();
                      }
                    },
                    icon: const Icon(
                      Icons.close,
                      size: 20,
                      color: Colors.grey,
                    ))
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Text(
              message.content,
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(overflow: TextOverflow.ellipsis),
            ),
          ),
        ],
      ),
    );
  }
}
