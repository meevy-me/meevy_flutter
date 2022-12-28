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
import 'components/friend_card.dart';

class FriendsPage extends StatelessWidget {
  const FriendsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: scaffoldPadding,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "My Friends",
                      style: Theme.of(context).textTheme.headline3,
                    ),
                    const Icon(
                      FeatherIcons.userPlus,
                      color: Colors.black,
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: defaultMargin),
                  child: InkWell(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PhoneAuthentication(),
                        )),
                    child: Text(
                      "Add Your Friends. Sync Contacts.",
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(color: Theme.of(context).primaryColor),
                    ),
                  ),
                ),
                GetBuilder<SoulController>(
                  builder: (controller) {
                    return ListView.builder(
                        padding: const EdgeInsets.only(top: defaultMargin),
                        primary: false,
                        itemCount: controller.friends.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          Friends friends = controller.friends[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: defaultMargin),
                            child: FriendCard(
                              friends: friends,
                            ),
                          );
                        });
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
