import 'package:flutter/material.dart';
import 'package:soul_date/components/logo.dart';

import '../constants/constants.dart';

AppBar buildAppBar(BuildContext context) {
  return AppBar(
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    centerTitle: true,
    elevation: 0,
    title: const Padding(
      padding: EdgeInsets.symmetric(vertical: defaultMargin),
      child: Logo(),
    ),
    leading: const BackButton(
      color: Colors.black,
    ),
  );
}
