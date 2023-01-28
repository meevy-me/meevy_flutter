import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soul_date/components/bottom_navigation.dart';
import 'package:soul_date/controllers/MessagesController.dart';
import 'package:soul_date/controllers/SoulController.dart';
import 'package:soul_date/controllers/SpotController.dart';
import 'package:soul_date/screens/Chat/messages.dart';
import 'package:soul_date/screens/discover.dart';
import 'package:soul_date/screens/home/vinyls.dart';
import 'package:soul_date/screens/Playlists/playlists.dart';
import 'package:soul_date/screens/profile_home.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
    this.initialIndex = 0,
  }) : super(key: key);
  final int initialIndex;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  SoulController controller = Get.find<SoulController>();
  final SpotController spotController = Get.put(SpotController());
  final MessageController msgController = Get.put(MessageController());
  final PageController _pageController = PageController();
  int selectedIndex = 0;

  List<Widget> pages = const [
    DiscoverPage(),
    VinylsPage(),
    PlaylistsPage(),
    MessagesPage(),
    MyProfileScreen()
  ];
  @override
  void initState() {
    setState(() {
      selectedIndex = widget.initialIndex;
    });
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
          activeIndex: selectedIndex,
          onTap: (index) {
            setState(() {
              selectedIndex = index;
              _pageController.animateToPage(selectedIndex,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.fastOutSlowIn);
            });
          },
        ),
        body: PageView(
          // physics: const NeverScrollableScrollPhysics(),
          children: pages,
          controller: _pageController,
          onPageChanged: (value) {
            setState(() {
              selectedIndex = value;
            });
          },
        ));
  }
}
