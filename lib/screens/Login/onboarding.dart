import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

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
        Image.asset(
          assetUrl,
          height: size.height,
          width: size.width,
          fit: BoxFit.fitHeight,
        ),
        Container(
            // alignment: Alignment.bottomCenter,
            height: size.height * 0.3,
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
