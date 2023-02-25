import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:soul_date/components/chatbox.dart';

import '../../../constants/constants.dart';
import '../../../models/models.dart';

class ChatMessagesList extends StatefulWidget {
  const ChatMessagesList({
    Key? key,
    required this.friend,
    required this.height,
  }) : super(key: key);

  final Friends friend;
  final double height;

  @override
  State<ChatMessagesList> createState() => _ChatMessagesListState();
}

class _ChatMessagesListState extends State<ChatMessagesList> {
  late Stream<QuerySnapshot>? _stream;
  final ScrollController scrollController = ScrollController();
  @override
  void initState() {
    _stream = FirebaseFirestore.instance
        .collection('chatMessages')
        .doc(widget.friend.id.toString())
        .collection('messages')
        .orderBy('date_sent', descending: true)
        .snapshots();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return StreamBuilder<QuerySnapshot>(
        stream: _stream,
        builder: (context, snapshot) {
          return SizedBox(
            height: widget.height,
            child: ListView.builder(
                reverse: true,
                padding: scaffoldPadding,
                // shrinkWrap: true,
                controller: scrollController,
                itemCount: snapshot.data != null ? snapshot.data!.size : 0,
                itemBuilder: (context, index) {
                  var docs = snapshot.data!.docs;
                  var data = docs[index].data() as Map<String, dynamic>;
                  return ChatBox(
                    key: UniqueKey(),
                    friends: widget.friend,
                    profile: widget.friend.friendsProfile,
                    message: Message.fromJson(data),
                    width: size.width * 0.65,
                    onSwipe: ((message) {}),
                  );
                }),
          );
        });
  }
}

class SliverChatMessagesList extends StatefulWidget {
  const SliverChatMessagesList({
    Key? key,
    required this.friend,
    required this.height,
  }) : super(key: key);

  final Friends friend;
  final double height;

  @override
  State<SliverChatMessagesList> createState() => _SliverChatMessagesListState();
}

class _SliverChatMessagesListState extends State<SliverChatMessagesList> {
  late Stream<QuerySnapshot>? _stream;
  final ScrollController scrollController = ScrollController();
  @override
  void initState() {
    _stream = FirebaseFirestore.instance
        .collection('chatMessages')
        .doc(widget.friend.id.toString())
        .collection('messages')
        .orderBy('date_sent', descending: true)
        .snapshots();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return StreamBuilder<QuerySnapshot>(
        stream: _stream,
        builder: (context, snapshot) {
          return ListView.builder(
              reverse: true,
              padding: scaffoldPadding,
              shrinkWrap: true,
              controller: scrollController,
              itemCount: snapshot.data != null ? snapshot.data!.size : 0,
              itemBuilder: (context, index) {
                var docs = snapshot.data!.docs;
                var data = docs[index].data() as Map<String, dynamic>;
                return ChatBox(
                  key: UniqueKey(),
                  friends: widget.friend,
                  profile: widget.friend.friendsProfile,
                  message: Message.fromJson(data),
                  width: size.width * 0.65,
                  onSwipe: ((message) {}),
                );
              });
        });
  }
}
