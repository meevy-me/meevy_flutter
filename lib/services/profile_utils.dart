import 'dart:convert';

import 'package:soul_date/models/models.dart';
import 'package:soul_date/services/network.dart';

import '../constants/constants.dart';

Future<Profile?> searchProfile(String id) async {
  HttpClient client = HttpClient();
  String endpoint = baseUrl + 'users/search/user/';
  var res = await client.get(endpoint + "$id/");

  if (res.statusCode <= 210) {
    return Profile.fromJson(json.decode(utf8.decode(res.bodyBytes)));
  } else if (res.statusCode == 400) {
    throw "Profile Not Found";
  }
  return null;
}
