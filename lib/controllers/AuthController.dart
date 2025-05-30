import 'dart:convert';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soul_date/constants/constants.dart';
import 'package:http/http.dart' as http;
import 'package:soul_date/screens/datafetch.dart';
import 'package:soul_date/screens/password.dart';
import 'package:soul_date/screens/profile_create.dart';
import 'package:soul_date/screens/reset_code_Screen.dart';
import 'package:soul_date/services/analytics.dart';
import 'package:soul_date/services/network.dart';
import 'package:soul_date/services/notifications.dart';
import 'package:soul_date/services/spotify.dart';

class SpotifyController extends GetxController {
  Spotify spotify = Spotify();
  HttpClient client = HttpClient();
  String errors = "";
  Future<Spotify?> spotifyLogin() async {
    final Uri url = Uri.https('accounts.spotify.com', '/authorize', {
      'response_type': 'code',
      'client_id': clientId,
      'redirect_uri': 'meevy:/',
      'show_dialog': 'true',
      'scope':
          'user-read-private user-read-recently-played playlist-read-private user-library-read user-top-read user-modify-playback-state user-read-currently-playing'
    });
    try {
      final result = await FlutterWebAuth.authenticate(
          url: url.toString(), callbackUrlScheme: 'meevy');

      final code = Uri.parse(result).queryParameters['code'];
      Map? spotifyTokens = await spotify.getTokens(code!);
      if (spotifyTokens != null) {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.setString(
            "spotify_accesstoken", spotifyTokens['access_token']);
        preferences.setString(
            "spotify_refreshtoken", spotifyTokens['refresh_token']);

        spotify.currentUser = await spotify.getCurrentUser();
      }
    } catch (e) {
      log(e.toString());
      Analytics.log_error('Web Auth Error', {'error': e.toString()});
    }

    return spotify;
  }

  Future isRegistered(BuildContext context) async {
    if (spotify.currentUser != null) {
      http.Response response = await client.get(checkUserUrl,
          useToken: false, parameters: {'spotifyID': spotify.currentUser!.id});
      if (response.statusCode <= 210) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("SUCCESS")));
        Get.to(() => PasswordScreen(
            user: spotify.currentUser!,
            registered: !jsonDecode(response.body)));
      } else {
        log(response.body, name: "API-ERROR");
        _showSnackBar("An error has occured", context);
      }
    } else {
      _showSnackBar("Something is wrong :/", context);
      Analytics.log_error("Login Error", {'error': 'Spotify user is null'});
    }
  }

  void login(context) async {
    await spotifyLogin();
    await isRegistered(context);
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
    if (context != null) {
      context.loaderOverlay.show();
    }
    try {
      http.Response response = await client.post(endpoint, body: body);
      if (response.statusCode <= 210) {
        Map json = jsonDecode(response.body);
        SharedPreferences preferences = await SharedPreferences.getInstance();
        String firebaseCustomToken = json['firebase_token'];
        Map<String, dynamic> firebaseAuthDetails = json['firebase'];

        String firebaseAccessToken = firebaseAuthDetails['idToken'];
        String firebaseRefreshToken = firebaseAuthDetails['refreshToken'];
        preferences.setString('token', json['token']);
        preferences.setString('firebase_access_token', firebaseAccessToken);
        preferences.setString('firebase_refresh_token', firebaseRefreshToken);
        preferences.setString('firebase_custom_token', firebaseCustomToken);

        await FirebaseAuth.instance.signInWithCustomToken(firebaseCustomToken);

        if (FirebaseAuth.instance.currentUser != null) {
          FirebaseAuth.instance.currentUser!.getIdToken(true);
        }

        if (body.containsKey('email')) {
          if (context != null) {
            _showSnackBar("Success. Create Profile", context);
          }
          Get.to(() => const ProfileCreatePage());
        } else {
          if (json['profile'] != null) {
            if (context != null) {
              _showSnackBar("Success. Welcome back", context);
            }

            Get.to(() => const DataFetchPage());
          } else {
            if (context != null) {
              _showSnackBar("Success. Create Profile", context);
            }

            Get.to(() => const ProfileCreatePage());
          }
        }
      } else {
        if (context != null) {
          context.loaderOverlay.hide();
        }
        log(response.body, name: "LOGIN ERROR");
        errors = json.decode(response.body);
        update(["Login_errors"]);
      }
    } catch (e) {
      if (context != null) {
        context.loaderOverlay.hide();
        showSnackBar(context, "An error has occured");
      }
    }
  }

  void createProfile(Map<String, String> body,
      {bool update = false, BuildContext? context}) async {
    if (context != null) {
      context.loaderOverlay.show();
    }
    http.Response res = await client.post(profileUrl, body: body);
    if (context != null) {
      context.loaderOverlay.hide();
    }
    if (res.statusCode <= 210) {
      if (context != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(update
                ? "Profile Updated Successfully"
                : "Profile created successfully")));
      }
      Get.to(() => const DataFetchPage());
    } else {
      log(res.body, name: "API ERROR");
    }
  }

  resetPasswordEmail(Map<String, String> body,
      {required BuildContext context}) async {
    body['spotifyID'] = spotify.currentUser!.id;
    http.Response response =
        await client.post(resetPasswordUrl + 'email/', body: body);

    if (response.statusCode <= 210) {
      Get.to(() => ResetCodeScreen(
            email: body['email']!,
          ));
    } else {
      errors = json.decode(response.body);
      showSnackBar(context, response.body);
      log(response.body, name: "EMAIL RESET");
    }
  }

  Future<String> validatResetCode(String pin,
      {required BuildContext context}) async {
    Map<String, String> body = {'spotifyID': spotify.currentUser!.id};
    body['code'] = pin;

    http.Response response =
        await client.post(resetPasswordUrl + 'validate/', body: body);
    if (response.statusCode <= 210) {
      return json.decode(response.body)['grant_token'];
    } else {
      showSnackBar(context, response.body);
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
