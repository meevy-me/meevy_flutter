import 'package:hive/hive.dart';
part 'user_model.g.dart';

@HiveType(typeId: 1)
class User {
  User({required this.spotifyId, required this.id});
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String spotifyId;

  factory User.fromJson(Map<String, dynamic> json) =>
      User(spotifyId: json["spotifyID"], id: json['id']);

  Map<String, dynamic> toJson() => {"spotifyID": spotifyId, "id": id};
}
