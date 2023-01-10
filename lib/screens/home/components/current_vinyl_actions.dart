import 'package:flutter/material.dart';

import '../../../constants/constants.dart';

class MusicActions extends StatelessWidget {
  const MusicActions({
    Key? key,
    required this.iconData,
    this.onPress,
    this.icon,
    required this.text,
  }) : super(key: key);
  final IconData iconData;
  final void Function()? onPress;
  final Widget? icon;
  final String text;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: defaultMargin),
      child: InkWell(
        onTap: onPress,
        child: Center(
          child: Row(
            children: [
              icon ??
                  Icon(
                    iconData,
                    color: Theme.of(context).primaryColor,
                    size: 20,
                  ),
              const SizedBox(
                width: defaultPadding,
              ),
              Text(
                text,
                style: Theme.of(context)
                    .textTheme
                    .caption!
                    .copyWith(color: Colors.white, fontWeight: FontWeight.w600),
              )
            ],
          ),
        ),
      ),
    );
  }
}
