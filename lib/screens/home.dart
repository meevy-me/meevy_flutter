import 'dart:async';

import 'package:clipboard_listener/clipboard_listener.dart';
import 'package:clipboard_monitor/clipboard_monitor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'package:soul_date/screens/send_spot_screen.dart';

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

  bool _showModal = false;
  String link = '';

  List<Widget> pages = const [
    DiscoverPage(),
    VinylsPage(),
    PlaylistsPage(),
    MessagesPage(),
    MyProfileScreen()
  ];
  @override
  void initState() {
    Timer.periodic(const Duration(seconds: 2), (timer) {
      _getClipboardData();
    });
    setState(() {
      selectedIndex = widget.initialIndex;
    });
    super.initState();
  }

  void _getClipboardData() {
    Clipboard.getData('text/plain').then((data) {
      if (data != null && data.text != null) {
        RegExp regExp = RegExp(
            r'https:\/\/open\.spotify\.com\/(track|playlist)\/[a-zA-Z0-9]*(\?si=|\?si|)');
        if (regExp.hasMatch(data.text!)) {
          // open modal
          if (link != data.text!) {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ShareDataScreen(
                sharedText: data.text,
              ),
            ));
            link = data.text!;
          }

          setState(() {});
        }
      }
    });
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
          physics: const NeverScrollableScrollPhysics(),
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
