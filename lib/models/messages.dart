class Message {
  Message({
    required this.id,
    required this.content,
    required this.datePosted,
    required this.sender,
    required this.spot,
  });

  int id;
  String content;
  DateTime datePosted;
  int sender;
  dynamic spot;

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        id: json["id"],
        content: json["content"],
        datePosted: DateTime.parse(json["date_posted"]),
        sender: json["sender"],
        spot: json["spot"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "content": content,
        "date_posted": datePosted.toIso8601String(),
        "sender": sender,
        "spot": spot,
      };

  String get formatContent {
    if (content.contains("https://open.spotify.com/")) {
      return "Sent a spotify item";
    }
    return content;
  }
}
