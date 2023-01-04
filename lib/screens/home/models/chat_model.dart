import 'package:intl/intl.dart';
import 'package:soul_date/models/profile_model.dart';

import '../../../services/date_format.dart';

class VinylChat {
  final Profile sender;
  final String message;
  final DateTime dateSent;

  VinylChat(
      {required this.sender, required this.message, required this.dateSent});

  factory VinylChat.fromJson(Map<String, dynamic> json) => VinylChat(
      sender: Profile.fromJson(json['sender']),
      message: json['message'],
      dateSent: DateTime.parse(json['date_sent']));

  Map<String, dynamic> toJson() {
    return {
      'sender': sender.toJson(),
      'message': message,
      "date_sent": dateSent.toIso8601String()
    };
  }

  String get date {
    return formatDate(dateSent, pattern: DateFormat.jm().pattern);
  }

  @override
  String toString() {
    return message;
  }
}
