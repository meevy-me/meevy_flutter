import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/basic.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:lottie/lottie.dart';

class EmptyWidget extends StatelessWidget {
  const EmptyWidget(
      {Key? key, this.text, this.height, this.width, this.assetString})
      : super(key: key);
  final String? text;
  final double? height;
  final double? width;
  final String? assetString;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset(assetString ?? 'assets/images/lottie_empty.json',
            width: width, height: height),
        if (text != null)
          Text(
            text!,
            style: Theme.of(context).textTheme.caption,
          )
      ],
    );
  }
}
