import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:soul_date/components/pulse.dart';
import 'package:soul_date/models/images.dart';
import 'package:soul_date/services/network_utils.dart';

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

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar(
      {Key? key, required this.profileID, this.radius = 20, this.placeholder})
      : super(key: key);
  final int profileID;
  final double radius;
  final Widget? placeholder;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ProfileImages>(
      future: getProfileImages(profileID),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.data != null) {
          return SoulCircleAvatar(
            imageUrl: snapshot.data!.image,
            radius: radius,
          );
        } else if (snapshot.hasError) {
          return const SizedBox.shrink();
        } else {
          return placeholder ?? const LoadingPulse();
        }
      },
    );
  }
}
