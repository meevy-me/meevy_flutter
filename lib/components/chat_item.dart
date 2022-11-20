import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:soul_date/controllers/SoulController.dart';
import 'package:soul_date/models/chat_model.dart';
import 'package:soul_date/models/messages.dart';
import 'package:soul_date/models/profile_model.dart';

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

  Stream<List<Message>> getLastMessage(String id) {
    return FirebaseFirestore.instance
        .collection('chatMessages')
        .doc(id)
        .collection('messages')
        .limit(1)
        .orderBy('date_sent', descending: true)
        .get()
        .asStream()
        .map((event) => event.docs.map((e) {
              Map<String, dynamic> json = {"id": e.id};
              json.addAll(e.data());
              return Message.fromJson(json);
            }).toList());
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SoulController>(
        id: 'profile',
        builder: (controller) {
          if (controller.profile != null) {
            Profile profile = currentProfile();

            return StreamBuilder<List<Message>>(
                stream: getLastMessage(widget.friend.id.toString()),
                builder: (context, snapshot) {
                  return Row(
                    children: [
                      SoulCircleAvatar(
                        imageUrl: profile.images.last.image,
                        radius: 25,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: defaultMargin),
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
                            if (snapshot.hasData)
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: defaultMargin / 2),
                                child: SizedBox(
                                    width: widget.size.width * 0.6,
                                    child: Text(
                                      snapshot.data != null &&
                                              snapshot.data!.isEmpty
                                          ? "Say Hello"
                                          : snapshot.data!.first.content,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .copyWith(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    )),
                              )
                          ],
                        ),
                      ),
                      const Spacer(),
                      if (snapshot.hasData && snapshot.data!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: defaultMargin / 2),
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
                                  snapshot.data!.isNotEmpty
                                      ? DateFormat(DateFormat.HOUR_MINUTE)
                                          .format(
                                              snapshot.data!.first.datePosted)
                                      : "",
                                  style: Theme.of(context).textTheme.caption,
                                ),
                              )
                            ],
                          ),
                        )
                    ],
                  );
                });
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
