import 'package:flutter/material.dart';

class ChatTextField extends StatelessWidget {
  const ChatTextField({
    Key? key,
    required this.captionText,
    this.border,
    this.autoFocus = false,
    this.textColor,
    this.focusedBorder,
  }) : super(key: key);

  final InputBorder? border;
  final bool autoFocus;
  final Color? textColor;
  final InputBorder? focusedBorder;
  final TextEditingController captionText;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ConstrainedBox(
      constraints: BoxConstraints(
          minWidth: size.width * 0.75,
          maxWidth: size.width * 0.75,
          minHeight: 60),
      child: TextFormField(
        autofocus: autoFocus,
        cursorHeight: 1,
        controller: captionText,
        maxLines: null,
        textCapitalization: TextCapitalization.sentences,
        style:
            Theme.of(context).textTheme.bodyText2!.copyWith(color: textColor),
        decoration: InputDecoration(
            isDense: true,
            filled: border != null ? false : true,
            fillColor: Colors.grey.withOpacity(0.4),
            hintText: "Type Message",
            focusedBorder: focusedBorder ??
                OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none),
            enabledBorder: border ??
                OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(20)),
            hintStyle: Theme.of(context).textTheme.caption),
      ),
    );
  }
}
