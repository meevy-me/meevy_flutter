import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soul_date/components/Chat/profile_status.dart';
import 'package:soul_date/components/chatbox.dart';
import 'package:soul_date/components/empty_widget.dart';
import 'package:soul_date/components/icon_container.dart';
import 'package:soul_date/constants/constants.dart';
import 'package:soul_date/controllers/MessagesController.dart';
import 'package:soul_date/controllers/SoulController.dart';
import 'package:soul_date/models/friend_model.dart';
import 'package:soul_date/models/messages.dart';
import 'package:soul_date/models/profile_model.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key, required this.friend}) : super(key: key);
  final Friends friend;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController text = TextEditingController();
  late MessageController messageController;
  final ScrollController scrollController = ScrollController();
  final SoulController controller = Get.find<SoulController>();
  late Profile profile;
  FocusNode focus = FocusNode();
  late Stream<QuerySnapshot>? _stream;
  Profile currentProfile() {
    if (controller.profile!.id == widget.friend.profile1.id) {
      return widget.friend.profile2;
    } else {
      return widget.friend.profile1;
    }
  }

  @override
  void initState() {
    profile = currentProfile();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.jumpTo(200);
      }
    });
    messageController = Get.find<MessageController>();
    _stream = FirebaseFirestore.instance
        .collection('chatMessages')
        .doc(widget.friend.id.toString())
        .collection('messages')
        .orderBy('date_sent', descending: true)
        .snapshots();
    super.initState();
  }

  Message? replyTo;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(
          color: Colors.black,
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title: ProfileStatus(profile: profile),
        actions: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: defaultMargin),
            child: IconContainer(
                icon: Icon(
              CupertinoIcons.music_albums,
              color: Colors.black,
            )),
          )
        ],
        centerTitle: true,
      ),
      body: SafeArea(
          child: SizedBox(
        height: size.height,
        width: size.width,
        child: Stack(
          children: [
            SizedBox(
                height: (size.height * 0.8 -
                        MediaQuery.of(context).viewInsets.bottom -
                        10) -
                    (replyTo != null ? 70 : 0),
                child: StreamBuilder<QuerySnapshot>(
                    stream: _stream,
                    builder: (context, snapshot) {
                      return ListView.builder(
                          reverse: true,
                          padding: scaffoldPadding,
                          shrinkWrap: true,
                          controller: scrollController,
                          itemCount:
                              snapshot.data != null ? snapshot.data!.size : 0,
                          itemBuilder: (context, index) {
                            var docs = snapshot.data!.docs;
                            var data =
                                docs[index].data() as Map<String, dynamic>;
                            return ChatBox(
                              key: UniqueKey(),
                              friends: widget.friend,
                              profile: profile,
                              message: Message.fromJson(data),
                              width: size.width * 0.65,
                              onSwipe: ((message) {
                                setState(() {
                                  replyTo = message;
                                  focus.requestFocus();
                                });
                              }),
                            );
                          });
                    })),
            Positioned(
              bottom: 0,
              child: SizedBox(
                width: size.width,
                height: size.height * 0.2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: defaultMargin, vertical: defaultMargin),
                  child: Padding(
                    padding: const EdgeInsets.only(right: defaultMargin),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (replyTo != null)
                          ReplyChatBox(
                            message: replyTo!,
                            profile: profile,
                            width: size.width * 0.8,
                            height: 100,
                            onClose: () {
                              setState(() {
                                replyTo = null;
                              });
                            },
                          ),
                        Expanded(
                          child: AnimatedSize(
                            duration: const Duration(seconds: 2),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Expanded(
                                  // constraints: BoxConstraints(
                                  //     minWidth: size.width * 0.8,
                                  //     maxWidth: size.width * 0.8,
                                  //     minHeight: 50),
                                  child: AnimatedSize(
                                    duration: const Duration(seconds: 2),
                                    child: TextFormField(
                                      focusNode: focus,
                                      cursorHeight: 1,
                                      controller: text,
                                      onChanged: (value) {
                                        if (value.isEmpty ||
                                            value.length == 1) {
                                          setState(() {});
                                        }
                                      },
                                      maxLines: null,
                                      textCapitalization:
                                          TextCapitalization.sentences,
                                      style:
                                          Theme.of(context).textTheme.bodyText2,
                                      decoration: InputDecoration(
                                          isDense: true,
                                          filled: true,
                                          fillColor:
                                              Colors.grey.withOpacity(0.4),
                                          hintText: "Type Message",
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              borderSide: BorderSide.none),
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          hintStyle: Theme.of(context)
                                              .textTheme
                                              .caption),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: defaultMargin,
                                ),
                                text.text.isNotEmpty
                                    ? ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            elevation: 0,
                                            fixedSize: const Size(40, 40),
                                            backgroundColor:
                                                Theme.of(context).primaryColor,
                                            shape: const CircleBorder()),
                                        onPressed: () {
                                          if (text.text.trim().isNotEmpty) {
                                            // messageController.addMessageSocket(text.text,
                                            //     reply:
                                            //         replyTo != null ? replyTo!.id : null,
                                            //     chat: widget.chat,
                                            //     scrollController: scrollController);
                                            messageController.sendMessage(
                                                chatID: widget.friend.id,
                                                msg: text.text,
                                                receiver: profile,
                                                replyTo: replyTo);

                                            text.clear();
                                            setState(() {
                                              replyTo = null;
                                            });
                                          }
                                        },
                                        child: const Center(
                                            child: Icon(
                                          Icons.send,
                                          size: 15,
                                        )))
                                    : const SizedBox.shrink()
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      )),
    );
  }
}

class _MessageBody extends StatefulWidget {
  const _MessageBody({
    Key? key,
    required this.chat,
    required this.onReplyTo,
    required this.profile,
  }) : super(key: key);
  final Friends chat;
  final Function(Message message) onReplyTo;
  final Profile profile;
  @override
  State<_MessageBody> createState() => _MessageBodyState();
}

class _MessageBodyState extends State<_MessageBody> {
  final SoulController controller = Get.find<SoulController>();
  final MessageController messageController = Get.find<MessageController>();
  final ScrollController scrollController = ScrollController();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.jumpTo(scrollController.position.maxScrollExtent);
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return StreamBuilder<List<Message>>(
        stream: messageController.fetchMessages(widget.chat.id.toString()),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: Text(
                "Ooops :/ There's nothing here, say hi",
                style: Theme.of(context).textTheme.caption,
              ),
            );
          } else if (snapshot.data!.isEmpty) {
            return const Center(
                child: EmptyWidget(
              text: "There's nothing here, say Hi",
            ));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                var element = snapshot.data![index];
                return ChatBox(
                  key: UniqueKey(),
                  friends: widget.chat,
                  profile: widget.profile,
                  message: element,
                  width: size.width * 0.65,
                  onSwipe: ((message) {
                    widget.onReplyTo(message);
                  }),
                );
              },
              controller: scrollController,
              padding: scaffoldPadding,
            );
          }
        });
  }
}
