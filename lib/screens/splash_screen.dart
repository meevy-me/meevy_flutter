import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soul_date/controllers/SoulController.dart';
import 'package:soul_date/screens/home.dart';
import 'package:soul_date/screens/login.dart';
import 'package:soul_date/services/store.dart';

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

  void checkLogin() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    late LocalStore store;
    // final service = FlutterBackgroundService();
    if (preferences.getString("spotify_accesstoken") == null) {
      Get.offAll(() => const LoginScreen());
    } else {
      try {
        store = await LocalStore.init();
      } catch (e) {
        store = await LocalStore.attach();
      }
      Get.put(SoulController(store), permanent: true);

      Get.offAll(() => HomePage(
            store: store,
          ));
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
