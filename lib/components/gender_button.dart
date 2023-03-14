import 'package:flutter/material.dart';

class GenderButton extends StatelessWidget {
  const GenderButton({
    Key? key,
    required this.text,
    required this.onPress,
    this.active = false,
  }) : super(key: key);
  final String text;
  final void Function() onPress;
  final bool active;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      child: AnimatedContainer(
          height: 40,
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
              color: active ? Theme.of(context).primaryColor : Colors.grey,
              borderRadius: BorderRadius.circular(10)),
          child: Center(
              child: Text(
            text,
            style: const TextStyle(
                fontWeight: FontWeight.w600, color: Colors.white),
          ))),
    );
  }
}
