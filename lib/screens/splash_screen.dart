import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soul_date/controllers/SoulController.dart';
import 'package:soul_date/screens/Login/login.dart';
import 'package:soul_date/screens/home.dart';

import 'datafetch.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    checkLogin();
    super.initState();
  }

  Future<bool> isValidRefresh() async {
    var preferences = await SharedPreferences.getInstance();
    var cacheTime = preferences.getInt('datefetch');
    return cacheTime != null &&
        (DateTime.now().millisecondsSinceEpoch - cacheTime) <
            24 * 60 * 60 * 1000;
  }

  void checkLogin() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    // final service = FlutterBackgroundService();
    if (preferences.getString("token") == null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const SpotifyLogin()),
          (route) => false);
    } else {
      Get.put(SoulController(), permanent: true);

      late Widget destination;
      if (!await isValidRefresh()) {
        destination = const DataFetchPage();
      } else {
        destination = const HomePage();
      }

      // if(preferences.get)

      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => destination),
          (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
          child: Lottie.asset('assets/images/lottie_loading.json', width: 100)),
    );
  }
}
