import 'package:flutter/material.dart';

import 'package:lottie/lottie.dart';

class EmptyWidget extends StatelessWidget {
  const EmptyWidget(
      {Key? key,
      this.text,
      this.height,
      this.width,
      this.assetString,
      this.child})
      : super(key: key);
  final String? text;
  final double? height;
  final double? width;
  final String? assetString;
  final Widget? child;

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
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.caption,
          ),
        child != null ? child! : const SizedBox.shrink()
      ],
    );
  }
}
