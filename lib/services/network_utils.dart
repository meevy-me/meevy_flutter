import 'dart:convert';

import 'package:soul_date/constants/endpoints.dart';
import 'package:soul_date/models/images.dart';
import 'package:soul_date/services/network.dart';

Map<int, ProfileImages> memo = {};

Future<ProfileImages> getProfileImages(int profileId) async {
  if (memo.containsKey(profileId)) {
    return memo[profileId]!;
  } else {
    HttpClient client = HttpClient();

    var res = await client.get(userProfileUrl + "$profileId/pictures");
    var defaultImage =
        ProfileImages(image: secondaryAvatarUrl, id: 1, isDefault: true);
    if (res.statusCode <= 210) {
      var jsonData = jsonDecode(res.body);
      jsonData = jsonData as List;
      if (jsonData.isNotEmpty) {
        var profileImage = ProfileImages.fromJson(jsonData.last);
        memo[profileId] = profileImage;
      }
      // print(profile);
    } else {
      memo[profileId] = defaultImage;
      return defaultImage;
    }
    return defaultImage;
  }
}
