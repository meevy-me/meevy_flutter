import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soul_date/screens/home.dart';
import 'package:soul_date/screens/login.dart';
import 'package:soul_date/services/background.dart';
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
    if (preferences.getString("spotify_accesstoken") == null) {
      Get.offAll(() => const LoginScreen());
    } else {
      // LocalStore.init();

      WidgetsFlutterBinding.ensureInitialized();
      await initializeService();
      Get.offAll(() => const HomePage());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/images/splash_icon.png',
          width: 200,
        ),
      ),
    );
  }
}
