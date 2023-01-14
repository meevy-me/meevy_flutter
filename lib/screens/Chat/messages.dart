import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:soul_date/components/chat_item.dart';
import 'package:soul_date/components/icon_container.dart';
import 'package:soul_date/components/reorderable_firebase_list.dart';
import 'package:soul_date/components/spot.dart';
import 'package:soul_date/constants/constants.dart';
import 'package:soul_date/controllers/MessagesController.dart';
import 'package:soul_date/controllers/SoulController.dart';
import 'package:soul_date/controllers/SpotController.dart';
import 'package:collection/collection.dart';
import 'package:soul_date/models/friend_model.dart';
import 'package:soul_date/screens/Chat/chat.dart';
import 'package:soul_date/screens/friends/friends.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({Key? key}) : super(key: key);

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  final SoulController controller = Get.find<SoulController>();
  final SpotController spotController = Get.find<SpotController>();
  final MessageController messageController = Get.find<MessageController>();
  final SoulController soulController = Get.find<SoulController>();
  @override
  void initState() {
    spotController.fetchSpots();
    // messageController.fetchChats();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text("Friends & Messages",
            style: Theme.of(context).textTheme.headline5),
        // centerTitle: true,
        actions: [
          IconContainer(
            onPress: () {},
            size: 40,
            icon: const Center(
              child: Icon(
                FeatherIcons.search,
                color: Colors.black,
                size: 20,
              ),
            ),
            color: Colors.grey.withOpacity(0.2),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: defaultMargin),
            child: IconContainer(
              onPress: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const FriendsPage())),
              size: 40,
              icon: const Center(
                child: Icon(
                  FeatherIcons.userPlus,
                  color: Colors.black,
                  size: 20,
                ),
              ),
              color: Colors.grey.withOpacity(0.2),
            ),
          )
        ],
      ),
      floatingActionButton: controller.profile != null
          ? InkWell(
              child: Material(
                color: Theme.of(context).colorScheme.primaryContainer,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                type: MaterialType.button,
                // padding: const EdgeInsets.symmetric(
                //       vertical: defaultMargin,
                //       horizontal: defaultMargin + defaultPadding),
                //   decoration: BoxDecoration(
                //       color: Theme.of(context).colorScheme.primaryContainer,
                //       borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: defaultMargin,
                      horizontal: defaultMargin + defaultPadding),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        'assets/images/status.svg',
                        color: Theme.of(context).primaryColor,
                      ),
                      const SizedBox(
                        width: defaultPadding,
                      ),
                      Text(
                        "Create Spot",
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(color: Colors.white, fontSize: 13),
                      )
                    ],
                  ),
                ),
              ),
              onTap: () =>
                  controller.spotify.fetchCurrentPlaying(context: context),
            )
          : null,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SpotSection(),
            Expanded(child: _MessagesSection(
              onRefresh: () {
                spotController.fetchSpots();
                // messageController.refreshChats();
              },
            ))
          ],
        ),
      ),
    );
  }
}

class _SpotSection extends StatefulWidget {
  const _SpotSection({Key? key}) : super(key: key);

  @override
  State<_SpotSection> createState() => _SpotSectionState();
}

class _SpotSectionState extends State<_SpotSection> {
  final SoulController controller = Get.find<SoulController>();
  final SpotController spotController = Get.find<SpotController>();
  @override
  void initState() {
    fetchMySpot();
    super.initState();
  }

  fetchMySpot() async {
    await spotController.fetchSpots();
    // setState(() {
    //   mySpot = spot;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: defaultMargin * 1.5, vertical: defaultMargin),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Spots",
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(fontSize: 15),
              ),
              Padding(
                padding: const EdgeInsets.only(top: defaultMargin),
                child: SizedBox(
                    height: 90,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Obx(() {
                        return Row(
                          children: [
                            Padding(
                                padding:
                                    const EdgeInsets.only(right: defaultMargin),
                                child:
                                    Obx(() => spotController.mySpots.isNotEmpty
                                        ? SpotWidget(
                                            mine: true,
                                            spots: spotController.mySpots.first,
                                          )
                                        : const SizedBox.shrink())),
                            ...spotController.spots
                                .mapIndexed((index, element) => Padding(
                                      padding: const EdgeInsets.only(
                                          right: defaultMargin * 3),
                                      child: SpotWidget(
                                        mine: false,
                                        spots: spotController.spots[index],
                                      ),
                                    ))
                          ],
                        );
                      }),
                    )),
              ),
              // Padding(
              //   padding: const EdgeInsets.only(top: defaultMargin),
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Text(
              //         "Your Messages",
              //         style: Theme.of(context)
              //             .textTheme
              //             .bodyText1!
              //             .copyWith(fontSize: 15),
              //       ),
              //       Text(
              //         "Drag Chats to reorder",
              //         style: Theme.of(context).textTheme.caption,
              //       )
              //     ],
              //   ),
              // )
            ],
          ),
        )
      ],
    );
  }
}

class _MessagesSection extends StatelessWidget {
  _MessagesSection({Key? key, required this.onRefresh}) : super(key: key);
  final Function onRefresh;
  final MessageController messageController = Get.find<MessageController>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    const Radius radius = Radius.circular(30);
    return Container(
        padding: const EdgeInsets.fromLTRB(
            defaultMargin, defaultMargin, defaultMargin, 0),
        decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.vertical(top: radius)),
        child: RefreshIndicator(
            onRefresh: () => Future.delayed(const Duration(seconds: 1), () {
                  onRefresh();
                }),
            child: ReorderableFirebaseList(
              collection: FirebaseFirestore.instance
                  .collection('userChats')
                  .doc(messageController.userID)
                  .collection('chats'),
              indexKey: 'position',
              itemBuilder: (context, index, doc) {
                var chatId = int.parse(doc['chat_id']);
                return FutureBuilder<Friends>(
                    key: UniqueKey(),
                    initialData: messageController.friends[chatId],
                    future: messageController.getFriend(chatId),
                    builder: (context, snapshot) {
                      return snapshot.data != null &&
                              snapshot.hasData &&
                              !snapshot.hasError
                          ? InkWell(
                              key: UniqueKey(),
                              onTap: () {},
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: defaultMargin / 2),
                                child: InkWell(
                                    onTap: () {
                                      Get.to(() => ChatScreen(
                                            friend: snapshot.data!,
                                          ));
                                    },
                                    child: Column(
                                      children: [
                                        ChatItem(
                                            friend: snapshot.data!, size: size),
                                        const Divider()
                                      ],
                                    )),
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: defaultMargin),
                              child: SpinKitRing(
                                color: Theme.of(context).primaryColor,
                                size: 20,
                                lineWidth: 2,
                              ),
                            );
                    });
              },
            )));
  }
}
