import 'package:intl/intl.dart';
import 'package:objectbox/objectbox.dart';
import 'package:soul_date/models/images.dart';
import 'package:soul_date/models/user_model.dart';

@Entity()
class Profile {
  Profile({
    required this.id,
    // required this.images,
    required this.name,
    this.looking_for = 'A',
    required this.dateOfBirth,
    required this.bio,
  });
  @Id(assignable: true)
  int id;
  final user = ToOne<User>();
  final images = ToMany<ProfileImages>();
  // List<dynamic> images;
  String name;
  String looking_for;
  DateTime dateOfBirth;
  String bio;

  factory Profile.fromJson(Map<String, dynamic> json) {
    var profile = Profile(
      id: json["id"],
      name: json["name"],
      dateOfBirth: DateTime.parse(json["date_of_birth"]),
      bio: json["bio"],
      looking_for: json['looking_for'],
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
