import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:soul_date/components/icon_container.dart';

class AppbarIconContainer extends StatelessWidget {
  const AppbarIconContainer({Key? key, required this.iconData, this.onPress})
      : super(key: key);
  final IconData iconData;
  final void Function()? onPress;
  @override
  Widget build(BuildContext context) {
    return IconContainer(
      icon: Icon(
        iconData,
        color: Colors.black,
        size: 20,
      ),
      onPress: onPress,
      color: Colors.grey.withOpacity(0.2),
      size: 40,
    );
  }
}
