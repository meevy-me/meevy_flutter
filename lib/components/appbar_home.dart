import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:soul_date/controllers/FirebaseController.dart';
import 'package:soul_date/screens/messages.dart';

import 'logo.dart';

AppBar buildHomeAppBar(BuildContext context) {
  return AppBar(
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    elevation: 0,
    title: const Logo(),
    centerTitle: true,
    // leading: IconButton(
    //   onPressed: () {},
    //   icon: SvgPicture.asset(
    //     'assets/images/musicbars.svg',
    //     height: 25,
    //     width: 25,
    //   ),
    // ),
    actions: [
      IconButton(
          onPressed: () {
            Get.to(() => const MessagesPage());
          },
          icon: Stack(
            children: [
              SvgPicture.asset(
                'assets/images/paper.svg',
                height: 25,
              ),
              GetBuilder<FirebaseController>(
                  id: 'hasChat',
                  builder: (controller) {
                    return Positioned(
                      top: 0,
                      right: 0,
                      child: Visibility(
                        visible: controller.hasChat,
                        child: Container(
                            height: 8,
                            width: 8,
                            decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                shape: BoxShape.circle)),
                      ),
                    );
                  })
            ],
          ))
    ],
  );
}
