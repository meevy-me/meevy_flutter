class User {
  User({required this.spotifyId, required this.id});
  final int id;
  final String spotifyId;

  factory User.fromJson(Map<String, dynamic> json) =>
      User(spotifyId: json["spotifyID"], id: json['id']);

  Map<String, dynamic> toJson() => {"spotifyID": spotifyId, "id": id};
}
