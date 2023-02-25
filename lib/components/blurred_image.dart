import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class BlurredImage extends StatelessWidget {
  final String imagePath;
  final double height;
  final double width;
  final double value;

  const BlurredImage({
    Key? key,
    required this.imagePath,
    required this.height,
    required this.width,
    this.value = 5,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      imageFilter: ui.ImageFilter.blur(sigmaX: value, sigmaY: value),
      child: SizedBox(
        height: height,
        width: width,
        child: ClipRect(
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: value, sigmaY: value),
            child: Image.asset(
              imagePath,
              height: height,
              width: width,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
