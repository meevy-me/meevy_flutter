import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soul_date/components/image_circle.dart';
import 'package:soul_date/constants/constants.dart';
import 'package:soul_date/controllers/SoulController.dart';
import 'package:soul_date/screens/profile_home.dart';

import 'logo.dart';

AppBar buildHomeAppBar(BuildContext context) {
  return AppBar(
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    elevation: 0,

    // leading: IconButton(
    //   onPressed: () {},
    //   icon: SvgPicture.asset(
    //     'assets/images/musicbars.svg',
    //     height: 25,
    //     width: 25,
    //   ),
    // ),
    actions: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: defaultMargin),
        child: GetBuilder<SoulController>(builder: (controller) {
          return controller.profile != null
              ? InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MyProfileScreen()));
                  },
                  child: SoulCircleAvatar(
                    imageUrl: controller.profile!.images.last.image,
                    radius: 15,
                  ),
                )
              : const SizedBox.shrink();
        }),
      )
    ],
  );
}
