import 'package:objectbox/objectbox.dart';

@Entity()
class User {
  User({
    required this.spotifyId,
  });
  int? id;
  String spotifyId;

  factory User.fromJson(Map<String, dynamic> json) => User(
        spotifyId: json["spotifyID"],
      );

  Map<String, dynamic> toJson() => {
        "spotifyID": spotifyId,
      };
}
