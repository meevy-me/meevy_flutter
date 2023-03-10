import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:soul_date/constants/constants.dart';

import 'components/friend_requests_container.dart';

class FriendsPage extends StatelessWidget {
  const FriendsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          "Friends",
          style: Theme.of(context)
              .textTheme
              .bodyText1!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: defaultMargin),
            child: InkWell(
                onTap: () {},
                child: const Icon(
                  CupertinoIcons.upload_circle,
                  size: 25,
                  color: Colors.black,
                )),
          )
        ],
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: const Icon(
            Icons.chevron_left,
            color: Colors.black,
            size: 30,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: scrollPadding,
          child: ListView(
            children: const [
              FriendRequestsContainer(),
            ],
          ),
        ),
      ),
    );
  }
}
