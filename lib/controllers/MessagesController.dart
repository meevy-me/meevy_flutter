import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:soul_date/controllers/SoulController.dart';
import 'package:soul_date/models/messages.dart';
import 'package:soul_date/objectbox.g.dart';
import 'package:soul_date/services/store.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../models/chat_model.dart';
import '../services/network.dart';

class MessageController extends GetxController {
  RxList<Chat> chats = <Chat>[].obs;
  WebSocketChannel? connection;
  HttpClient client = HttpClient();
  late LocalStore store;
  final service = FlutterBackgroundService();

  SoulController controller = Get.find<SoulController>();

  @override
  void onInit() async {
    Directory docDir = await getApplicationDocumentsDirectory();

    if (Store.isOpen(docDir.path + "/chatop")) {
      store = await LocalStore.attach();
    } else {
      store = await LocalStore.init();
    }
    // Directory(docDir.path + '/souls').delete();
    // chats.bindStream(getChats());

    super.onInit();
  }

  Stream<List<Chat>> getChats() {
    final QueryBuilder<Chat> queryBuilder = store.store.box<Chat>().query()
      ..order(Chat_.dateCreated, flags: Order.descending);
    return queryBuilder
        .watch(triggerImmediately: true)
        .map((event) => event.find());
  }

  Stream<Chat> getMessages(Chat chat) {
    return store.store
        .box<Chat>()
        .query(Chat_.id.equals(chat.id))
        .watch(triggerImmediately: true)
        .map((event) => event.findFirst()!);
  }

  addMessage(String content,
      {required Chat chat, required ScrollController scrollController}) async {
    // var isRunning = await service.isRunning();
    service.invoke('sendMessage', {"chat": chat.id, "message": content});
  }

  @override
  void dispose() {
    store.store.close();
    super.dispose();
  }
}
