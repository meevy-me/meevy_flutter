import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soul_date/constants/constants.dart';
import 'package:soul_date/models/Spotify/album_model.dart';
import 'package:soul_date/models/Spotify/artist_model.dart';
import 'package:soul_date/models/Spotify/base_model.dart';
import 'package:soul_date/models/Spotify/playlist_model.dart';
import 'package:soul_date/models/Spotify/track_model.dart';
import 'package:soul_date/models/Spotify/user_model.dart';
import 'package:soul_date/models/spotify_spot_details.dart';
import 'package:soul_date/models/spotifyuser.dart';
import 'package:soul_date/screens/my_spot_screen.dart';
import 'package:soul_date/services/network.dart';
import 'package:soul_date/services/notifications.dart';

class Spotify {
  late String accessToken;
  late String refreshToken;
  SpotifyUser? currentUser;
  Spotify() {
    getCurrentUser();
  }

  HttpClient client = HttpClient();

  String _basicAuth(String username, String password) {
    return 'Basic ' + base64Encode(utf8.encode('$username:$password'));
  }

  String get _clientSecret {
    return "edbd307b1b064e91a8974698bb9b0a8f";
  }

  Future<Map?> getTokens(String code) async {
    http.Response res =
        await client.post(spotifyTokenEndpoint, useToken: false, body: {
      'code': code,
      'clientId': clientId,
      'grant_type': 'authorization_code',
      'redirect_uri': 'souldate:/'
    }, headers: {
      'Content-type': 'application/x-www-form-urlencoded',
      'Authorization': _basicAuth(clientId, _clientSecret)
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

  Future<bool> refreshAccessToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var spotRefresh = preferences.getString("spotify_refreshtoken");
    http.Response res =
        await client.post(spotifyTokenEndpoint, useToken: false, body: {
      'grant_type': 'refresh_token',
      'refresh_token': spotRefresh!,
      'redirect_uri': 'souldate:/',
    }, headers: {
      'Content-type': 'application/x-www-form-urlencoded',
      'Authorization': _basicAuth(clientId, _clientSecret)
    });
    if (res.statusCode <= 210) {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setString(
          "spotify_accesstoken", json.decode(res.body)['access_token']);
      accessToken = json.decode(res.body)['access_token'];
      return true;
    } else {
      log(res.body, name: "REFRESH TOKEN ERROR");
      return false;
    }
  }

  Future<SpotifyDetails?> fetchCurrentPlaying(BuildContext context,
      {navigate = true}) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    accessToken = preferences.getString("spotify_accesstoken")!;
    refreshToken = preferences.getString("spotify_refreshtoken")!;
    http.Response res = await client.get(playerUrl,
        headers: {
          'Authorization': "Bearer $accessToken",
          "Content-Type": "application/json"
        },
        useToken: false);

    if (res.statusCode <= 210 && res.body.isNotEmpty) {
      var detail = SpotifyDetails.fromJson(json.decode(res.body));
      if (navigate) {
        Get.to(() => MySpotScreen(details: detail));
      }
    } else if (res.statusCode <= 210 && res.body.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("You're not playing any song currently.")));
    } else if (res.statusCode <= 401 &&
        json.decode(res.body)['error']['message'] ==
            "The access token expired") {
      await refreshAccessToken();
      fetchCurrentPlaying(context);
    } else {
      return null;
    }
    return null;
  }

  playTrack(String uri, {required BuildContext context}) async {
    http.Response res = await client.post(queueUrl,
        body: {},
        parameters: {"uri": uri},
        useToken: false,
        headers: {'Authorization': "Bearer $accessToken"});
    if (res.statusCode <= 210) {
      showSnackBar(context, "Song added to your queue");
    } else if (res.statusCode == 401 &&
        json.decode(res.body)['error']['message'] ==
            "The access token expired") {
      await refreshAccessToken();
      playTrack(uri, context: context);
    } else {
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
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var spotToken = preferences.getString("spotify_accesstoken");

    http.Response res = await client.get("$endpoint$id",
        useToken: false, headers: {'Authorization': "Bearer $spotToken"});

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
    } else if (res.statusCode == 401 &&
        json.decode(res.body)['error']['message'] ==
            "The access token expired") {
      await refreshAccessToken();
      getItem(key, id);
    } else {
      log(res.body, name: "SPOTIFY ERROR");
    }
    return null;
  }

  Future<SpotifyUser?> getCurrentUser({String? accessToken}) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    late String? spotToken;

    spotToken = accessToken ?? preferences.getString("spotify_accesstoken");

    http.Response res = await client.get(spotifyMeEndpoint,
        useToken: false, headers: {'Authorization': "Bearer $spotToken"});

    if (res.statusCode <= 210) {
      var currentSpot = SpotifyUser.fromJson(jsonDecode(res.body));
      currentUser = currentSpot;
      return currentSpot;
    } else if (res.statusCode == 401 &&
        json.decode(res.body)['error']['message'] ==
            "The access token expired") {
      await refreshAccessToken();
      getCurrentUser();
    } else {
      log(res.body, name: "SPOTIFY ERROR");
    }
    return null;
  }
}
