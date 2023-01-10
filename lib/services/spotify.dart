import 'dart:convert';
import 'dart:developer';

import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soul_date/constants/constants.dart';
import 'package:soul_date/models/Spotify/album_model.dart';
import 'package:soul_date/models/Spotify/artist_model.dart';
import 'package:soul_date/models/Spotify/base_model.dart';
import 'package:soul_date/models/Spotify/playlist_model.dart';
import 'package:soul_date/models/Spotify/track_model.dart';
import 'package:soul_date/models/Spotify/user_model.dart';
import 'package:soul_date/models/SpotifySearch/my_spotify_playlists.dart';
import 'package:soul_date/models/SpotifySearch/spotify_search.dart';
import 'package:soul_date/models/spotify_spot_details.dart' as Spot;
import 'package:soul_date/models/spotifyuser.dart';
import 'package:soul_date/screens/my_spot_screen.dart';
import 'package:soul_date/services/analytics.dart';
import 'package:soul_date/services/network.dart';
import 'package:soul_date/services/notifications.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Spotify {
  late String accessToken;
  late String refreshToken;
  SpotifyUser? currentUser;
  Spotify() {
    getCurrentUser();
  }

  SpotifyClient client = SpotifyClient();

  String get _clientSecret {
    return "edbd307b1b064e91a8974698bb9b0a8f";
  }

  Future<Map?> getTokens(String code) async {
    http.Response res =
        await client.client.post(spotifyTokenEndpoint, useToken: false, body: {
      'code': code,
      'clientId': clientId,
      'grant_type': 'authorization_code',
      'redirect_uri': 'souldate:/'
    }, headers: {
      'Content-type': 'application/x-www-form-urlencoded',
      'Authorization': client.basicAuth(clientId, _clientSecret)
    });

    if (res.statusCode <= 210) {
      return jsonDecode(res.body);
    } else {
      log(res.body, name: "SPOTIFY ERROR");
    }
    return null;
  }

  void setTokens(String accessToken, String refreshToken) async {
    this.accessToken = accessToken;
    this.refreshToken = refreshToken;
  }

  Future<Spot.SpotifyDetails?> currentlyPlaying() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    accessToken = preferences.getString("spotify_accesstoken")!;
    refreshToken = preferences.getString("spotify_refreshtoken")!;
    http.Response res = await client.get(
      playerUrl,
    );

    if (res.statusCode <= 210 && res.body.isNotEmpty) {
      return Spot.SpotifyDetails.fromJson(json.decode(res.body));
    } else {
      log(res.body, name: "CURRENTLY PLAYING");
    }
    return null;
  }

  Future<Spot.SpotifyDetails?> fetchCurrentPlaying(
      {BuildContext? context, navigate = true}) async {
    http.Response res = await client.get(
      playerUrl,
    );

    if (res.statusCode <= 210 && res.body.isNotEmpty) {
      var detail = Spot.SpotifyDetails.fromJson(json.decode(res.body));
      if (navigate) {
        Get.to(() => MySpotScreen(details: detail));
      }
      return detail;
    } else if (res.statusCode <= 210 && res.body.isEmpty) {
      if (context != null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("You're not playing any song currently.")));
      }
    } else {
      Analytics.log_error("Spot Error", {'error': res.body});
    }
    return null;
  }

  playTrack(String uri, {required BuildContext context}) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    accessToken = preferences.getString("spotify_accesstoken")!;
    refreshToken = preferences.getString("spotify_refreshtoken")!;
    http.Response res = await client.post(
      queueUrl,
      body: {},
      parameters: {"uri": uri},
      // useToken: false,
    );
    if (res.statusCode <= 210) {
      showSnackBar(context, "Song added to your queue");
    } else if (res.statusCode == 404) {
      showSnackBar(context, "Your spotify player is not active");
    } else if (res.statusCode >= 500) {
      showSnackBar(context, "Spotify Error");
    } else {
      showSnackBar(context, "An error has occured");
      log(res.body, name: "SPOTIFY ERROR");
    }
  }

  Future<SpotifyData?> getItem(String key, String id) async {
    late String endpoint;
    if (key == 'track') {
      endpoint = "https://api.spotify.com/v1/tracks/";
    } else if (key == 'playlist') {
      endpoint = "https://api.spotify.com/v1/playlists/";
    } else if (key == 'album') {
      endpoint = "https://api.spotify.com/v1/albums/";
    } else if (key == 'artist') {
      endpoint = "https://api.spotify.com/v1/artists/";
    } else {
      endpoint = "https://api.spotify.com/v1/users/";
    }

    http.Response res = await client.get("$endpoint$id");

    if (res.statusCode <= 210) {
      Map<String, dynamic> data = json.decode(res.body);
      if (key == 'track') {
        return SpotifyTrack.fromJson(data);
      } else if (key == 'album') {
        return SpotifyAlbum.fromJson(data);
      } else if (key == 'playlist') {
        return SpotifyPlaylist.fromJson(data);
      } else if (key == 'artist') {
        return SpotifyArtist.fromJson(data);
      } else if (key == 'user') {
        return Spotifyuser.fromJson(data);
      }
    } else {
      log(res.body, name: "SPOTIFY ERROR");
    }
    return null;
  }

  Future<SpotifyUser?> getCurrentUser({String? accessToken}) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    late String? spotToken;

    spotToken = accessToken ?? preferences.getString("spotify_accesstoken");

    http.Response res = await client.get(
      spotifyMeEndpoint,
    );

    if (res.statusCode <= 210) {
      var currentSpot = SpotifyUser.fromJson(jsonDecode(res.body));
      currentUser = currentSpot;
      return currentSpot;
    } else {
      log(res.body, name: "SPOTIFY ERROR");
    }
    return null;
  }

  Future<http.Response> _searchItem(String query, {String? type}) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var spotToken = preferences.getString("spotify_accesstoken");

    http.Response res = await client.get(spotifySearchEndpoint,
        parameters: {'q': query, 'type': type ?? 'track', 'limit': '5'});

    return res;
  }

  Future<http.Response> _getPlaylists({String? nextEndpoint}) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var spotToken = preferences.getString("spotify_accesstoken");

    http.Response res = await client.get(nextEndpoint ?? favouritePlaylistsUrl);
    if (res.statusCode <= 210) {
      return res;
    }
    return res;
  }

  Future<SpotifySearch?> searchItem(String query, {String? type}) async {
    http.Response response = await _searchItem(query, type: type);
    if (response.statusCode <= 210) {
      return SpotifySearch.fromJson(json.decode(response.body));
    } else {
      return null;
    }
  }

  Future<MySpotifyPlaylists?> myPlaylists({String? nextEndpoint}) async {
    http.Response response = await _getPlaylists(nextEndpoint: nextEndpoint);
    if (response.statusCode <= 210) {
      return MySpotifyPlaylists.fromJson(json.decode(response.body));
    }
    return null;
  }

  openSpotify(String? href, String? url) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    // bool isInstalled = await DeviceApps.isAppInstalled("com.spotify.music");
    try {
      AndroidIntent intent = AndroidIntent(
          action: 'action_view',
          data: href,
          arguments: {
            "EXTRA_REFERRER": "android:app//${packageInfo.packageName}"
          });

      intent.launch();
    } catch (e) {
      if (url != null) {
        launchUrlString(url);
      }
    }
  }

  Future<bool> queueTrack(String uri) async {
    http.Response res = await client.post(
      queueUrl,
      body: {},
      parameters: {"uri": uri},
    );
    if (res.statusCode <= 210) {
      return true;
      // showSnackBar(context, "Song added to your queue");

    }
    return false;
  }

  Future<bool> startTrack(Map<String, dynamic> body) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    http.Response res =
        await client.put(spotifyPlayUrl, bodyRaw: jsonEncode(body));

    if (res.statusCode <= 210) {
      return true;
    } else {
      log(res.body);
      return false;
    }
  }

  Future<List<SpotifyData>> playlistTracks(String playlistID) async {
    String endpoint =
        "https://api.spotify.com/v1/playlists/${playlistID}/tracks";

    http.Response res = await client.get(endpoint);
    if (res.statusCode <= 210) {
      var jsonData = json.decode(utf8.decode(res.bodyBytes))['items'] as List;
      return List<SpotifyData>.from(jsonData.map((e) {
        try {
          return Spot.Item.fromJson(e['track']);
        } catch (error, stack) {
          print(stack);
        }
      }));
    }
    return [];
  }
}
