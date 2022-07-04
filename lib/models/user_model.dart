class User {
  User({
    required this.spotifyId,
  });

  String spotifyId;

  factory User.fromJson(Map<String, dynamic> json) => User(
        spotifyId: json["spotifyID"],
      );

  Map<String, dynamic> toJson() => {
        "spotifyID": spotifyId,
      };
}
