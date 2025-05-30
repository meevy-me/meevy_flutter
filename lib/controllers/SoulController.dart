import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soul_date/constants/constants.dart';
import 'package:soul_date/models/SpotifySearch/my_spotify_playlists.dart';
import 'package:soul_date/models/SpotifySearch/spotify_favourite_item.dart';
import 'package:soul_date/models/SpotifySearch/spotify_search.dart'
    as spotifySearch;
import 'package:soul_date/models/favourite_model.dart';
import 'package:soul_date/models/models.dart';
import 'package:soul_date/models/spot_buddy_model.dart';
import 'package:soul_date/screens/Login/login.dart';

import 'package:soul_date/services/network.dart';
import 'package:http/http.dart' as http;
import 'package:soul_date/services/spotify.dart';

import '../models/SpotifySearch/spotify_search.dart';

class SoulController extends GetxController {
  HttpClient client = HttpClient();
  RxList<Match> matches = <Match>[].obs;
  // RxList<List<List<Match>> matches = <List<Match>>[].obs;
  RxList<SpotsView> spots = <SpotsView>[].obs;
  RxList<SpotsView> mySpots = <SpotsView>[].obs;
  RxList<Chat> chats = <Chat>[].obs;
  Profile? profile;
  Map<String, dynamic> keyDb = {};
  List<Friends> friends = [];
  FavouriteTrack? favouriteTrack;
  List<FavouritePlaylist> favouritePlaylist = [];
  Spotify spotify = Spotify();
  Map<int, Profile> profileCache = {};
  SpotifyDetails? currentlyPlayingSong;
  bool loading = false;

  @override
  void onInit() async {
    WidgetsFlutterBinding.ensureInitialized();
    await getProfile();
    registerDevice();
    firebaseSignIn();
    getFriends();
    currentlyPlaying();
    super.onInit();
  }

  Future<Map> currentCountry() async {
    //Returns a map for the country code of the IP
    http.Response res = await client.get('http://ip-api.com/json');
    Map data = jsonDecode(res.body);
    return data;
  }

  void currentlyPlaying() {
    Timer.periodic(const Duration(minutes: 1), (timer) async {
      if (profile != null) {
        SpotifyDetails? data = await spotify.currentlyPlaying();
        currentlyPlayingSong = data;
        if (data != null) {
          FirebaseDatabase.instance
              .ref()
              .child('currentlyPlaying')
              .child(profile!.user.id.toString())
              .set(data.item.toJson());
        }
        update(['currentlyPlaying']);
      }
    });
  }

  void firebaseSignIn() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? firebaseToken = preferences.getString('firebase_token');

