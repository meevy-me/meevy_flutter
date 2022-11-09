import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:soul_date/components/profile_tab.dart';
import 'package:soul_date/constants/constants.dart';
import 'package:soul_date/controllers/SoulController.dart';
import 'package:soul_date/screens/feedback.dart';

import '../components/buttons.dart';

class MyProfileScreen extends StatelessWidget {
  const MyProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: GetBuilder<SoulController>(builder: (controller) {
        return controller.profile != null
            ? ListView(
                padding: scaffoldPadding,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const FeedbackScreen()));
                          },
                          iconSize: 25,
                          icon: const Icon(
                            Icons.message_rounded,
                            size: 25,
                          )),
                      IconButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) => Dialog(
                                      child: SizedBox(
                                        height: 100,
                                        child: Padding(
                                          padding: scaffoldPadding,
                                          child: Column(
                                            children: [
                                              Text(
                                                "Do you want to logout?",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1,
                                              ),
                                              const SizedBox(
                                                height: defaultMargin,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  InkWell(
                                                    onTap: () => Get.back(),
                                                    child: Row(
                                                      children: [
                                                        const Icon(
                                                          Icons.close,
                                                          color: Colors.grey,
                                                        ),
                                                        const SizedBox(
                                                          width: defaultPadding,
                                                        ),
                                                        Text(
                                                          "Cancel",
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .bodyText2!
                                                              .copyWith(
                                                                  color: Colors
                                                                      .grey),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: defaultMargin * 2,
                                                  ),
                                                  PrimaryButton(
                                                      onPress: () {
                                                        controller.logout();
                                                      },
                                                      text: "Logout")
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ));
                          },
                          iconSize: 25,
                          icon: const Icon(Icons.logout))
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
                        padding:
                            const EdgeInsets.symmetric(vertical: defaultMargin),
                        child: Text(
                          controller.profile!.name,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(
                                  fontWeight: FontWeight.w600, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: defaultMargin),
                    child: ProfileTabView(),
                  )
                ],
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SpinKitRing(color: Theme.of(context).primaryColor),
                    const SizedBox(
                      height: defaultMargin * 2,
                    ),
                    Text("Taking too long, check your internet connection.",
                        style: Theme.of(context).textTheme.caption)
                  ],
                ),
              );
      })),
    );
  }
}
