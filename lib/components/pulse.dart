import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingPulse extends StatelessWidget {
  const LoadingPulse({Key? key, this.color = Colors.grey}) : super(key: key);
  final Color color;
  @override
  Widget build(BuildContext context) {
    return SpinKitPulse(
      color: color,
    );
  }
}
