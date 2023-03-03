import 'package:flutter/material.dart';
import 'package:soul_date/animations/animations.dart';

import '../../constants/constants.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({Key? key, required this.child, required this.assetUrl})
      : super(key: key);
  final Widget child;
  final String assetUrl;

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  late AssetImage assetImage;
  @override
  void initState() {
    assetImage = AssetImage(widget.assetUrl);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Stack(
          children: [
            FadeAnimation(
              duration: const Duration(seconds: 3),
              child: Image(
                image: assetImage,
                height: size.height,
                width: size.width,
                fit: BoxFit.fitHeight,
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(top: defaultMargin),
                  child: Image.asset(
                    'assets/images/logo-text.png',
                    width: 50,
                    height: 50,
                  ),
                ),
              ),
            )
          ],
        ),
        SlideAnimation(
          begin: const Offset(0, 100),
          duration: const Duration(seconds: 2),
          child: Container(
              // alignment: Alignment.bottomCenter,
              // height: size.height * 0.3,
              padding: scaffoldPadding,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    bottomLeft: Radius.circular(0),
                    bottomRight: Radius.circular(0),
                    topRight: Radius.circular(40),
                  )),
              child: widget.child),
        )
      ],
    );
  }
}
