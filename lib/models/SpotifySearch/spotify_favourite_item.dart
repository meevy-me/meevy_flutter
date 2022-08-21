abstract class SpotifyFavouriteItem {
  String get title;
  String get subTitle;
  String get caption;
  String get imageUrl;
  String get id;

  Map<String, dynamic> toJson();
}
