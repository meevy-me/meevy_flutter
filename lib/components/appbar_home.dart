import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:soul_date/screens/messages.dart';

AppBar buildHomeAppBar(BuildContext context) {
  return AppBar(
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    elevation: 0,
    title: SvgPicture.asset(
      'assets/images/logo.svg',
      width: 25,
      height: 25,
    ),
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
          icon: SvgPicture.asset(
            'assets/images/paper.svg',
            height: 25,
          ))
    ],
  );
}
