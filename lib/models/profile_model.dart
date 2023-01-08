import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:soul_date/models/images.dart';
import 'package:soul_date/models/user_model.dart';

class Profile {
  final int id;
  final User user;
  List<ProfileImages> images = [];

  final String name;
  final String looking_for;
  final DateTime dateOfBirth;
  final String bio;

  factory Profile.fromJson(Map<String, dynamic> json) {
    var profile = Profile(
      id: json["id"],
      user: User.fromJson(json["user"]),
      name: json["name"],
      dateOfBirth: DateTime.parse(json["date_of_birth"]),
      bio: json["bio"],
      looking_for: json['looking_for'],
    );

    profile.images.addAll(List<ProfileImages>.from(json["images"].map((x) {
      return ProfileImages.fromJson(x);
    })));
    return profile;
  }
  Map<String, dynamic> toJson() => {
        "id": id,
        "user": user.toJson(),
        "name": name,
        "bio": bio,
        "date_of_birth": dateOfBirth.toIso8601String(),
        "looking_for": looking_for,
        "images": [images.last.toJson()]
      };
  Profile(
      {required this.id,
      required this.user,
      required this.name,
      required this.looking_for,
      required this.dateOfBirth,
      required this.bio});

  int get age {
    var today = DateTime.now();
    return today.year - dateOfBirth.year;
  }

  String get birthday {
    return DateFormat("dd-MM-yyy").format(dateOfBirth);
  }

  @override
  String toString() {
    return name;
  }

  List<ProfileImages> get validImages {
    if (images.isNotEmpty) {
      return images.takeWhile((element) => !element.isDefault).toList();
    } else {
      return images.toList();
    }
  }

  ProfileImages get profilePicture {
    return images.last;
  }
}
