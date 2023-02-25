import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:soul_date/services/messaging.dart';

import '../../../constants/constants.dart';
import '../../../models/models.dart';

class ChatInput extends StatefulWidget {
  const ChatInput({
    Key? key,
    required this.textEditingController,
    required this.friend,
  }) : super(key: key);

  final TextEditingController textEditingController;
  final Friends friend;

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  bool enabled = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextFormField(
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
                    suffixIcon: const Icon(
                      FontAwesomeIcons.spotify,
                      color: Colors.grey,
                    ),
                    hintStyle: Theme.of(context).textTheme.caption,
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide:
                            const BorderSide(color: Colors.white, width: 1.7)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                    fillColor: Colors.white.withOpacity(0.1)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: defaultMargin),
              child: InkWell(
                onTap: () {
                  if (enabled) {
                    final text = widget.textEditingController.text;
                    sendMessage(friends: widget.friend, msg: text);
                    widget.textEditingController.clear();
                    setState(() {
                      enabled = false;
                    });
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: defaultMargin + defaultPadding,
                      vertical: defaultMargin),
                  decoration: BoxDecoration(
                      color: enabled
                          ? Theme.of(context).primaryColor
                          : Colors.grey,
                      borderRadius: BorderRadius.circular(20)),
                  alignment: Alignment.center,
                  child: const Icon(
                    CupertinoIcons.paperplane_fill,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}
