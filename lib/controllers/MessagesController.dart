import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:get/get.dart';
import 'package:retry/retry.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soul_date/controllers/SoulController.dart';
import 'package:soul_date/objectbox.g.dart';
import 'package:soul_date/services/store.dart';
import 'package:web_socket_channel/io.dart';

import 'package:web_socket_channel/web_socket_channel.dart';
import '../constants/constants.dart';
import '../models/models.dart';
import '../services/network.dart';

class MessageController extends GetxController {
  RxList<Chat> chats = <Chat>[].obs;
  WebSocketChannel? connection;
  HttpClient client = HttpClient();
  final service = FlutterBackgroundService();

  SoulController controller = Get.find<SoulController>();

  @override
  void onInit() async {
    openConnection();

    super.onInit();
  }

  void openConnection() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String token = preferences.getString("token")!;
    connection = IOWebSocketChannel.connect(messagesWs,
        headers: {'authorization': "Token $token"});
    listenConnection(controller.store);
    fetchChats(controller.store);
  }

  void messageToStore(Chat chat,
      {required Message message, required LocalStore store}) async {
    await store.insert<Message>(message);
    // print(id);

    chat.messages.add(message);
    chat.dateCreated = message.datePosted;
    await store.insert<Chat>(chat);
  }

  Future<Chat?> addMessage(
    LocalStore store,
    Map data,
  ) async {
    Chat? chat = await store.get<Chat>(data["chat"]);
    if (chat != null) {
      var message = Message(
        id: data['id'],
        replyTo: data['reply_to'],
        content: data['content'],
        datePosted: DateTime.parse(data['date_posted']),
        sender: data['sender'],
      );
      chat.dateCreated = DateTime.parse(data['date_posted']);
      messageToStore(chat, message: message, store: store);

      // NotificationApi.showNotification(
      //     title: "Message from ${chat.friends.target!.profile2.target!.name}",
      //     body: message.formatContent,
      //     payload: chat.id.toString());
      // if (service is AndroidServiceInstance) {
      //   service.setForegroundNotificationInfo(
      //     title: "New Message from ${chat.friends.target!.profile2.target!.name}",
      //     content: message.content,
      //   );
      // }
      return chat;
    }
    return null;
  }

  listenConnection(LocalStore store) async {
    if (connection != null) {
      connection!.stream.listen((event) {
        var data = json.decode(event)['message'];
        addMessage(store, data);
      },
          onDone: () async => await retry(() async => openConnection()),
          onError: (error) async => await retry(() async => openConnection()));
    }
  }

  Stream<List<Chat>> getChats() {
    final QueryBuilder<Chat> queryBuilder = controller.store.store
        .box<Chat>()
        .query()
      ..order(Chat_.dateCreated, flags: Order.descending);
    return queryBuilder
        .watch(triggerImmediately: true)
        .map((event) => event.find());
  }

  void refreshChats() {
    if (connection == null) {
      openConnection();
    }
    fetchChats(controller.store);
  }

  Stream<Chat> getMessages(Chat chat) {
    return controller.store.store
        .box<Chat>()
        .query(Chat_.id.equals(chat.id))
        .watch(triggerImmediately: true)
        .map((event) => event.findFirst()!);
  }

  addMessageSocket(String content,
      {required Chat chat,
      required ScrollController scrollController,
      int? reply}) async {
    var payload = {"chat": chat.id, "message": content};
    if (reply != null) {
      payload["reply_to"] = reply;
    }

    sendMessage(payload, store: controller.store);
    // var isRunning = await service.isRunning();
  }

  void sendMessage(
    Map? payload, {
    required LocalStore store,
  }) async {
    // SharedPreferences preferences = await SharedPreferences.getInstance();
    // int profile = preferences.getInt('profileID')!;
    if (payload != null) {
      connection!.sink.add(json.encode(payload));

      // Message message = Message(
      //     id: 0, content: content, datePosted: DateTime.now(), sender: profile);
      // Chat? chat = await store.get<Chat>(id);
      // if (chat != null) {
      //   messageToStore(chat, message: message, store: store);
      // }
    }
  }

  void fetchChats(LocalStore store) async {
    var res = await client.get(fetchChatsUrl);
    if (res.statusCode <= 210) {
      var chatList = chatFromJson(utf8.decode(res.bodyBytes));
      for (var element in chatList) {
        store.store.box<Friends>().put(element.friends.target!);
        store.store
            .box<ProfileImages>()
            .putMany(element.friends.target!.profile1.target!.images);
        store.store
            .box<ProfileImages>()
            .putMany(element.friends.target!.profile2.target!.images);
        store.store
            .box<Profile>()
            .put(element.friends.target!.profile2.target!);
        store.store
            .box<Profile>()
            .put(element.friends.target!.profile1.target!);

        store.store.box<Message>().putMany(element.messages);
      }
      store.insertList<Chat>(chatList);
      // chats.value = chatList;
    } else {
      log(res.body, name: "CHATS ERROR");
    }
  }

  @override
  void dispose() {
    controller.store.store.close();
    super.dispose();
  }
}
