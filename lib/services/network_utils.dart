import 'package:soul_date/constants/endpoints.dart';
import 'package:soul_date/models/images.dart';

Future<ProfileImages> getProfileImages(int profileId) async {
  return ProfileImages(image: defaultGirlUrl, id: 1, isDefault: true);
}
