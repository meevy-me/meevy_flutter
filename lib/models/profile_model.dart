import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:soul_date/models/images.dart';
import 'package:soul_date/models/user_model.dart';
part 'profile_model.g.dart';

List<Profile> profileFromJson(String str) =>
    List<Profile>.from(json.decode(str).map((x) => Profile.fromJson(x)));

@HiveType(typeId: 0)
class Profile extends HiveObject {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final User user;
  @HiveField(2)
  List<ProfileImages> images = [];
  @HiveField(3)
  final String name;
  @HiveField(4)
  final String looking_for;
  @HiveField(5)
  final DateTime dateOfBirth;
  @HiveField(6)
  final String bio;

  factory Profile.fromJson(Map<String, dynamic> json) {
    late String bioTemp;
    try {
      bioTemp = utf8.decode(json['bio'].codeUnits);
    } catch (e) {
      bioTemp = json['bio'];
    }
    var profile = Profile(
      id: json["id"],
      user: User.fromJson(json["user"]),
      name: json["name"],
      dateOfBirth: DateTime.parse(json["date_of_birth"]),
      bio: bioTemp,
      looking_for: json.containsKey('looking_for') ? json['looking_for'] : 'A',
    );
    try {
      if (json.containsKey('images')) {
        profile.images.addAll(List<ProfileImages>.from(json["images"].map((x) {
          return ProfileImages.fromJson(x);
        })));
      }
    } catch (e) {
      profile.images.add(defaultProfileImage);
    }
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

  String get birthdayFormat {
    return DateFormat.MMMMd().format(dateOfBirth);
  }

  @override
  String toString() {
    return name;
  }

  List<ProfileImages> get validImages {
    if (images.isNotEmpty) {
      return images.where((element) {
        return !element.isDefault;
      }).toList();
    } else {
      return images.toList();
    }
  }

  ProfileImages get profilePicture {
    return images.last;
  }

  @override
  bool operator ==(Object other) {
    other as Profile;
    return other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
