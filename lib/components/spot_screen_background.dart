import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:soul_date/services/methods.dart';

import '../models/models.dart';

class SpotScreenBackground extends StatelessWidget {
  const SpotScreenBackground({
    Key? key,
    required this.size,
    required this.spot,
  }) : super(key: key);

  final Size size;
  final Spot spot;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PaletteGenerator>(
        future: getImageColors(CachedNetworkImageProvider(
            spot.details.item.album.images.first.url)),
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            return Container(
              height: size.height * 0.9,
              width: size.width,
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                snapshot.data!.darkMutedColor!.color,
                snapshot.data!.dominantColor!.color
              ])),
            );
          } else {
            return SizedBox(
              height: size.height,
              width: size.width,
            );
          }
        }));
  }
}

class MySpotScreenBackground extends StatelessWidget {
  const MySpotScreenBackground({
    Key? key,
    required this.size,
    required this.details,
  }) : super(key: key);

  final Size size;
  final SpotifyDetails details;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PaletteGenerator>(
        future: getImageColors(
            CachedNetworkImageProvider(details.item.album.images.first.url)),
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            return Container(
              height: size.height * 0.9,
              width: size.width,
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                snapshot.data!.darkMutedColor!.color,
                snapshot.data!.dominantColor!.color
              ])),
            );
          } else {
            return SizedBox(
              height: size.height,
              width: size.width,
            );
          }
        }));
  }
}
