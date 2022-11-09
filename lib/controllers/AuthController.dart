import 'dart:convert';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soul_date/constants/constants.dart';
import 'package:http/http.dart' as http;
import 'package:soul_date/screens/datafetch.dart';
import 'package:soul_date/screens/profile.dart';
import 'package:soul_date/screens/reset_code_Screen.dart';
import 'package:soul_date/screens/splash_screen.dart';
import 'package:soul_date/services/network.dart';
import 'package:soul_date/services/spotify.dart';

class SpotifyController extends GetxController {
  Spotify spotify = Spotify();
  HttpClient client = HttpClient();
  String errors = "";
  Future<Spotify?> spotifyLogin() async {
    final Uri url = Uri.https('accounts.spotify.com', '/authorize', {
      'response_type': 'code',
      'client_id': clientId,
      'redirect_uri': 'souldate:/',
      'show_dialog': 'true',
      'scope':
          'user-read-private user-read-recently-played playlist-read-private user-library-read user-top-read user-modify-playback-state user-read-currently-playing'
    });

    final result = await FlutterWebAuth.authenticate(
        url: url.toString(), callbackUrlScheme: 'souldate');

    final code = Uri.parse(result).queryParameters['code'];
    Map? spotifyTokens = await spotify.getTokens(code!);
    if (spotifyTokens != null) {
      spotify.accessToken = spotifyTokens['access_token'];
      spotify.refreshToken = spotifyTokens['refresh_token'];

      spotify.currentUser =
          await spotify.getCurrentUser(accessToken: spotify.accessToken);
    }

    return spotify;
  }

  Future<bool> isRegistered() async {
    if (spotify.currentUser != null) {
      http.Response response = await client.get(checkUserUrl,
          useToken: false, parameters: {'spotifyID': spotify.currentUser!.id});
      if (response.statusCode <= 210) {
        return jsonDecode(response.body);
      } else {
        log(response.body, name: "API-ERROR");
        throw "An error has occured";
      }
    } else {
      throw "Spotify is null";
    }
  }

  void _showSnackBar(String text, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  authenticate(Map<String, String> body, {BuildContext? context}) async {
    body['spotifyID'] = spotify.currentUser!.id;
    late String endpoint;
    if (body.containsKey('email')) {
      endpoint = registerUrl;
    } else {
      endpoint = loginUrl;
    }
    http.Response response = await client.post(endpoint, body: body);
    if (response.statusCode <= 210) {
      Map json = jsonDecode(response.body);
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String firebaseToken = json['firebase_token'];
      preferences.setString('token', json['token']);
      preferences.setString('firebase_token', json['firebase_token']);
      preferences.setString('spotify_accesstoken', spotify.accessToken);
      preferences.setString('spotify_refreshtoken', spotify.refreshToken);
      await FirebaseAuth.instance.signInWithCustomToken(firebaseToken);

      if (body.containsKey('email')) {
        if (context != null) _showSnackBar("Success. Create Profile", context);
        Get.to(() => const ProfileCreatePage());
      } else {
        if (json['profile'] != null) {
          if (context != null) _showSnackBar("Success. Welcome back", context);

          Get.to(() => DataFetchPage(
              accessToken: spotify.accessToken,
              refreshToken: spotify.refreshToken));
        } else {
          if (context != null) {
            _showSnackBar("Success. Create Profile", context);
          }

          Get.to(() => const ProfileCreatePage());
        }
      }
    } else {
      log(response.body, name: "LOGIN ERROR");
      errors = json.decode(response.body);
      update(["Login_errors"]);
    }
  }

  void createProfile(Map<String, String> body,
      {bool update = false, BuildContext? context}) async {
    http.Response res = await client.post(profileUrl, body: body);
    if (res.statusCode <= 210) {
      if (context != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(update
                ? "Profile Updated Successfully"
                : "Profile created successfully")));
      }
      Get.to(() => DataFetchPage(
          accessToken: spotify.accessToken,
          refreshToken: spotify.refreshToken));
    } else {
      log(res.body, name: "API ERROR");
    }
  }

  void fetchData() async {
    http.Response response = await client.post(fetchDataUrl, body: {
      'access_token': spotify.accessToken,
      'refresh_token': spotify.refreshToken
    });
    if (response.statusCode <= 210) {
      Get.to(() => const SplashScreen());
    } else if (response.statusCode <= 500) {
      Get.to(() => const SplashScreen());
    } else {
      log(response.body, name: "ERROR");
    }
  }

  resetPasswordEmail(Map<String, String> body) async {
    body['spotifyID'] = spotify.currentUser!.id;
    http.Response response =
        await client.post(resetPasswordUrl + 'email/', body: body);
    if (response.statusCode <= 210) {
      Get.to(() => ResetCodeScreen(
            email: body['email']!,
          ));
    } else {
      errors = json.decode(response.body);
      log(response.body, name: "EMAIL RESET");
    }
  }

  Future<String> validatResetCode(String pin) async {
    Map<String, String> body = {'spotifyID': spotify.currentUser!.id};
    body['code'] = pin;

    http.Response response =
        await client.post(resetPasswordUrl + 'validate/', body: body);
    if (response.statusCode <= 210) {
      return json.decode(response.body)['grant_token'];
    } else {
      return "error";
    }
  }

  Future<String?> resetPassword(String grant, Map<String, String> body) async {
    http.Response response =
        await client.post(resetPasswordUrl + '$grant/', body: body);

    if (response.statusCode <= 210) {
      return null;
    } else {
      return "Your Password Reset duration has expired";
    }
  }
}
