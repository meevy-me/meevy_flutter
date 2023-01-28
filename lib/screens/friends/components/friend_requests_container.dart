import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soul_date/components/pulse.dart';
import 'package:soul_date/controllers/SoulController.dart';

import '../../../constants/constants.dart';
import '../../../models/models.dart';
import 'friend_request_profile_card.dart';

class FriendRequestsContainer extends StatefulWidget {
  const FriendRequestsContainer({
    Key? key,
  }) : super(key: key);

  @override
  State<FriendRequestsContainer> createState() =>
      _FriendRequestsContainerState();
}

class _FriendRequestsContainerState extends State<FriendRequestsContainer> {
  final SoulController soulController = Get.find<SoulController>();
  late Future<List<Friends>> _future;
  @override
  void initState() {
    _future = soulController.fetchRequests();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: scaffoldPadding,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            "Friend Requests",
            style: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(color: Colors.white),
          ),
          FutureBuilder<List<Friends>>(
              future: _future,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.data != null) {
                  return snapshot.data!.isNotEmpty
                      ? ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data!.length,
                          primary: false,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: defaultMargin),
                              child: FriendRequestProfileCard(
                                friend: snapshot.data![index],
                                onAccept: (friend) async {
                                  bool status =
                                      await soulController.acceptRequests(
                                    friend,
                                  );
                                  setState(() {});

                                  if (status) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                "Friend Request Accepted. :)")));
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                "An error has occured accepted. :)")));
                                  }
                                },
                              ),
                            );
                          },
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: defaultMargin),
                          child: Center(
                              child: Text(
                            "There's nothing here :(",
                            style: Theme.of(context).textTheme.caption,
                          )),
                        );
                }
                return const LoadingPulse();
              })
        ],
      ),
    );
  }
}
