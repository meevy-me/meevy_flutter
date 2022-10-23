import 'package:flutter/material.dart';

class IconContainer extends StatelessWidget {
  const IconContainer(
      {Key? key,
      required this.icon,
      this.color,
      this.padding,
      this.size,
      this.onPress})
      : super(key: key);
  final Widget icon;
  final Color? color;
  final EdgeInsets? padding;
  final double? size;
  final void Function()? onPress;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      child: Container(
          height: size,
          width: size,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          child: Center(child: icon)),
    );
  }
}
