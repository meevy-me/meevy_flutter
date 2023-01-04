import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soul_date/screens/home/components/vinyl_message_card.dart';
import 'package:soul_date/screens/home/models/chat_model.dart';
import 'package:soul_date/screens/home/models/vinyl_model.dart';
import 'package:soul_date/services/color_utils.dart';

import '../../../constants/constants.dart';
import '../../../controllers/SoulController.dart';

class VinylChatSection extends StatelessWidget {
  const VinylChatSection({
    required this.vinyl,
    Key? key,
    required this.backgroundColor,
  }) : super(key: key);
  final VinylModel vinyl;
  final Color backgroundColor;
  @override
  Widget build(BuildContext context) {
    double luminance = computeLuminance(backgroundColor);
    return StreamBuilder<List<VinylChat>>(
        stream: FirebaseFirestore.instance
            .collection('sentTracks')
            .doc(vinyl.id)
            .collection('messages')
            .snapshots()
            .map((event) {
          return event.docs.map((e) => VinylChat.fromJson(e.data())).toList();
        }),
        builder: (context, snapshot) {
          return snapshot.data != null
              ? ListView.builder(
                  reverse: true,
                  itemCount: snapshot.data!.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: defaultMargin, horizontal: defaultMargin),
                      child: GetBuilder<SoulController>(builder: (controller) {
                        return VinylMessageCard(
                          textColor:
                              luminance > 0.5 ? Colors.black : Colors.white,
                          color: backgroundColor,
                          vinyl: snapshot.data![index],
                          mine: controller.profile!.id == vinyl.sender.id,
                        );
                      }),
                    );
                  },
                )
              :
              //TODO: Add no messages widget
              SizedBox.shrink();
        });
  }
}
