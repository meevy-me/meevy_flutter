import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:soul_date/controllers/SoulController.dart';

import 'package:web_socket_channel/web_socket_channel.dart';
import '../models/models.dart';
import '../services/network.dart';

class MessageController extends GetxController {
  RxList<Chat> chats = <Chat>[].obs;
  WebSocketChannel? connection;
  HttpClient client = HttpClient();

  SoulController controller = Get.find<SoulController>();

  String? get userID {
    return controller.profile?.user.id.toString();
  }

  Stream<List<Friends>>? fetchChats() {
    if (userID != null) {
      return FirebaseFirestore.instance
          .collection('userChats')
          .doc(userID!)
          .collection('chats')
          .snapshots()
          .map((list) => list.docs.map((e) {
                int chat_id = int.parse(e.data()['chat_id']);
                Friends friend = getFriend(chat_id);
                friend.docmentID = e.id;
                return friend;
              }).toList());
    }
    return null;
  }

  Friends getFriend(int id) {
    int index = controller.friends.indexWhere((element) => element.id == id);

    return controller.friends[index];
  }

  void sendMessage(
      {required int chatID,
      required String msg,
      Profile? receiver,
      Message? replyTo}) {
    Map<String, dynamic> to_send = {
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
        .set(to_send);
    FirebaseFirestore.instance
        .collection('chats')
        .doc(chatID.toString())
        .update({"last_message": to_send});
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
