import 'package:flutter/material.dart';

Route scaledTransition(Widget child) {
  return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var tween = Tween(begin: 0.7, end: 1.0)
            .chain(CurveTween(curve: Curves.easeInOut));
        final scaleAnimation = animation.drive(tween);
        return ScaleTransition(
          scale: scaleAnimation,
          child: child,
        );
      });
}
