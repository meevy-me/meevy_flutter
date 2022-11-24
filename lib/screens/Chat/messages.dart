import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:soul_date/components/chat_item.dart';
import 'package:soul_date/components/empty_widget.dart';
import 'package:soul_date/components/spot.dart';
import 'package:soul_date/constants/constants.dart';
import 'package:soul_date/controllers/MessagesController.dart';
import 'package:soul_date/controllers/SoulController.dart';
import 'package:soul_date/controllers/SpotController.dart';
import 'package:collection/collection.dart';
import 'package:soul_date/models/friend_model.dart';
import 'package:soul_date/screens/Chat/chat.dart';
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
      decoration: const BoxDecoration(
        color: Colors.white,
        // gradient: LinearGradient(
        //     begin: Alignment.topCenter,
        //     end: Alignment.bottomCenter,
        //     colors: [Theme.of(context).primaryColor, primaryDark])
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        floatingActionButton: FloatingActionButton(
            backgroundColor: Theme.of(context).primaryColor,
            child: const Icon(FontAwesomeIcons.spotify),
            onPressed: () async {
              controller.spotify.fetchCurrentPlaying(context: context);
            }),
        body: SafeArea(
          child: Column(
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
              const BackButton(),
              Expanded(
                child: Center(
                  child: Text("Souls & Spots",
                      style: Theme.of(context).textTheme.bodyText1),
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
                    size: 18,
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
                "Friend's Spots",
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
              Padding(
                padding: const EdgeInsets.only(top: defaultMargin),
                child: Text(
                  "Your Messages",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(fontSize: 15),
                ),
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
    Size size = MediaQuery.of(context).size;
    const Radius radius = Radius.circular(30);
    return Container(
        padding: const EdgeInsets.fromLTRB(
            defaultMargin, defaultMargin, defaultMargin, 0),
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: radius)),
        child: RefreshIndicator(
          onRefresh: () => Future.delayed(const Duration(seconds: 1), () {
            onRefresh();
          }),
          child: StreamBuilder<List<Friends>>(
              stream: messageController.fetchChats(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return SpinKitCircle(
                    color: Theme.of(context).primaryColor,
                  );
                } else if (snapshot.data == null && snapshot.data!.isEmpty) {
                  return const EmptyWidget(
                    text: "No chats yet",
                  );
                } else {
                  snapshot.data!.sort(((a, b) => a.compareTo(b)));

                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      var friend = snapshot.data![index];
                      return InkWell(
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: defaultMargin / 2),
                          child: InkWell(
                              onTap: () {
                                Get.to(() => ChatScreen(
                                      friend: friend,
                                    ));
                              },
                              child: Column(
                                children: [
                                  ChatItem(friend: friend, size: size),
                                  const Divider()
                                ],
                              )),
                        ),
                      );
                    },
                  );
                }
              }),
        ));
  }
}
