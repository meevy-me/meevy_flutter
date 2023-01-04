import 'package:flutter/material.dart';

void showModal(BuildContext context, Widget child) {
  Size size = MediaQuery.of(context).size;
  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    builder: (context) => child,
  );
}
