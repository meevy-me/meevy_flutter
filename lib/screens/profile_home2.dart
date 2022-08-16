import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:soul_date/components/profile_tab.dart';
import 'package:soul_date/constants/constants.dart';
import 'package:soul_date/controllers/SoulController.dart';

class MyProfileScreen extends StatelessWidget {
  const MyProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: GetBuilder<SoulController>(builder: (controller) {
        return ListView(
          padding: scaffoldPadding,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () {},
                    iconSize: 25,
                    icon: SvgPicture.asset(
                      'assets/images/bell.svg',
                      height: 25,
                    )),
                IconButton(
                    onPressed: () {},
                    iconSize: 25,
                    icon: Icon(
                      Icons.settings_outlined,
                      size: 25,
                    ))
              ],
            ),
            Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: CachedNetworkImage(
                    imageUrl: controller.profile!.images.isNotEmpty
                        ? controller.profile!.images.last.image
                        : defaultAvatarUrl,
                    height: 125,
                    width: 120,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: defaultMargin),
                  child: Text(
                    controller.profile!.name,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: defaultMargin),
              child: ProfileTabView(),
            )
          ],
        );
      })),
    );
  }
}
