import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class SoulCircleAvatar extends StatelessWidget {
  const SoulCircleAvatar({Key? key, required this.imageUrl, this.radius = 20})
      : super(key: key);
  final String imageUrl;
  final double radius;
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.white,
      foregroundImage: CachedNetworkImageProvider(imageUrl),
    );
  }
}
