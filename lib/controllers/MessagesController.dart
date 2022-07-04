import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soul_date/controllers/SoulController.dart';
import 'package:soul_date/models/messages.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../constants/constants.dart';
import '../models/chat_model.dart';
import '../services/network.dart';
import 'package:http/http.dart' as http;

class MessageController extends GetxController {
  MessageController();
  RxList<Chat> chats = <Chat>[].obs;
  WebSocketChannel? connection;
  HttpClient client = HttpClient();

  SoulController controller = Get.find<SoulController>();
  @override
  void onInit() {
    fetchChats();
    openConnection();
    super.onInit();
  }

  void fetchChats() async {
    http.Response res = await client.get(fetchChatsUrl);
    if (res.statusCode <= 210) {
      chats.value = chatFromJson(utf8.decode(res.bodyBytes));
    } else {
      log(res.body, name: "CHATS ERROR");
    }
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
        spot: null);
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
            spot: null);
        chats[index].messages.add(message);
        chats.refresh();

        Get.snackbar(chat.friends.profile2.name, message.content);
      });
    }
  }
}
