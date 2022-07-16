import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soul_date/components/bottom_navigation.dart';
import 'package:soul_date/controllers/MessagesController.dart';
import 'package:soul_date/controllers/SoulController.dart';
import 'package:soul_date/controllers/SpotController.dart';
import 'package:soul_date/screens/match.dart';

import 'profile_home.dart';
import 'settings_home.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final SoulController controller = Get.put(SoulController());
  final SpotController spotController = Get.put(SpotController());
  final MessageController msgController = Get.put(MessageController());
  PageController _pageController = PageController();
  int selectedIndex = 0;
  List<Widget> pages = const [MatchScreen(), ProfileHome(), SettingsHome()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SoulBottomNavigationBar(
        onTap: (index) {
          setState(() {
            _pageController.animateToPage(index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut);
            selectedIndex = index;
          });
        },
      ),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        children: pages,
      ),
    );
  }
}