    if (firebaseToken != null) {
      FirebaseAuth.instance.signInWithCustomToken(firebaseToken);
      if (FirebaseAuth.instance.currentUser != null) {
        FirebaseAuth.instance.currentUser!.getIdToken(true);
      }
    }
  }

  void registerDevice() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (!preferences.containsKey('fcm_token')) {
      // if (preferences.containsKey('firebase_token')) {
      //   String? firebaseToken = preferences.getString('firebase_token');
      //   if (firebaseToken != null) {
      //     FirebaseAuth.instance.signInWithCustomToken(firebaseToken);
      //   }
      // } else {
      var fireToken = await FirebaseMessaging.instance.getToken();
      //firebase_token
      http.Response response = await client
          .post(registerDeviceUrl, body: {'firebase_token': fireToken!});

      if (response.statusCode <= 210) {
        preferences.setString('fcm_token', fireToken);
      }
    }
  }

  getProfile({bool reset = false}) async {
    var profileBox = await Hive.openBox<Profile>('profile');

    SharedPreferences preferences = await SharedPreferences.getInstance();
    int? profileID = preferences.getInt('profileID');
    if (!reset && profileID != null && profileBox.containsKey(profileID)) {
      profile = profileBox.get(profileID)!;
    } else {
      var res = await client.get(profileMeUrl);

      if (res.statusCode <= 210) {
        profile = Profile.fromJson(json.decode(utf8.decode(res.bodyBytes)));

        preferences.setInt("profileID", profile!.id);
        profileBox.put(profile!.id, profile!);
        update(['profile']);
      } else {
        log(res.body, name: "PROFILE FETCH ERROR");
      }
    }
  }

  Profile? profileInCache(int id) {
    var profile = profileCache[id];
    return profile;
  }

  Future<Profile?> getOtherProfile(int id) async {
    Profile? profile = profileInCache(id);
    if (profile == null) {
      http.Response res = await client.get("$profileUrl$id/");
      if (res.statusCode <= 210) {
        var profile = Profile.fromJson(json.decode(utf8.decode(res.bodyBytes)));
        profileCache[id] = profile;
        return profile;
      }
    } else {
      return profile;
    }
    return null;
  }

  void getFriends() async {
    http.Response response = await client.get(fetchFriendsUrl);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (response.statusCode <= 210) {
      friends = friendsFromJson(response.body);
      int? profileID = prefs.getInt('profileID');
      if (profileID != null) {
        for (Friends friend in friends) {
          FirebaseFirestore.instance
              .collection('userFriends')
              .doc(profileID.toString())
              .collection('friends')
              .doc(friend.friendsProfile.user.id.toString())
              .set(friend.toJson(), SetOptions(merge: true));
        }
      }
      update();
    }
  }

  Future<Friends> getFriend(int id) async {
    http.Response response = await client.get(fetchFriendsUrl + "$id/");
    return Friends.fromJson(json.decode(response.body));
  }

  // setSpotifyToken() async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   if (preferences.getString("spotify_accesstoken") == null) {
  //     // logout();
  //     // Get.to(()  => const LoginScreen());
  //   } else {}
  // }

  Future<void> fetchMatches({RxBool? loading}) async {
    if (loading != null) {
      loading.value = true;
    }
    // await client.get(fetchMakeMatchesUrl);

    http.Response res = await client.get(fetchMatchesUrl);
    if (loading != null) {
      loading.value = false;
    }
    if (res.statusCode <= 210) {
      List<Match> _matches = matchFromJson(utf8.decode(res.bodyBytes));
      _matches.sort(
        (a, b) {
          if (a.matches.length == 1 && b.matches.length == 1) {
            return b.matches.first.matches.length
                .compareTo(a.matches.first.matches.length);
          }

          return b.matches.length.compareTo(a.matches.length);
        },
      );
      matches.value = _matches;
    } else {
      log(res.body, name: "MATCHES");
    }
  }

  Future<void> fetchSpots() async {
    http.Response res = await client.get(fetchSpotsUrl);
    if (res.statusCode <= 210) {
      spots.value = spotsViewFromJson(utf8.decode(res.bodyBytes));
    } else {
      log(res.body, name: "SPOTS ERROR");
    }
  }

  // void fetchChats() async {
  //   http.Response res = await client.get(fetchChatsUrl);
  //   if (res.statusCode <= 210) {
  //     chats.value = chatFromJson(utf8.decode(res.bodyBytes));
  //   } else {
  //     log(res.body, name: "CHATS ERROR");
  //   }
  // }

  Future<List<Friends>> fetchRequests() async {
    http.Response res = await client.get(fetchFriendRequestsUrl);
    if (res.statusCode <= 210) {
      return friendsFromJson(res.body);
    }
    return [];
  }

  Future<bool> acceptRequests(
    Friends friend,
  ) async {
    http.Response res = await client
        .post(acceptRequestUrl, body: {'requestID': friend.id.toString()});
    if (res.statusCode <= 210) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> sendRequest(Map<String, String> body,
      {required BuildContext context}) async {
    http.Response res = await client.post(requestUrl, body: body);
    // print(res.body);
    if (res.statusCode <= 210) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Request has been sent")));

      // Get.back();
      // fetchMatches();
    }
  }

  Future<bool> sendFriendRequest(Profile profile) async {
    http.Response res =
        await client.post(requestUrl, body: {"profile2": profile.id});

    if (res.statusCode <= 210) {
      return true;
    }
    return false;
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
    context.loaderOverlay.show();
    http.Response res = await client.patch('${profileUrl}2/', body);
    context.loaderOverlay.hide();
    if (res.statusCode <= 210) {
      getProfile(reset: true);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Profile Updated.")));
    } else {
      log(res.body, name: "UPDATE PROFILE");
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("An error has occured")));
    }
  }

  Future<Profile?> searchProfile(String id) async {
    String endpoint = baseUrl + 'users/search/user/';
    var res = await client.get(endpoint + "$id/");

    if (res.statusCode <= 210) {}
    return null;
  }

  uploadImage(XFile file, {required BuildContext context}) async {
    loading = true;
    update(['loading']);
    context.loaderOverlay.show();
    http.Response res = await client.post(uploadImageUrl,
        body: {'profile': profile!.id.toString()}, file: file);
    context.loaderOverlay.hide();
    loading = false;
    update(['loading']);
    if (res.statusCode <= 210) {
      getProfile(reset: true);
      Get.back();
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Image uploaded")));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("An error has occcured")));
      log(res.body);
    }
  }

  deleteImage(int id, {required BuildContext context}) async {
    context.loaderOverlay.show();
    var res = await client.delete(picturesUrl + '$id/');
    context.loaderOverlay.hide();
    if (res.statusCode <= 210) {
      getProfile(reset: true);
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
    var profileBox = await Hive.openBox<Profile>('profile');

    profileBox.delete(profile!.id);
    if (await preferences.clear()) {
      Get.offAll(() => const SpotifyLogin());

      Get.delete<SoulController>(force: true);
      // Get.delete<SpotController>();
      // Get.delete<MessageController>();
    }
  }

  Future<bool> updateFavouritesTrack(SpotifyFavouriteItem item,
      {String type = 'track'}) async {
    http.Response res = await client.post(myFavouriteUrl,
        body: {"type": type, "details": jsonEncode(item).toString()});

    if (res.statusCode <= 210) {
      await getFavouriteSong(update: true);
      return true;
    }
    return false;
  }

  updateFavouritesPlaylist(List<SpotifyFavouriteItem?> items) async {
    http.Response res = await client.post(myFavouriteUrl,
        body: {"type": 'playlist', "details": jsonEncode(items).toString()});

    if (res.statusCode <= 210) {
      await getFavouritePlaylist(update: true);
      return true;
    }
    return false;
  }

  Future<FavouriteTrack?> getFavouriteSong({bool update = false}) async {
    if (!update && favouriteTrack != null) {
      return favouriteTrack;
    } else {
      http.Response res = await client.get(myFavouriteUrl);
      if (res.statusCode <= 210) {
        var data = json.decode(res.body) as List;

        if (data.isNotEmpty) {
          var details = data[0];

          favouriteTrack = FavouriteTrack(details['id'],
              spotifySearch.SongItem.fromJson(details['details']));
          return favouriteTrack;
        }
      }
      return null;
    }
  }

  Future<List<FavouritePlaylist>> getFavouritePlaylist(
      {bool update = false}) async {
    if (!update && favouritePlaylist.isNotEmpty) {
      return favouritePlaylist;
    } else {
      http.Response res =
          await client.get(myFavouriteUrl, parameters: {"type": 'playlist'});
      if (res.statusCode <= 210) {
        var data = json.decode(res.body);
        data as List;
        favouritePlaylist = List<FavouritePlaylist>.from(data.map((e) =>
            FavouritePlaylist(e['id'], PlaylistItem.fromJson(e['details']))));
        return favouritePlaylist;
      }
      return [];
    }
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

  Future<List<SpotBuddy>> getSpotBuddies(int spotID) async {
    var response = await client.get(fetchSpotsUrl + "$spotID/buddy/");

    if (response.statusCode <= 210) {
      var json = jsonDecode(response.body);
      var data = json['results'];
      return List.from(data.map((e) => SpotBuddy.fromJson(e)));
    }

    return [];
  }

  Future<bool> linkPhoneNumber() async {
    var res = await client.get(phoneNumberRegisterUrl);
    if (res.statusCode <= 210) {
      return true;
    } else {
      return false;
    }
  }

  Future<List<SpotifyFavouriteItem>> getProfileFavourite(int profileID,
      {String type = 'track'}) async {
    var res = await client.get(userProfileUrl + '$profileID/favourite/',
        parameters: {'type': type}, cache: true);
    if (res.statusCode <= 210) {
      var favourites = jsonDecode(utf8.decode(res.bodyBytes));
      if (type == 'playlist') {
        return List<PlaylistItem>.from(
            favourites.map((e) => PlaylistItem.fromJson(e['details'])));
      } else {
        return List<SongItem>.from(
            favourites.map((e) => SongItem.fromJson(e['details'])));
      }
    }
    return [];
  }
}
