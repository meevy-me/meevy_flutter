import 'package:flutter/material.dart';

class NoticeDialog extends StatelessWidget {
  const NoticeDialog({
    Key? key,
    required this.child,
  }) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(content: child);
  }
}
