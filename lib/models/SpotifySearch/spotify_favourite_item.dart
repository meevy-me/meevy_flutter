abstract class SpotifyFavouriteItem {
  String get title;
  String get subTitle;
  String get caption;
  String get imageUrl;
  String get id;
  String get uri;
  String get href;
  Map<String, dynamic> toJson();
}
