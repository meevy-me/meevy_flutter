import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:soul_date/components/Chat/chat_field.dart';
import 'package:soul_date/components/authfield.dart';
import 'package:soul_date/components/icon_container.dart';
import 'package:soul_date/components/image_circle.dart';
import 'package:soul_date/constants/constants.dart';
import 'package:soul_date/controllers/SoulController.dart';
import 'package:soul_date/models/friend_model.dart';
import 'package:soul_date/models/models.dart';
import 'package:soul_date/screens/home/models/chat_model.dart';
import 'package:text_scroll/text_scroll.dart';

class FriendsModal extends StatefulWidget {
  const FriendsModal({Key? key, required this.item}) : super(key: key);
  final Item item;

  @override
  State<FriendsModal> createState() => _FriendsModalState();
}

class _FriendsModalState extends State<FriendsModal> {
  final TextEditingController searchText = TextEditingController();
  final TextEditingController captionText = TextEditingController();
  List<Friends> selectedFriends = [];
  List<Friends> friends = [];
  final SoulController soulController = Get.find<SoulController>();
  @override
  void initState() {
    setState(() {
      friends = soulController.friends;
    });
    super.initState();
  }

  void searchFriend(String query) {
    if (query == "") {
      setState(() {
        friends = soulController.friends;
      });
    } else {
      final suggestions = friends.where((friend) {
        return friend.friendsProfile.name
            .toLowerCase()
            .contains(query.toLowerCase());
      });
      setState(() {
        friends = suggestions.toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height * 0.65,
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            actions: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: defaultMargin),
                child: IconContainer(
                    onPress: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.close,
                      color: Colors.black,
                    )),
              )
            ],
            title: Text(
              "Send to friend",
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          body: ListView(
            padding: scaffoldPadding,
            children: [
              SizedBox(
                height: 45,
                child: CupertinoSearchTextField(
                  placeholder: "Search for friends",
                  controller: searchText,
                  onChanged: (value) => searchFriend(value),
                ),
              ),
              SizedBox(
                height: 120,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: defaultMargin),
                  child: GetBuilder<SoulController>(builder: (controller) {
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: friends.length,
                      itemBuilder: (context, index) {
                        Friends friend = friends[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: defaultMargin),
                          child: InkWell(
                            onTap: () {
                              if (!selectedFriends.contains(friend)) {
                                setState(() {
                                  selectedFriends.add(friend);
                                });
                              } else {
                                setState(() {
                                  selectedFriends.remove(friend);
                                });
                              }
                            },
                            child: _FriendSearchCard(
                                selectedFriends: selectedFriends,
                                friend: friend),
                          ),
                        );
                      },
                    );
                  }),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: defaultMargin),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(
                          imageUrl: widget.item.album.images.first.url,
                          width: 80,
                          height: 80,
                        )),
                    SizedBox(
                      width: defaultMargin,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextScroll(
                            widget.item.name,
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          TextScroll(
                            widget.item.artists.join(", "),
                            style: Theme.of(context).textTheme.bodyText1,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
                    child: RowSuper(
                      innerDistance: -10,
                      children: [
                        for (int i = 0; i < selectedFriends.length; i++)
                          SoulCircleAvatar(
                            imageUrl: selectedFriends[i]
                                .friendsProfile
                                .images
                                .last
                                .image,
                            radius: 15,
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: defaultPadding,
                  ),
                  selectedFriends.isNotEmpty
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ChatTextField(captionText: captionText),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    fixedSize: Size(50, 50),
                                    elevation: 0,
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                    shape: const CircleBorder()),
                                onPressed: () async {
                                  Map<String, dynamic> sendToProfile = {
                                    "track": widget.item.toJson(),
                                    "audience": selectedFriends
                                        .map((e) => e.friendsProfile.toJson())
                                        .toList(),
                                    "date_sent": DateTime.now().toString(),
                                    "opened": false,
                                    "sender": soulController.profile!.toJson(),
                                    "caption": captionText.text
                                  };
                                  var doc_ref = await FirebaseFirestore.instance
                                      .collection('sentTracks')
                                      .add(sendToProfile);

                                  VinylChat vinylChat = VinylChat(
                                      sender: soulController.profile!,
                                      message: captionText.text,
                                      dateSent: DateTime.now());

                                  FirebaseFirestore.instance
                                      .collection('sentTracks')
                                      .doc(doc_ref.id)
                                      .collection('messages')
                                      .add(vinylChat.toJson());

                                  for (var element in selectedFriends) {
                                    FirebaseFirestore.instance
                                        .collection('userSentTracks')
                                        .doc(element.friendsProfile.user.id
                                            .toString())
                                        .collection('sentTracks')
                                        .doc(doc_ref.id)
                                        .set({
                                      "date_sent": DateTime.now().toString()
                                    });
                                  }
                                  captionText.clear();
                                  Navigator.pop(context);
                                },
                                child: const Center(
                                    child: Icon(
                                  CupertinoIcons.paperplane_fill,
                                  size: 20,
                                )))
                          ],
                        )
                      : const SizedBox.shrink(),
                ],
              )
            ],
          )),
    );
  }
}

class _FriendSearchCard extends StatelessWidget {
  const _FriendSearchCard({
    Key? key,
    required this.selectedFriends,
    required this.friend,
  }) : super(key: key);

  final List<Friends> selectedFriends;
  final Friends friend;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                  width: 2,
                  color: selectedFriends.contains(friend)
                      ? Theme.of(context).primaryColor
                      : Colors.white)),
          child: SoulCircleAvatar(
            imageUrl: friend.friendsProfile.images.first.image,
            radius: 35,
          ),
        ),
        const SizedBox(
          width: defaultMargin,
        ),
        Text(
          friend.friendsProfile.name.split(" ")[0],
          style: Theme.of(context).textTheme.bodyText1,
        ),
        Visibility(
          visible: selectedFriends.contains(friend),
          child: Container(
            height: 5,
            width: 10,
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(20)),
          ),
        )
      ],
    );
  }
}
