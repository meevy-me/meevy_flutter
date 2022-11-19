import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:soul_date/controllers/AuthController.dart';
import 'package:soul_date/screens/Login/onboarding.dart';
import 'package:soul_date/screens/Login/onboarding2.dart';

import '../../constants/constants.dart';
import 'onboarding1.dart';

class SpotifyLogin extends StatefulWidget {
  const SpotifyLogin({Key? key}) : super(key: key);

  @override
  State<SpotifyLogin> createState() => _SpotifyLoginState();
}

class _SpotifyLoginState extends State<SpotifyLogin> {
  PageController pageController = PageController();
  final SpotifyController spotifyController = Get.put(SpotifyController());

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        children: [
          Page1(
            onPress: () {
              pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut);
            },
          ),
          Page2(
              onPress: () async {
                spotifyController.login(context);
              },
              onBack: () => pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut)),
        ],
      ),
    );
  }
}
