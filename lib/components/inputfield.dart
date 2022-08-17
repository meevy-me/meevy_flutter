import 'package:flutter/material.dart';

class SoulField extends StatefulWidget {
  const SoulField({
    this.controller,
    this.activeColor = Colors.grey,
    this.validator,
    this.suffixIcon,
    this.prefixIcon,
    this.keyboardType,
    Key? key,
    required this.hintText,
    this.onChanged,
  }) : super(key: key);
  final String hintText;
  final TextEditingController? controller;
  final String? Function(String? validator)? validator;
  final TextInputType? keyboardType;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Color activeColor;
  final Function(String value)? onChanged;

  @override
  State<SoulField> createState() => _SoulFieldState();
}

class _SoulFieldState extends State<SoulField> {
  bool visible = false;
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
          colorScheme:
              ThemeData().colorScheme.copyWith(primary: widget.activeColor)),
      child: TextFormField(
        keyboardType: widget.keyboardType,
        autocorrect: true,
        onChanged: (value) {
          if (widget.onChanged != null) {
            widget.onChanged!(value);
          }
        },
        autovalidateMode: AutovalidateMode.always,
        validator: widget.validator,
        controller: widget.controller,
        obscureText: visible,
        decoration: InputDecoration(
            focusColor: Colors.black,
            suffixIconColor: Colors.black,
            hintText: widget.hintText,
            prefixIcon: widget.prefixIcon,
            suffixIcon: widget.suffixIcon,
            filled: true,
            fillColor: Colors.grey.withOpacity(0.1),
            border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(20)),
            hintStyle: Theme.of(context).textTheme.caption),
      ),
    );
  }
}
