import 'package:flutter/cupertino.dart';
import 'package:soul_date/constants/colors.dart';

class SpotifyBorder extends StatelessWidget {
  const SpotifyBorder({Key? key, required this.child, this.padding})
      : super(key: key);
  final Widget child;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
          border: Border.all(color: spotifyGreen, width: 2),
          shape: BoxShape.circle),
      child: child,
    );
  }
}
