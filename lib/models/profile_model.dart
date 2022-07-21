import 'package:objectbox/objectbox.dart';
import 'package:soul_date/models/images.dart';
import 'package:soul_date/models/user_model.dart';

@Entity()
class Profile {
  Profile({
    required this.id,
    // required this.images,
    required this.name,
    required this.dateOfBirth,
    required this.bio,
  });
  @Id(assignable: true)
  int id;
  final user = ToOne<User>();
  final images = ToMany<ProfileImages>();
  // List<dynamic> images;
  String name;
  DateTime dateOfBirth;
  String bio;

  factory Profile.fromJson(Map<String, dynamic> json) {
    var profile = Profile(
      id: json["id"],
      name: json["name"],
      dateOfBirth: DateTime.parse(json["date_of_birth"]),
      bio: json["bio"],
    );

    profile.user.target = User.fromJson(json["user"]);
    profile.images.addAll(List<ProfileImages>.from(json["images"].map((x) {
      return ProfileImages.fromJson(x);
    })));
    return profile;
  }

  int get age {
    var today = DateTime.now();
    return today.year - dateOfBirth.year;
  }

  @override
  String toString() {
    return name;
  }

  List<ProfileImages> get validImages {
    return images.takeWhile((element) => !element.isDefault).toList();
  }
}
