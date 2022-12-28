import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:soul_date/controllers/SoulController.dart';

import '../models/models.dart';

class MessageController extends GetxController {
  SoulController controller = Get.find<SoulController>();
  Map<int, Friends> friends = {};
  String? get userID {
    return controller.profile?.user.id.toString();
  }

  // Stream<List<Friends>>? fetchChats() {
  //   if (userID != null) {
  //     return FirebaseFirestore.instance
  //         .collection('userChats')
  //         .doc(userID!)
  //         .collection('chats')
  //         .snapshots()
  //         .map((list) => list.docs.map((e) {
  //               int chat_id = int.parse(e.data()['chat_id']);
  //               late Friends friend;
  //               getFriend(chat_id).then((value) => friend = value);
  //               friend.docmentID = e.id;
  //               return friend;
  //             }).toList());
  //   }
  //   return null;
  // }

  Future<Friends> getFriend(int id) async {
    if (!friends.containsKey(id)) {
      friends[id] = await controller.getFriend(id);
    }

    return friends[id]!;
  }

  void sendMessage(
      {required int chatID,
      required String msg,
      Profile? receiver,
      Message? replyTo}) {
    Map<String, dynamic> toSend = {
      "sender": userID,
      "message": msg,
      "date_sent": DateTime.now().toString(),
      "reply_to": replyTo?.toJson()
    };
    FirebaseFirestore.instance
        .collection('chatMessages')
        .doc(chatID.toString())
        .collection('messages')
        .doc()
        .set(toSend);
    FirebaseFirestore.instance
        .collection('chats')
        .doc(chatID.toString())
        .update({"last_message": toSend});
    if (receiver != null) {
      controller.sendNotification(receiver, msg);
    }
  }

  Stream<List<Message>>? fetchMessages(String id) {
    return FirebaseFirestore.instance
        .collection('chatMessages')
        .doc(id)
        .collection('messages')
        .orderBy('date_sent', descending: true)
        .snapshots()
        .map((list) => list.docs.map((e) {
              Map<String, dynamic> json = {'id': e.id};
              json.addAll(e.data());
              Message msg = Message.fromJson(json);
              return msg;
            }).toList());
  }

  updateOrder(Friends friends, int newPosition) {
    FirebaseFirestore.instance
        .collection('userChats')
        .doc(userID!)
        .collection('chats')
        .doc(friends.docmentID!)
        .update({"position": newPosition});
  }
}
