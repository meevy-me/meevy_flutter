import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soul_date/constants/constants.dart';
import 'package:soul_date/models/chat_model.dart';
import 'package:soul_date/models/friend_model.dart';
import 'package:soul_date/models/match_model.dart';
import 'package:soul_date/models/profile_model.dart';
import 'package:soul_date/models/spots.dart';
import 'package:soul_date/objectbox.g.dart';
import 'package:soul_date/screens/login.dart';
import 'package:soul_date/services/background_handle.dart';
import 'package:soul_date/services/network.dart';
import 'package:http/http.dart' as http;
import 'package:soul_date/services/spotify.dart';
import 'package:soul_date/services/store.dart';

class SoulController extends GetxController {
  HttpClient client = HttpClient();
  RxList<Match> matches = <Match>[].obs;
  RxList<SpotsView> spots = <SpotsView>[].obs;
  RxList<SpotsView> mySpots = <SpotsView>[].obs;
  RxList<Chat> chats = <Chat>[].obs;
  Profile? profile;
  // RxList<Profile> profile = <Profile>[].obs;
  Spotify spotify = Spotify();
  RxList<Friends> friendRequest = <Friends>[].obs;
  final service = FlutterBackgroundService();
  final LocalStore store;

  SoulController(this.store);

  @override
  void onInit() async {
    WidgetsFlutterBinding.ensureInitialized();
    // if (!await service.isRunning()) {
    //   await initializeService(store);
    // }
    setSpotifyToken();
    fetchMatches();
    getProfile();
    super.onInit();
  }

  getProfile() async {
    var res = await client.get(profileMeUrl);

    if (res.statusCode <= 210) {
      profile = Profile.fromJson(json.decode(utf8.decode(res.bodyBytes)));

      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setInt("profileID", profile!.id);
      update(['profile']);
    } else {
      log(res.body, name: "PROFILE FETCH ERROR");
    }
  }

  setSpotifyToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (preferences.getString("spotify_accesstoken") == null) {
      // logout();
      // Get.to(()  => const LoginScreen());
    } else {
      spotify.accessToken = preferences.getString("spotify_accesstoken")!;
      spotify.accessToken = preferences.getString("spotify_refreshtoken")!;
    }
  }

  void fetchMatches() async {
    http.Response res = await client.get(fetchMatchesUrl);
    if (res.statusCode <= 210) {
      matches.value = matchFromJson(utf8.decode(res.bodyBytes));
    } else {
      log(res.body, name: "MATCHES");
    }
  }

  void fetchSpots() async {
    http.Response res = await client.get(fetchSpotsUrl);
    if (res.statusCode <= 210) {
      spots.value = spotsViewFromJson(utf8.decode(res.bodyBytes));
    } else {
      log(res.body, name: "SPOTS ERROR");
    }
  }

  void fetchChats() async {
    http.Response res = await client.get(fetchChatsUrl);
    if (res.statusCode <= 210) {
      chats.value = chatFromJson(utf8.decode(res.bodyBytes));
    } else {
      log(res.body, name: "CHATS ERROR");
    }
  }

  fetchRequests() async {
    http.Response res = await client.get(fetchFriendRequestsUrl);
    if (res.statusCode <= 210) {
      friendRequest.value = friendsFromJson(res.body);
    }
  }

  acceptRequests(Friends friend, {required BuildContext context}) async {
    http.Response res = await client
        .post(acceptRequestUrl, body: {'requestID': friend.id.toString()});
    if (res.statusCode <= 210) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Friend Request accepted")));
      friendRequest.remove(friend);
      fetchRequests();
    }
  }

  void sendRequest(Map<String, String> body,
      {required BuildContext context}) async {
    http.Response res = await client.post(requestUrl, body: body);
    if (res.statusCode <= 210) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Request has been sent")));

      Get.back();
      fetchMatches();
    }
  }

  Future<SpotsView?> fetchMySpot() async {
    http.Response res = await client.get(fetchSpotsMeUrl);
    if (res.statusCode <= 210) {
      var spot = spotsViewFromJson(utf8.decode(res.bodyBytes));
      mySpots.value = spot;
      return spot.first;
    } else {
      log(res.body);
      return null;
    }
  }

  void updateProfile(Map body, {required BuildContext context}) async {
    http.Response res = await client.patch('${profileUrl}1/', body);
    if (res.statusCode <= 210) {
      getProfile();
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Profile Updated")));
    } else {
      log(res.body, name: "UPDATE PROFILE");
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("An error has occured")));
    }
  }

  Future<Profile?> searchProfile(String id) async {
    String endpoint = baseUrl + 'users/search/user/';
    var res = await client.get(endpoint + "$id/");

    if (res.statusCode <= 210) {
      return Profile.fromJson(json.decode(utf8.decode(res.bodyBytes)));
    }
    return null;
  }

  uploadImage(XFile file, {required BuildContext context}) async {
    http.Response res = await client.post(uploadImageUrl,
        body: {'profile': profile!.id.toString()}, file: file);
    if (res.statusCode <= 210) {
      getProfile();
      Get.back();
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Image uploaded")));
    } else {
      log(res.body);
    }
  }

  deleteImage(int id, {required BuildContext context}) async {
    var res = await client.delete(picturesUrl + '$id/');
    if (res.statusCode <= 210) {
      var index = profile!.images.indexWhere((element) => element.id == id);
      profile!.images.removeAt(index);
      Get.back();
      update();
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Image has been deleted")));
    } else {
      log(res.body, name: "IMAGE DELETE");
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("An error has occcured")));
    }
  }

  void logout() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    if (await preferences.clear()) {
      store.store.close();
      service.invoke('stopService');
      LocalStore.delete();
      Get.offAll(() => const LoginScreen());
      Get.delete<SoulController>();
      // Get.delete<SpotController>();
      // Get.delete<MessageController>();
    }
  }

  @override
  void dispose() {
    // service.invoke('stopService', {});
    super.dispose();
  }
}
