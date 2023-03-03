import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soul_date/components/chat_item.dart';
import 'package:soul_date/components/pulse.dart';
import 'package:soul_date/models/models.dart';

import '../../../constants/constants.dart';
import '../../../controllers/MessagesController.dart';

class MessagesSection extends StatelessWidget {
  MessagesSection({Key? key, required this.onRefresh, required this.profileID})
      : super(key: key);
  final Function onRefresh;
  final MessageController messageController = Get.find<MessageController>();
  final int profileID;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    const Radius radius = Radius.circular(30);
    return RefreshIndicator(
      onRefresh: () => Future.delayed(const Duration(seconds: 1), () {
        onRefresh();
      }),
      child: Container(
          padding: const EdgeInsets.fromLTRB(
              defaultMargin, defaultMargin, defaultMargin, 0),
          decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: const BorderRadius.vertical(top: radius)),
          child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .where("members", arrayContains: profileID)
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                return snapshot.data != null
                    ? ListView.separated(
                        separatorBuilder: (context, index) {
                          return const Divider();
                        },
                        shrinkWrap: true,
                        itemCount: snapshot.data!.size,
                        itemBuilder: ((context, index) {
                          var doc = snapshot.data!.docs[index];
                          Map<String, dynamic> data =
                              doc.data() as Map<String, dynamic>;
                          return FutureBuilder<Friends>(
                              future: messageController
                                  .getFriend(int.parse(doc.id)),
                              builder: (context, friendSnapshot) {
                                if (friendSnapshot.connectionState ==
                                        ConnectionState.done &&
                                    friendSnapshot.data != null) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: defaultPadding),
                                    child: ChatItem(
                                        friend: friendSnapshot.data!,
                                        lastMessage:
                                            data.containsKey('last_message')
                                                ? Message.fromJson(
                                                    data['last_message'])
                                                : null,
                                        size: size),
                                  );
                                }
                                return LoadingPulse(
                                  color: Theme.of(context).primaryColor,
                                );
                              });
                        }))
                    : const LoadingPulse();
              })),
    );
  }
}
