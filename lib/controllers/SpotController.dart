import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soul_date/components/image_circle.dart';
import 'package:soul_date/constants/constants.dart';
import 'package:soul_date/models/profile_model.dart';
import 'package:soul_date/models/spots.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../services/network.dart';

class SpotController extends GetxController {
  RxList<SpotsView> spots = <SpotsView>[].obs;
  RxList<SpotsView> mySpots = <SpotsView>[].obs;
  HttpClient client = HttpClient();
  WebSocketChannel? channel;
  Future<void> fetchSpots() async {
    Timer.periodic(const Duration(seconds: 40), (timer) async {
      http.Response res = await client.get(fetchSpotsUrl);
      if (res.statusCode <= 210) {
        var spotsList = spotsViewFromJson(utf8.decode(res.bodyBytes));
        spots.value = spotsList;
      } else {
        log(res.body, name: "SPOTS ERROR");
      }
    });
  }

  @override
  void onInit() {
    fetchSpots();
    fetchMySpot();
    openConnection();
    super.onInit();
  }

  void fetchMySpot() async {
    http.Response res = await client.get(fetchSpotsMeUrl);
    if (res.statusCode <= 210) {
      var spot = spotsViewFromJson(utf8.decode(res.bodyBytes));

      mySpots.value = spot;
    } else {
      log(res.body);
      return null;
    }
  }

  void createSpot(Map<String, String> body,
      {required BuildContext context}) async {
    http.Response res = await client.post(fetchSpotsUrl, body: body);
    if (res.statusCode <= 210) {
      fetchMySpot();
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Spot Posted")));
      Get.back();
    }
  }

  void deleteSpot(int id) async {
    http.Response res = await client.delete(fetchSpotsUrl + '$id/');
    log(res.body);
    if (res.statusCode <= 210) {
      if (Get.currentRoute == 'spot_screen') {
        Get.back();
      }
      fetchMySpot();
    }
  }

  void openConnection() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String token = preferences.getString("token")!;
    channel = IOWebSocketChannel.connect(spotsWs,
        headers: {'authorization': "Token $token"});
    listenSpots();
  }

  void showNotification(Spot spotNew) {
    Get.showSnackbar(GetSnackBar(
      backgroundColor: primaryPink,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 10),
      isDismissible: true,
      borderRadius: 20,
      title: "${spotNew.profile.name} created a spot",
      messageText: Row(
        children: [
          SoulCircleAvatar(imageUrl: spotNew.details.item.album.images[0].url),
          const SizedBox(
            width: defaultMargin,
          ),
          Text(
            "${spotNew.profile.name} created a spot",
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w500),
          )
        ],
      ),
    ));
  }

  void listenSpots() {
    if (channel != null) {
      channel!.stream.listen((event) {
        var decoded = json.decode(event);
        var data = decoded['event'];
        var command = decoded['command'];

        var index = spots.indexWhere((element) {
          return element.profile.id == data['profile']['id'];
        });
        if (index != -1) {
          if (command == 'Add') {
            var newSpot = Spot.fromJson(data['spot']);
            spots[index].spots.add(newSpot);

            spots.refresh();
            showNotification(newSpot);
          } else if (command == 'Delete') {
            var spotID = data['spot']['id'];

            spots[index].spots.removeWhere((element) => element.id == spotID);
            spots.refresh();
          }
        } else {
          var newSpot = Spot.fromJson(data['spot']);
          var spotsNew = [newSpot];

          spots.add(SpotsView(
              profile: Profile.fromJson(data['profile']), spots: spotsNew));
          spots.refresh();
          showNotification(newSpot);
        }
      });
    }
  }
}
