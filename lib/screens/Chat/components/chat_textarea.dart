import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:soul_date/components/buttons.dart';
import 'package:soul_date/components/image_circle.dart';
import 'package:soul_date/models/Spotify/base_model.dart';
import 'package:soul_date/screens/Chat/components/reply_to.dart';
import 'package:soul_date/services/messaging_utils.dart';

import '../../../constants/constants.dart';
import '../../../models/models.dart';

class ChatInput extends StatefulWidget {
  const ChatInput({
    Key? key,
    required this.textEditingController,
    required this.friend,
    this.onSuffixTap,
    this.replyTo,
    this.spotifyData,
    this.onReplyDismiss,
    this.onTrackDismiss,
    this.noTextField = false,
  }) : super(key: key);

  final TextEditingController textEditingController;
  final Friends friend;
  final void Function()? onSuffixTap;
  final void Function()? onReplyDismiss;
  final void Function()? onTrackDismiss;

  final Message? replyTo;
  final SpotifyData? spotifyData;
  final bool noTextField;

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  bool enabled = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.replyTo != null)
          ReplyTo(
            message: widget.replyTo!,
            onDismiss: widget.onReplyDismiss,
          ),
        Row(
          children: [
            Expanded(
              child: widget.noTextField || widget.spotifyData == null
                  ? TextFormField(
                      controller: widget.textEditingController,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2!
                          .copyWith(color: Colors.white),
                      onChanged: (value) {
                        setState(() {
                          enabled = value.isNotEmpty;
                        });
                      },
                      // textAlign: TextAlign.center,
                      decoration: InputDecoration(
                          filled: true,
                          hintText: "Type here ...",
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 0, horizontal: defaultMargin),
                          suffixIcon: GestureDetector(
                            onTap: widget.onSuffixTap,
                            child: const Icon(
                              CupertinoIcons.headphones,
                              color: Colors.white,
                            ),
                          ),
                          hintStyle: Theme.of(context).textTheme.caption,
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(
                                  color: Colors.white, width: 1.7)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)),
                          fillColor: Colors.grey.withOpacity(0.5)),
                    )
                  : Row(children: [
                      SoulCircleAvatar(
                        imageUrl: widget.spotifyData!.image,
                        radius: 17,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: defaultPadding),
                        child: Row(
                          children: [
                            Text(
                              widget.spotifyData!.itemName,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(color: Colors.white),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Container(
                              width: 5,
                              height: 5,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: defaultPadding),
                              decoration: const BoxDecoration(
                                  color: Colors.grey, shape: BoxShape.circle),
                            ),
                            Text(
                              widget.spotifyData!.caption,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2!
                                  .copyWith(color: Colors.white),
                            )
                          ],
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                          onTap: widget.onTrackDismiss,
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 25,
                          ))
                    ]),
            ),
            Padding(
              padding: const EdgeInsets.only(left: defaultMargin),
              child: InkWell(
                onTap: () {
                  if (widget.spotifyData != null || enabled) {
                    final text = widget.textEditingController.text;
                    sendMessage(
                        friends: widget.friend,
                        msg: widget.spotifyData != null
                            ? widget.spotifyData!.url
                            : text,
                        spotifyData: widget.spotifyData,
                        replyTo: widget.replyTo);
                    widget.textEditingController.clear();
                    if (widget.onTrackDismiss != null) {
                      widget.onTrackDismiss!();
                    }
                    if (widget.onReplyDismiss != null) {
                      widget.onReplyDismiss!();
                    }
                    setState(() {
                      enabled = false;
                    });
                  }
                },
                child: PrimarySendButton(
                  enabled: enabled || widget.spotifyData != null,
                  onTap: () {
                    if (widget.spotifyData != null || enabled) {
                      final text = widget.textEditingController.text;
                      sendMessage(
                          friends: widget.friend,
                          msg: widget.spotifyData != null
                              ? widget.spotifyData!.url
                              : text,
                          spotifyData: widget.spotifyData,
                          replyTo: widget.replyTo);
                      widget.textEditingController.clear();
                      if (widget.onTrackDismiss != null) {
                        widget.onTrackDismiss!();
                      }
                      if (widget.onReplyDismiss != null) {
                        widget.onReplyDismiss!();
                      }
                      setState(() {
                        enabled = false;
                      });
                    }
                  },
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}
