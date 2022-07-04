import 'package:soul_date/models/user_model.dart';

class Profile {
  Profile({
    required this.id,
    required this.user,
    required this.images,
    required this.name,
    required this.dateOfBirth,
    required this.bio,
  });

  int id;
  User user;
  List<dynamic> images;
  String name;
  DateTime dateOfBirth;
  String bio;

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        id: json["id"],
        user: User.fromJson(json["user"]),
        images: List<dynamic>.from(json["images"].map((x) => x)),
        name: json["name"],
        dateOfBirth: DateTime.parse(json["date_of_birth"]),
        bio: json["bio"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user": user.toJson(),
        "images": List<dynamic>.from(images.map((x) => x)),
        "name": name,
        "date_of_birth":
            "${dateOfBirth.year.toString().padLeft(4, '0')}-${dateOfBirth.month.toString().padLeft(2, '0')}-${dateOfBirth.day.toString().padLeft(2, '0')}",
        "bio": bio,
      };

  int get age {
    var today = DateTime.now();
    return today.year - dateOfBirth.year;
  }
}
