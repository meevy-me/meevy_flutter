import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:soul_date/components/chat_item.dart';
import 'package:soul_date/components/spot.dart';
import 'package:soul_date/constants/constants.dart';
import 'package:soul_date/controllers/MessagesController.dart';
import 'package:soul_date/controllers/SoulController.dart';
import 'package:soul_date/controllers/SpotController.dart';
import 'package:collection/collection.dart';
import 'package:soul_date/models/chat_model.dart';
import 'package:soul_date/screens/chat.dart';
import 'package:soul_date/screens/friend_requests.dart';

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
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Theme.of(context).primaryColor, primaryDark])),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        floatingActionButton: FloatingActionButton(
            backgroundColor: Theme.of(context).primaryColor,
            child: const Icon(FontAwesomeIcons.spotify),
            onPressed: () async {}),
        body: SafeArea(
          child: Column(
            children: [
              const _SpotSection(),
              Expanded(child: _MessagesSection(
                onRefresh: () {
                  spotController.fetchSpots();
                  // messageController.fetchChats();
                },
              ))
            ],
          ),
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
          padding: const EdgeInsets.only(top: defaultMargin),
          child: Row(
            children: [
              const BackButton(color: Colors.white),
              const Expanded(
                child: Center(
                  child: Text("Friends & Spots",
                      style: TextStyle(color: Colors.white, fontSize: 17)),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: defaultMargin * 1.5),
                child: IconButton(
                  onPressed: () {
                    Get.to(() => const FriendRequestScreen());
                  },
                  icon: const Icon(
                    FontAwesomeIcons.userGroup,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: defaultMargin * 1.5, vertical: defaultMargin),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Recent Spots",
                style: Theme.of(context)
                    .textTheme
                    .bodyText2!
                    .copyWith(color: Colors.white, fontSize: 15),
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
                                padding: const EdgeInsets.only(
                                    right: defaultMargin * 3),
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
              )
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
    var messages = messageController.chats;
    Size size = MediaQuery.of(context).size;
    const Radius radius = Radius.circular(30);
    return Container(
        padding: const EdgeInsets.fromLTRB(
            defaultMargin, defaultMargin * 2, defaultMargin, 0),
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: radius)),
        child: RefreshIndicator(
          onRefresh: () => Future.delayed(const Duration(seconds: 1), () {
            onRefresh();
          }),
          child: StreamBuilder<List<Chat>>(
              stream: messageController.getChats(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return SpinKitCircle(
                    color: Theme.of(context).primaryColor,
                  );
                } else {
                  // print(" YAAAHAHHH " +
                  //     snapshot.data!.last.friends.target.profile1);
                  return ListView.separated(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      var message = snapshot.data![index];
                      return InkWell(
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: defaultMargin / 2),
                          child: InkWell(
                            onTap: () {
                              Get.to(() => ChatScreen(chat: message));
                            },
                            child: message.friends.target != null
                                ? ChatItem(message: message, size: size)
                                : const SizedBox.shrink(),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const Divider();
                    },
                  );
                }
              }),
        ));
  }
}
