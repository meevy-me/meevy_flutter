import 'package:soul_date/models/models.dart';

class MeevyBasePlaylist {
  final String name;
  final String description;
  final List<Profile> contributors;
  final String? caption;
  final String? imageUrl;
  MeevyBasePlaylist(
      {required this.name,
      required this.description,
      this.imageUrl,
      required this.contributors,
      this.caption});
}
