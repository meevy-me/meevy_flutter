import 'package:hive/hive.dart';
part 'images.g.dart';

@HiveType(typeId: 2)
class ProfileImages {
  @HiveField(0)
  int id;
  @HiveField(1)
  bool isDefault;
  @HiveField(2)
  final String image;
  ProfileImages(
      {required this.image, required this.id, required this.isDefault});

  factory ProfileImages.fromJson(Map<String, dynamic> json) {
    return ProfileImages(
        image: json['image'], id: json['id'], isDefault: json['default']);
  }

  Map<String, dynamic> toJson() {
    return {"id": id, "default": isDefault, "image": image};
  }

  @override
  String toString() {
    return image;
  }
}
