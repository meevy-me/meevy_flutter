import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soul_date/models/models.dart';
import 'package:soul_date/services/network_utils.dart';

class MeevyPlaylist {
  final int creatorID;
  final String name;
  final DateTime createdAt;
  final String imageUrl;

  final String id;
  final Color? playlistColor;

  MeevyPlaylist(
      {required this.creatorID,
      required this.name,
      this.playlistColor,
      required this.createdAt,
      required this.imageUrl,
      required this.id});

  factory MeevyPlaylist.fromSnapshot(DocumentSnapshot doc) => MeevyPlaylist(
      creatorID: doc['creator']['id'],
      name: doc['name'],
      createdAt: DateTime.parse(doc['created_at']),
      imageUrl: doc['imageUrl'],
      id: doc.id);
  int get profile1 {
    String id1 = id.split("-")[0];
    return int.parse(id1);
  }

  List<int> get memberIds {
    return id.split("-").map((e) => int.parse(e)).toList();
  }

  int get profile2 {
    String id2 = id.split("-")[1];
    return int.parse(id2);
  }

  Future<ProfileImages> get profile1Images async {
    return await getProfileImages(profile1);
  }

  Future<ProfileImages> get profile2Images async {
    return await getProfileImages(profile2);
  }

  Future<int> get friendID async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    int profileID = preferences.getInt('profileID')!;

    if (profile1 != profileID) {
      return profile1;
    }
    return profile2;
  }

  String get description {
    return "Music buddy playlist by Meevy.";
  }
}
