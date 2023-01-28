import 'package:soul_date/models/profile_model.dart';

class SpotBuddy {
  final Profile profile;
  final String? caption;

  SpotBuddy({required this.profile, this.caption});

  factory SpotBuddy.fromJson(Map<String, dynamic> json) {
    return SpotBuddy(
        profile: Profile.fromJson(json['profile']), caption: json['caption']);
  }
}
