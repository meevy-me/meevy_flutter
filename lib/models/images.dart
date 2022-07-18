import 'package:objectbox/objectbox.dart';

@Entity()
class ProfileImages {
  @Id(assignable: true)
  int id;
  final String image;
  ProfileImages({required this.image, required this.id});

  factory ProfileImages.fromJson(Map<String, dynamic> json) {
    return ProfileImages(image: json['image'], id: json['id']);
  }
  @override
  String toString() {
    return image;
  }
}
