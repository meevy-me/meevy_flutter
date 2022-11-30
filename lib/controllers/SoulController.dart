import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cron/cron.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soul_date/constants/constants.dart';
import 'package:soul_date/models/SpotifySearch/my_spotify_playlists.dart';
import 'package:soul_date/models/SpotifySearch/spotify_favourite_item.dart';
import 'package:soul_date/models/SpotifySearch/spotify_search.dart'
    as spotifySearch;
import 'package:soul_date/models/favourite_model.dart';
import 'package:soul_date/models/models.dart';
import 'package:soul_date/screens/Login/login.dart';

import 'package:soul_date/services/network.dart';
import 'package:http/http.dart' as http;
import 'package:soul_date/services/spotify.dart';

class SoulController extends GetxController {
  HttpClient client = HttpClient();
  RxList<Match> matches = <Match>[].obs;
  RxList<SpotsView> spots = <SpotsView>[].obs;
  RxList<SpotsView> mySpots = <SpotsView>[].obs;
  RxList<Chat> chats = <Chat>[].obs;
  Profile? profile;
  Map<String, dynamic> keyDb = {};
  List<Friends> friends = [];
  FavouriteTrack? favouriteTrack;
  List<FavouritePlaylist?> favouritePlaylist = [];
  Spotify spotify = Spotify();
  RxList<Friends> friendRequest = <Friends>[].obs;

  Cron cron = Cron();

  @override
  void onInit() async {
    WidgetsFlutterBinding.ensureInitialized();
    setSpotifyToken();
    getFriends();
    registerDevice();
    fetchMatches();
    getProfile();
    currentlyPlaying();
    super.onInit();
  }

  currentlyPlaying() {
    Timer.periodic(const Duration(minutes: 5), (timer) async {
      if (profile != null) {
        SpotifyDetails? data =
            await spotify.fetchCurrentPlaying(navigate: false);
        FirebaseDatabase.instance
            .ref()
            .child('currentlyPlaying')
            .child(profile!.user.id.toString())
            .set(data?.item.toJson());
      }
    });
  }

  registerDevice() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (preferences.containsKey('firebase_token')) {
      String? firebase_token = preferences.getString('firebase_token');
      if (firebase_token != null) {
        FirebaseAuth.instance.signInWithCustomToken(firebase_token);
      }
    } else {
      var fireToken = await FirebaseMessaging.instance.getToken();
      //firebase_token
      http.Response response = await client
          .post(registerDeviceUrl, body: {'firebase_token': fireToken!});
      if (response.statusCode <= 210) {
        preferences.setBool('firebaseRegistered', true);
      }
    }
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

  void getFriends() async {
    http.Response response = await client.get(fetchFriendsUrl);
    if (response.statusCode <= 210) {
      friends = friendsFromJson(response.body);
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
    await client.get(fetchMakeMatchesUrl);

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
    } else {
      log(res.body);
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
      Get.offAll(() => const SpotifyLogin());
      Get.delete<SoulController>();
      // Get.delete<SpotController>();
      // Get.delete<MessageController>();
    }
  }

  Future<bool> updateFavouritesTrack(SpotifyFavouriteItem item,
      {String type = 'track'}) async {
    http.Response res = await client.post(myFavouriteUrl,
        body: {"type": type, "details": jsonEncode(item).toString()});
    if (res.statusCode <= 210) {
      return true;
    }
    return false;
  }

  updateFavouritesPlaylist(List<SpotifyFavouriteItem?> items) async {
    http.Response res = await client.post(myFavouriteUrl,
        body: {"type": 'playlist', "details": jsonEncode(items).toString()});

    if (res.statusCode <= 210) {
      getFavouritePlaylist();
      return true;
    }
    return false;
  }

  Future<FavouriteTrack?> getFavouriteSong() async {
    http.Response res = await client.get(myFavouriteUrl);
    if (res.statusCode <= 210) {
      Map<String, dynamic> data = json.decode(res.body)[0];
      favouriteTrack = FavouriteTrack(
          data['id'], spotifySearch.SongItem.fromJson(data['details']));

      update();
    }
    return null;
  }

  Future<FavouritePlaylist?> getFavouritePlaylist() async {
    http.Response res =
        await client.get(myFavouriteUrl, parameters: {"type": 'playlist'});
    if (res.statusCode <= 210) {
      var data = json.decode(res.body);
      data as List;
      favouritePlaylist = List<FavouritePlaylist>.from(data.map((e) =>
          FavouritePlaylist(e['id'], PlaylistItem.fromJson(e['details']))));
      update();
    }
    return null;
  }

  Future<FavouriteTrack?> getFriendFavouriteTrack(int id) async {
    http.Response res =
        await client.get("${baseUrl}socials/friend/$id/favourite/");

    if (res.statusCode <= 210) {
      try {
        Map<String, dynamic> data = json.decode(res.body)[0];
        favouriteTrack = FavouriteTrack(
            data['id'], spotifySearch.SongItem.fromJson(data['details']));

        return favouriteTrack;
      } catch (e) {
        return null;
      }
    } else {
      return null;
    }
  }

  Future<List<FavouritePlaylist?>?> getFriendFavouritePlaylist(int id) async {
    http.Response res = await client.get(
        "${baseUrl}socials/friend/$id/favourite/",
        parameters: {"type": 'playlist'});
    if (res.statusCode <= 210) {
      var data = json.decode(res.body);
      data as List;
      favouritePlaylist = List<FavouritePlaylist>.from(data.map((e) =>
          FavouritePlaylist(e['id'], PlaylistItem.fromJson(e['details']))));
      update();
      return favouritePlaylist;
    }
    return null;
  }

  feedbackPush(List comments) {
    final CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('feedback');
    Map<String, dynamic> data = {'profile': profile!.id, 'comments': comments};
    collectionReference.add(data);
  }

  Future<bool> isFriendRequested(Profile profile) async {
    http.Response response =
        await client.get(friendCheckUrl + "${profile.id}/");
    if (response.statusCode <= 210) {
      return jsonDecode(response.body);
    }
    return false;
  }

  Future<bool> sendNotification(Profile profile, String message) async {
    http.Response response = await client.post(notifyUrl,
        body: {'receiver': profile.id.toString(), 'message': message});

    if (response.statusCode <= 210) {
      return true;
    }
    return false;
  }
}
