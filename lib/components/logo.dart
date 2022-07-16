import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:soul_date/constants/constants.dart';

class Logo extends StatelessWidget {
  const Logo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("Soul", style: Theme.of(context).textTheme.bodyText1),
        const SizedBox(
          width: defaultPadding,
        ),        SvgPicture.asset(
          'assets/images/logo.svg',
          width: 30,
        ),
        const SizedBox(
          width: defaultPadding,
        ),
        Text("Date", style: Theme.of(context).textTheme.bodyText1),
      ],
    );
  }
}
