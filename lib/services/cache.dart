import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:soul_date/models/images.dart';
import 'package:soul_date/services/network.dart';

import '../constants/constants.dart';

class DataCache {
  static final DataCache _instance = DataCache._internal();
  factory DataCache() => _instance;

  DataCache._internal();

  static const int _cacheDuration = 1 * 60 * 60;

  // 1 hour in seconds

  Future<bool> isValid(String cacheKey) async {
    var preferences = await SharedPreferences.getInstance();
    var cacheTime = preferences.getInt(cacheKey + '_time');
    return cacheTime != null &&
        (DateTime.now().millisecondsSinceEpoch - cacheTime) >
            _cacheDuration * 1000;
  }

  Future<String?> getJson(String cacheKey) async {
    var preferences = await SharedPreferences.getInstance();
    var cacheTime = preferences.getInt(cacheKey + '_time');
    // preferences.remove(cacheKey);
    if (cacheTime != null &&
        (DateTime.now().millisecondsSinceEpoch - cacheTime) >
            _cacheDuration * 1000) {
      return null;
    } else {
      return preferences.getString(cacheKey);
    }
  }

  Future<bool> setJson(String key, String str) async {
    var preferences = await SharedPreferences.getInstance();
    preferences.setInt(key + '_time', DateTime.now().millisecondsSinceEpoch);
    return preferences.setString(key, str);
  }
}

// 1 hour in seconds

Future<List<ProfileImages>> getImages(int profileId) async {
  HttpClient client = HttpClient();
  String _cacheKey = 'images_$profileId';

  // Make API call to fetch images
  var response =
      await client.get(userProfileUrl + "$profileId/pictures", cache: true);

  var images = json.decode(response.body);
  return List<ProfileImages>.from(images.map((e) => ProfileImages.fromJson(e)));
}
