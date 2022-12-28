import 'package:cached_network_image/cached_network_image.dart';
import 'package:palette_generator/palette_generator.dart';

Future<PaletteGenerator> getImageColors(String imageUrl) async {
  var paletteGenerator = await PaletteGenerator.fromImageProvider(
      CachedNetworkImageProvider(imageUrl));
  return paletteGenerator;
}
