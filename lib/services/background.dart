import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:objectbox/objectbox.dart';
import 'package:path_provider/path_provider.dart';
import 'package:retry/retry.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soul_date/models/friend_model.dart';
import 'package:soul_date/models/images.dart';
import 'package:soul_date/models/messages.dart';
import 'package:soul_date/models/profile_model.dart';
import 'package:soul_date/services/network.dart';
import 'package:soul_date/services/notifications.dart';
import 'package:soul_date/services/store.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../constants/constants.dart';
import '../models/chat_model.dart';

WebSocketChannel? connection;
HttpClient client = HttpClient();
Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      // this will be executed when app is in foreground or background in separated isolate
      onStart: onStart,

      // auto start service
      autoStart: true,
      isForegroundMode: false,
    ),
    iosConfiguration: IosConfiguration(
      // auto start service
      autoStart: true,

      // this will be executed when app is in foreground in separated isolate
      onForeground: onStart,

      // you have to enable background fetch capability on xcode project
      onBackground: onIosBackground,
    ),
  );
  service.startService();
}

bool onIosBackground(ServiceInstance service) {
  WidgetsFlutterBinding.ensureInitialized();
  // print('FLUTTER BACKGROUND FETCH');

  return true;
}

void onStart(ServiceInstance service) async {
  // Only available for flutter 3.0.0 and later
  DartPluginRegistrant.ensureInitialized();
  late LocalStore store;
  Directory docDir = await getApplicationDocumentsDirectory();

  if (Store.isOpen(docDir.path + "/chatop")) {
    store = await LocalStore.attach();
  } else {
    store = await LocalStore.init();
  }

  initConnection(service, store: store);

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      // service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  service.on('stopService').listen((event) {
    store.store.close();
    service.stopSelf();
  });

  service.on('sendMessage').listen((event) {
    sendMessage(event, store: store);
  });
}

void sendMessage(
  Map? event, {
  required LocalStore store,
}) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  int profile = preferences.getInt('profileID')!;
  if (event != null) {
    var id = event['chat'];
    var content = event['message'];
    connection!.sink.add(json.encode({"chat": id, "message": content}));

    Message message = Message(
        id: 0, content: content, datePosted: DateTime.now(), sender: profile);
    Chat? chat = await store.get<Chat>(id);
    if (chat != null) {
      messageToStore(chat, message: message, store: store);
    }
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
      store.store.box<Profile>().put(element.friends.target!.profile2.target!);
      store.store.box<Profile>().put(element.friends.target!.profile1.target!);

      store.store.box<Message>().putMany(element.messages);
    }
    store.insertList<Chat>(chatList);
    // chats.value = chatList;
  } else {
    log(res.body, name: "CHATS ERROR");
  }
}

void initConnection(ServiceInstance service,
    {required LocalStore store}) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  String token = preferences.getString("token")!;
  connection = IOWebSocketChannel.connect(messagesWs,
      headers: {'authorization': "Token $token"});
  fetchChats(store);
  listenConnection(service, store);
}

void messageToStore(Chat chat,
    {required Message message, required LocalStore store}) async {
  await store.insert<Message>(message);
  // print(id);

  chat.messages.add(message);
  chat.dateCreated = message.datePosted;
  await store.insert<Chat>(chat);
}

Future<Chat?> addMessage(LocalStore store, Map data,
    {required ServiceInstance service}) async {
  Chat? chat = await store.get<Chat>(data["chat"]);
  if (chat != null) {
    var message = Message(
      id: 0,
      content: data['content'],
      datePosted: DateTime.parse(data['date_posted']),
      sender: data['sender'],
    );
    messageToStore(chat, message: message, store: store);

    NotificationApi.showNotification(
        title: "Message from ${chat.friends.target!.profile2.target!.name}",
        body: message.formatContent,
        payload: chat.id.toString());
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

listenConnection(ServiceInstance service, LocalStore store) async {
  if (connection != null) {
    connection!.stream.listen(
      (event) {
        var data = json.decode(event)['message'];
        addMessage(store, data, service: service);
      },
      // onDone: () async =>
      //     await retry(() async => initConnection(service, store: store)),
      // onError: (error) async =>
      //     await retry(() async => initConnection(service, store: store))
    );
  }
}
