import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:soul_date/components/buttons.dart';
import 'package:soul_date/components/empty_widget.dart';
import 'package:soul_date/components/image_circle.dart';
import 'package:soul_date/constants/constants.dart';
import 'package:soul_date/controllers/SoulController.dart';
import 'package:soul_date/models/friend_model.dart';
import 'package:soul_date/models/profile_model.dart';

class FriendRequestScreen extends StatefulWidget {
  const FriendRequestScreen({Key? key}) : super(key: key);

  @override
  State<FriendRequestScreen> createState() => _FriendRequestScreenState();
}

class _FriendRequestScreenState extends State<FriendRequestScreen> {
  final SoulController controller = Get.find<SoulController>();
  @override
  void initState() {
    controller.fetchRequests();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: const BackButton(color: Colors.black),
          title: Text(
            "Soul Requests",
            style: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(fontWeight: FontWeight.w600),
          ),
          centerTitle: true,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
        ),
        body: Obx(() => controller.friendRequest.isNotEmpty
            ? ListView.builder(
                padding: scrollPadding,
                itemBuilder: (context, index) {
                  return FriendRequestCard(
                    friend: controller.friendRequest[index],
                  );
                },
                itemCount: controller.friendRequest.length,
              )
            : const Center(
                child: EmptyWidget(
                  assetString: "assets/images/lottie_empty2.json",
                  text: "No new requests yet :/",
                ),
              )));
  }
}

class FriendRequestCard extends StatelessWidget {
  final SoulController controller = Get.find<SoulController>();
  FriendRequestCard({
    required this.friend,
    Key? key,
  }) : super(key: key);
  Friends friend;

  Profile currentProfile() {
    if (controller.profile!.id == friend.profile1.target!.id) {
      return friend.profile2.target!;
    } else {
      return friend.profile1.target!;
    }
  }

  @override
  Widget build(BuildContext context) {
    var profile = currentProfile();
    return Container(
      margin: const EdgeInsets.only(bottom: defaultMargin * 2),
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(defaultMargin),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SoulCircleAvatar(imageUrl: profile.images.first.image),
                const SizedBox(
                  width: defaultMargin,
                ),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                    profile.name,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ])
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const RoundedIconButton(
                  icon: Icons.close,
                  color: Colors.red,
                ),
                const SizedBox(
                  width: defaultMargin * 3,
                ),
                RoundedIconButton(
                  onTap: () {
                    controller.acceptRequests(friend, context: context);
                  },
                  icon: FontAwesomeIcons.heartCirclePlus,
                  color: Theme.of(context).primaryColor,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
