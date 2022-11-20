class ProfileImages {
  int id;
  bool isDefault;
  final String image;
  ProfileImages(
      {required this.image, required this.id, required this.isDefault});

  factory ProfileImages.fromJson(Map<String, dynamic> json) {
    return ProfileImages(
        image: json['image'], id: json['id'], isDefault: json['default']);
  }
  @override
  String toString() {
    return image;
  }
}
