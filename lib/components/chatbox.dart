import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soul_date/components/chatbox_spotify.dart';
import 'package:soul_date/constants/constants.dart';
import 'package:soul_date/controllers/SoulController.dart';
import 'package:soul_date/models/Spotify/base_model.dart';

class ChatBox extends StatefulWidget {
  const ChatBox({
    Key? key,
    required this.size,
    required this.mine,
    required this.text,
    required this.time,
  }) : super(key: key);

  final Size size;
  final bool mine;
  final String text;
  final String time;

  @override
  State<ChatBox> createState() => _ChatBoxState();
}

class _ChatBoxState extends State<ChatBox> with AutomaticKeepAliveClientMixin {
  bool isText = true;
  final SoulController soulController = Get.find<SoulController>();
  SpotifyData? spotifyData;
  @override
  void initState() {
    matchText();
    super.initState();
  }

  matchText() async {
    if (widget.text.contains("https://open.spotify.com/")) {
      var text = widget.text.replaceAll("https://open.spotify.com/", "");
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
    return SizedBox(
      width: widget.size.width * 0.7,
      child: Column(
        crossAxisAlignment:
            widget.mine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          spotifyData == null
              ? Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: defaultMargin * 2,
                      vertical: defaultMargin * 2),
                  width: widget.size.width * 0.5,
                  decoration: BoxDecoration(
                      color: widget.mine
                          ? Theme.of(context).primaryColor
                          : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.02),
                          offset: const Offset(6.0, 6.0),
                          blurRadius: 16.0,
                        ),
                      ]),
                  child: Text(
                    widget.text,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(color: widget.mine ? Colors.white : null),
                  ),
                )
              : ChatSpotify(
                  widget: widget,
                  spotifyData: spotifyData,
                  key: ValueKey(widget.text),
                ),
          Padding(
            padding: const EdgeInsets.symmetric(
                vertical: defaultMargin, horizontal: defaultMargin),
            child: Text(
              widget.time,
              style: Theme.of(context).textTheme.caption,
            ),
          )
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
