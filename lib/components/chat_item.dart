import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:soul_date/controllers/SoulController.dart';
import 'package:soul_date/models/chat_model.dart';
import 'package:soul_date/models/profile_model.dart';

import '../constants/constants.dart';
import 'image_circle.dart';

class ChatItem extends StatefulWidget {
  const ChatItem({
    Key? key,
    required this.message,
    required this.size,
  }) : super(key: key);

  final Chat message;
  final Size size;

  @override
  State<ChatItem> createState() => _ChatItemState();
}

class _ChatItemState extends State<ChatItem> {
  final SoulController controller = Get.find<SoulController>();

  Profile currentProfile() {
    if (controller.profile!.id ==
        widget.message.friends.target!.profile1.target!.id) {
      return widget.message.friends.target!.profile2.target!;
    } else {
      return widget.message.friends.target!.profile1.target!;
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
                  imageUrl: profile.images.first.image,
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
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: defaultMargin / 2),
                        child: SizedBox(
                            width: widget.size.width * 0.6,
                            child: Text(
                              widget.message.messages.isEmpty
                                  ? "Say Hi"
                                  : widget.message.messages.last.formatContent,
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
                if (widget.message.messages.isNotEmpty)
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: defaultMargin / 2),
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
                          padding: const EdgeInsets.symmetric(
                              vertical: defaultMargin / 2),
                          child: Text(
                            DateFormat(DateFormat.HOUR_MINUTE).format(
                                widget.message.messages.last.datePosted),
                            style: Theme.of(context).textTheme.caption,
                          ),
                        )
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
