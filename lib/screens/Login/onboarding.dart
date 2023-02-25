import 'package:flutter/material.dart';

import '../../constants/constants.dart';

class Onboarding extends StatelessWidget {
  const Onboarding({Key? key, required this.child, required this.assetUrl})
      : super(key: key);
  final Widget child;
  final String assetUrl;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Stack(
          children: [
            Image.asset(
              assetUrl,
              height: size.height,
              width: size.width,
              fit: BoxFit.fitHeight,
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
        Container(
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
            child: child)
      ],
    );
  }
}
