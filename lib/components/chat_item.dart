import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:soul_date/controllers/SoulController.dart';
import 'package:soul_date/models/chat_model.dart';
import 'package:soul_date/models/profile_model.dart';

import '../constants/constants.dart';
import 'image_circle.dart';

class ChatItem extends StatelessWidget {
  ChatItem({
    Key? key,
    required this.message,
    required this.size,
  }) : super(key: key);

  final Chat message;
  final Size size;
  final SoulController controller = Get.find<SoulController>();

  Profile currentProfile() {
    if (controller.profile.first.id == message.friends.profile1.id) {
      return message.friends.profile2;
    } else {
      return message.friends.profile1;
    }
  }

  @override
  Widget build(BuildContext context) {
    Profile profile = currentProfile();
    return Row(
      children: [
        SoulCircleAvatar(
          imageUrl: profile.images[0]['image'],
          radius: 25,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: defaultMargin),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                profile.name,
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
