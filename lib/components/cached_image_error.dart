import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class SoulCachedNetworkImage extends StatelessWidget {
  const SoulCachedNetworkImage(
      {Key? key,
      this.width,
      this.height,
      this.fit = BoxFit.cover,
      required this.imageUrl,
      this.progressIndicatorBuilder})
      : super(key: key);
  final double? width;
  final double? height;
  final BoxFit fit;
  final String imageUrl;
  final Widget Function(BuildContext, String, DownloadProgress)?
      progressIndicatorBuilder;

  @override
  Widget build(BuildContext context) {
    try {
      return CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        width: width,
        height: height,
        progressIndicatorBuilder: progressIndicatorBuilder,
      );
    } catch (e) {
      return CachedNetworkImage(
        imageUrl:
            "https://as1.ftcdn.net/v2/jpg/03/39/45/96/1000_F_339459697_XAFacNQmwnvJRqe1Fe9VOptPWMUxlZP8.jpg",
        fit: BoxFit.cover,
        width: width,
        height: height,
        progressIndicatorBuilder: progressIndicatorBuilder,
      );
    }
  }
}
