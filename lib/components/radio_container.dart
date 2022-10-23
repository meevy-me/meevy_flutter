import 'package:flutter/material.dart';

import 'package:soul_date/constants/constants.dart';

class RadioContainer extends StatelessWidget {
  const RadioContainer(
      {Key? key, required this.child, this.onTap, this.active = true})
      : super(key: key);
  final Widget child;
  final bool active;

  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(defaultPadding),
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: active ? Theme.of(context).primaryColor : Colors.grey,
          border: !active ? Border.all(color: Colors.grey) : null,
        ),
        child: child,
      ),
    );
  }
}
