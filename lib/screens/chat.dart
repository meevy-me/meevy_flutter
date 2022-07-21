import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:soul_date/components/chatbox.dart';
import 'package:soul_date/components/image_circle.dart';
import 'package:soul_date/constants/constants.dart';
import 'package:soul_date/controllers/MessagesController.dart';
import 'package:soul_date/controllers/SoulController.dart';
import 'package:soul_date/models/chat_model.dart';
import 'package:soul_date/models/messages.dart';
import 'package:soul_date/models/profile_model.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key, required this.chat}) : super(key: key);
  final Chat chat;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController text = TextEditingController();
  late MessageController messageController;
  final ScrollController scrollController = ScrollController();
  final SoulController controller = Get.find<SoulController>();
  late Profile profile;

  Profile currentProfile() {
    if (controller.profile!.id ==
        widget.chat.friends.target!.profile1.target!.id) {
      return widget.chat.friends.target!.profile2.target!;
    } else {
      return widget.chat.friends.target!.profile1.target!;
    }
  }

  @override
  void initState() {
    profile = currentProfile();
    messageController = Get.find<MessageController>();
    super.initState();
  }

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
        title: Text(
          profile.name,
          style: Theme.of(context).textTheme.bodyText1,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: defaultMargin),
            child: SoulCircleAvatar(
              imageUrl: profile.images.first.image,
              radius: 15,
            ),
          )
        ],
        centerTitle: true,
      ),
      body: SafeArea(
          child: SizedBox(
        height: size.height,
        child: Stack(
          children: [
            SizedBox(
              height: size.height * 0.8 -
                  MediaQuery.of(context).viewInsets.bottom -
                  10,
              child: _MessageBody(
                chat: widget.chat,
                scrollController: scrollController,
              ),
            ),
            Positioned(
              bottom: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: defaultMargin, vertical: defaultMargin),
                child: SizedBox(
                  width: size.width,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                          child: Padding(
                        padding: const EdgeInsets.only(right: defaultMargin),
                        child: TextFormField(
                          controller: text,
                          maxLines: null,
                          style: Theme.of(context).textTheme.bodyText2,
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.grey.withOpacity(0.4),
                              hintText: "Type Message",
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide.none),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(20)),
                              hintStyle: Theme.of(context).textTheme.caption),
                        ),
                      )),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              elevation: 0,
                              primary: Theme.of(context).primaryColor,
                              shape: const CircleBorder()),
                          onPressed: () {
                            if (text.text.trim().isNotEmpty) {
                              messageController.addMessage(text.text,
                                  chat: widget.chat,
                                  scrollController: scrollController);
                              text.clear();
                            }
                          },
                          child: const Center(
                              child: Icon(
                            Icons.send,
                            size: 15,
                          )))
                    ],
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
    required this.scrollController,
  }) : super(key: key);
  final Chat chat;
  final ScrollController scrollController;
  @override
  State<_MessageBody> createState() => _MessageBodyState();
}

class _MessageBodyState extends State<_MessageBody> {
  final SoulController controller = Get.find<SoulController>();

  final MessageController messageController = Get.find<MessageController>();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.scrollController.hasClients) {
        widget.scrollController
            .jumpTo(widget.scrollController.position.maxScrollExtent);
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    if (widget.scrollController.hasClients) {
      widget.scrollController.animateTo(
          widget.scrollController.position.maxScrollExtent,
          duration: const Duration(seconds: 1),
          curve: Curves.linear);
    }
    return StreamBuilder<Chat>(
        stream: messageController.getMessages(widget.chat),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: Text(
                "Ooops :/ There's nothing here, say hi",
                style: Theme.of(context).textTheme.caption,
              ),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.messages.length,
              itemBuilder: (context, index) {
                var element = snapshot.data!.messages[index];
                return ChatBox(
                    size: size,
                    mine: element.sender == controller.profile!.id,
                    text: element.content,
                    time: DateFormat.jm().format(element.datePosted));
              },
              controller: widget.scrollController,
              padding: scaffoldPadding,
            );
          }
        });
  }
}
