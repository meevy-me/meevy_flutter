import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:soul_date/components/icon_container.dart';
import 'package:soul_date/components/image_circle.dart';
import 'package:soul_date/constants/constants.dart';
import 'package:soul_date/controllers/SoulController.dart';
import 'package:soul_date/models/friend_model.dart';
import 'package:soul_date/screens/Phone/phone_auth.dart';

import '../../models/profile_model.dart';
import 'components/contact_requests_container.dart';
import 'components/friend_card.dart';
import 'components/friend_request_profile_card.dart';
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
                child: Icon(
                  CupertinoIcons.upload_circle,
                  size: 25,
                  color: Colors.black,
                )),
          )
        ],
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Icon(
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
            children: [
              FriendRequestsContainer(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: defaultMargin),
                child: ContactsRequestContainer(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
