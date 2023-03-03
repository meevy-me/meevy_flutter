import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:soul_date/animations/animations.dart';
import 'package:soul_date/controllers/SoulController.dart';
import 'package:soul_date/models/messages.dart';
import 'package:soul_date/models/profile_model.dart';
import 'package:soul_date/screens/Chat/chat3.dart';
import 'package:soul_date/services/formatting.dart';
import 'package:soul_date/services/navigation.dart';
import '../constants/constants.dart';
import '../models/friend_model.dart';
import 'Chat/listening_activity.dart';
import 'image_circle.dart';

class ChatItem extends StatefulWidget {
  const ChatItem({
    Key? key,
    required this.friend,
    required this.size,
    this.lastMessage,
  }) : super(key: key);

  final Friends friend;
  final Size size;
  final Message? lastMessage;

  @override
  State<ChatItem> createState() => _ChatItemState();
}

class _ChatItemState extends State<ChatItem> {
  final SoulController controller = Get.find<SoulController>();

  Profile currentProfile() {
    if (controller.profile!.id == widget.friend.profile1.id) {
      return widget.friend.profile2;
    } else {
      return widget.friend.profile1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SoulController>(
        id: 'profile',
        builder: (controller) {
          if (controller.profile != null) {
            Profile profile = currentProfile();

            return InkWell(
              onTap: () => Navigation.push(context,
                  customPageTransition: PageTransition(
                      child: ChatMessagesPage(friend: widget.friend),
                      type: PageTransitionType.fadeIn)),
              child: Row(
                children: [
                  ProfileAvatar(
                    profileID: profile.id,
                    // imageUrl: profile.images.last.image,
                    radius: 25,
                  ),
                  Expanded(
                    child: Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: defaultMargin),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            profile.name,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: defaultMargin),
                            child: _ChatMessage(
                                lastMessage: widget.lastMessage,
                                friends: widget.friend,
                                currentProfile: profile),
                          ),

                          ListeningActivity(
                              profile: profile, friends: widget.friend)
                          // _ChatMessage(
                          //   friends: widget.friend,
                          //   currentProfile: currentProfile(),
                          // ),
                        ],
                      ),
                    ),
                  ),
                  widget.lastMessage != null
                      ? Text(
                          timeFormat(widget.lastMessage!.datePosted!.toDate()),
                          style: Theme.of(context).textTheme.caption,
                        )
                      : const SizedBox.shrink()
                ],
              ),
            );
          } else {
            return SpinKitRing(
              color: Theme.of(context).primaryColor,
              lineWidth: 2,
              size: 20,
            );
          }
        });
  }
}

class _ChatMessage extends StatefulWidget {
  const _ChatMessage({
    Key? key,
    required this.friends,
    required this.currentProfile,
    this.lastMessage,
  }) : super(key: key);
  final Friends friends;
  final Profile currentProfile;
  final Message? lastMessage;

  @override
  State<_ChatMessage> createState() => _ChatMessageState();
}

class _ChatMessageState extends State<_ChatMessage> {
  SoulChatText? soulChatText;

  @override
  void initState() {
    if (widget.lastMessage != null) {
      soulChatText = SoulChatText(text: widget.lastMessage!.content);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return widget.lastMessage != null
        ? Row(
            children: [
              soulChatText != null && soulChatText!.valid
                  ? Padding(
                      padding: const EdgeInsets.only(right: defaultPadding),
                      child: Icon(
                        Icons.music_note,
                        size: 12,
                        color: widget.lastMessage!.sender ==
                                widget.currentProfile.user.id
                            ? Theme.of(context).primaryColor
                            : Colors.grey,
                      ),
                    )
                  : Container(
                      margin: const EdgeInsets.only(right: defaultPadding),
                      height: 6,
                      width: 6,
                      decoration: BoxDecoration(
                          color: widget.lastMessage!.sender ==
                                  widget.currentProfile.user.id
                              ? Theme.of(context).primaryColor
                              : Colors.grey,
                          shape: BoxShape.circle),
                    ),
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: size.width * 0.6),
                child: Text(
                  soulChatText != null && soulChatText!.valid
                      ? "Sent a ${SoulChatText(text: widget.lastMessage!.content).format}"
                      : widget.lastMessage!.content,
                  style: Theme.of(context).textTheme.caption!.copyWith(
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF2A2A2A),
                      overflow: TextOverflow.ellipsis),
                ),
              )
            ],
          )
        : Text("Say Hello",
            style: Theme.of(context).textTheme.caption!.copyWith(
                fontWeight: FontWeight.w600,
                color: const Color(0xFF2A2A2A),
                overflow: TextOverflow.ellipsis));
  }
}
