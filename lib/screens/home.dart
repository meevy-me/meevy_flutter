import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soul_date/components/bottom_navigation.dart';
import 'package:soul_date/controllers/FirebaseController.dart';
import 'package:soul_date/controllers/MessagesController.dart';
import 'package:soul_date/controllers/SoulController.dart';
import 'package:soul_date/controllers/SpotController.dart';
import 'package:soul_date/screens/match.dart';
import 'package:soul_date/screens/profile_home.dart';
import 'package:soul_date/services/store.dart';

import 'settings_home.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.store}) : super(key: key);
  final LocalStore store;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  SoulController controller = Get.find<SoulController>();
  final SpotController spotController = Get.put(SpotController());
  final FirebaseController firebaseController = Get.put(FirebaseController());
  final MessageController msgController = Get.put(MessageController());
  final PageController _pageController = PageController();
  int selectedIndex = 0;
  List<Widget> pages = const [MatchScreen(), MyProfileScreen(), SettingsHome()];
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

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
