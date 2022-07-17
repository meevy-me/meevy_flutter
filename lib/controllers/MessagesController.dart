import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:objectbox/objectbox.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soul_date/controllers/SoulController.dart';
import 'package:soul_date/models/images.dart';
import 'package:soul_date/models/messages.dart';
import 'package:soul_date/models/profile_model.dart';
import 'package:soul_date/objectbox.g.dart';
import 'package:soul_date/services/store.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../constants/constants.dart';
import '../models/chat_model.dart';
import '../models/friend_model.dart';
import '../services/network.dart';
import 'package:http/http.dart' as http;

class MessageController extends GetxController {
  RxList<Chat> chats = <Chat>[].obs;
  WebSocketChannel? connection;
  HttpClient client = HttpClient();
  late LocalStore store;

  SoulController controller = Get.find<SoulController>();

  @override
  void onInit() async {
    store = await LocalStore.init();
    // Directory docDir = await getApplicationDocumentsDirectory();
    // Directory(docDir.path + '/souls').delete();
    fetchChats();
    // chats.bindStream(getChats());

    openConnection();
    super.onInit();
  }

  void fetchChats() async {
    http.Response res = await client.get(fetchChatsUrl);
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

  Stream<List<Chat>> getChats() {
    final QueryBuilder<Chat> queryBuilder = store.store.box<Chat>().query()
      ..order(Chat_.dateCreated, flags: Order.descending);
    return queryBuilder
        .watch(triggerImmediately: true)
        .map((event) => event.find());
  }

  openConnection() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String token = preferences.getString("token")!;
    connection = IOWebSocketChannel.connect(messagesWs,
        headers: {'authorization': "Token $token"});

    listenConnection();
  }

  addMessage(String content,
      {required Chat chat, required ScrollController scrollController}) async {
    Message message = Message(
      id: 2,
      content: content,
      datePosted: DateTime.now(),
      sender: controller.profile[0].id,
    );
    var index = chats.indexWhere((element) => element == chat);
    chats[index].messages.add(message);
    chats.refresh();
    connection!.sink.add(json.encode({"chat": chat.id, "message": content}));
    scrollController.jumpTo(scrollController.position.maxScrollExtent);
  }

  listenConnection() async {
    if (connection != null) {
      connection!.stream.listen((event) {
        var data = json.decode(event)['message'];
        log(data.toString(), name: "WEBSOCKETS CHAT");
        var index = chats.indexWhere((element) => element.id == data['chat']);
        var chat = chats[index];
        var message = Message(
          id: 5,
          content: data['message'],
          datePosted: DateTime.now(),
          sender: data['sender'],
        );
        chats[index].messages.add(message);
        chats.refresh();

        Get.snackbar(
            chat.friends.target!.profile2.target!.name, message.content);
      });
    }
  }
}
