import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:soul_date/models/spotify_spot_details.dart';

class SpotScreenBackground extends StatelessWidget {
  const SpotScreenBackground({
    Key? key,
    required this.item,
  }) : super(key: key);

  final Item item;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        ClipRRect(
          borderRadius:
              const BorderRadius.vertical(bottom: Radius.circular(20)),
          child: SizedBox(
            height: size.height,
            width: size.width,
            child: Container(
              color: Colors.black.withOpacity(0),
              child: CachedNetworkImage(
                  fit: BoxFit.cover, imageUrl: item.album.images[0].url),
            ),
          ),
        ),
        Positioned.fill(
            child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            color: Colors.black.withOpacity(0.3),
          ),
        ))
      ],
    );
  }
}
