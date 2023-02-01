import 'dart:convert';

import 'package:soul_date/constants/endpoints.dart';
import 'package:soul_date/models/images.dart';
import 'package:soul_date/services/network.dart';

Future<ProfileImages> getProfileImages(int profileId) async {
  HttpClient client = HttpClient();

  var res =
      await client.get(userProfileUrl + "$profileId/pictures", cache: true);
  var defaultImage =
      ProfileImages(image: secondaryAvatarUrl, id: 1, isDefault: true);
  if (res.statusCode <= 210) {
    var jsonData = jsonDecode(res.body);
    jsonData = jsonData as List;
    if (jsonData.isNotEmpty) {
      return ProfileImages.fromJson(jsonData.last);
    }
    // print(profile);
  } else {
    // memo[profileId] = defaultImage;
    // return defaultImage;
  }
  return defaultImage;
}
