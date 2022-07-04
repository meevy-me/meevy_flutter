import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:soul_date/models/chat_model.dart';

import '../constants/constants.dart';
import 'image_circle.dart';

class ChatItem extends StatelessWidget {
  const ChatItem({
    Key? key,
    required this.message,
    required this.size,
  }) : super(key: key);

  final Chat message;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SoulCircleAvatar(
          imageUrl: message.friends.profile2.images[0]['image'],
          radius: 25,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: defaultMargin),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message.friends.profile2.name,
                style: Theme.of(context).textTheme.bodyText1,
              ),
              Padding(
                padding: const EdgeInsets.only(top: defaultMargin / 2),
                child: SizedBox(
                    width: size.width * 0.6,
                    child: Text(
                      message.messages.isEmpty
                          ? "Say Hi"
                          : message.messages.last.formatContent,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2!
                          .copyWith(fontSize: 12),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )),
              )
            ],
          ),
        ),
        const Spacer(),
        if (message.messages.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultMargin / 2),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Container(
                //   height: 6,
                //   width: 6,
                //   decoration: BoxDecoration(
                //       color: Theme.of(context).primaryColor,
                //       shape: BoxShape.circle),
                // ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: defaultMargin / 2),
                  child: Text(
                    DateFormat(DateFormat.HOUR_MINUTE)
                        .format(message.messages.last.datePosted),
                    style: Theme.of(context).textTheme.caption,
                  ),
                )
              ],
            ),
          )
      ],
    );
  }
}
