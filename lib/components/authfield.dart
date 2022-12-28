import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class AuthField extends StatefulWidget {
  const AuthField({
    this.obscureText = false,
    this.controller,
    this.validator,
    this.keyboardType,
    Key? key,
    required this.hintText,
  }) : super(key: key);
  final String hintText;
  final bool obscureText;
  final TextEditingController? controller;
  final String? Function(String? validator)? validator;
  final TextInputType? keyboardType;

  @override
  State<AuthField> createState() => _AuthFieldState();
}

class _AuthFieldState extends State<AuthField> {
  bool visible = false;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: widget.keyboardType,
      autocorrect: true,
      autovalidateMode: AutovalidateMode.always,
      validator: widget.validator,
      controller: widget.controller,
      obscureText: visible,
      decoration: InputDecoration(
          focusColor: Colors.black,
          suffixIconColor: Colors.black,
          hintText: widget.hintText,
          suffixIcon: widget.obscureText
              ? visible
                  ? GestureDetector(
                      onTap: () => setState(() {
                            visible = !visible;
                          }),
                      child: const Icon(Icons.visibility))
                  : GestureDetector(
                      onTap: () => setState(() {
                            visible = !visible;
                          }),
                      child: const Icon(Icons.visibility_off))
              : const SizedBox.shrink(),
          filled: true,
          fillColor: Colors.grey.withOpacity(0.1),
          border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(20)),
          hintStyle: Theme.of(context).textTheme.caption),
    );
  }
}

class AuthTextArea extends StatefulWidget {
  const AuthTextArea({
    this.controller,
    this.validator,
    Key? key,
    required this.hintText,
  }) : super(key: key);
  final String hintText;
  final TextEditingController? controller;
  final String? Function(String? validator)? validator;

  @override
  State<AuthTextArea> createState() => _AuthTextAreaState();
}

class _AuthTextAreaState extends State<AuthTextArea> {
  bool visible = false;
  @override
  Widget build(BuildContext context) {
    var inputDecoration = InputDecoration(
        focusColor: Colors.black,
        suffixIconColor: Colors.black,
        hintText: widget.hintText,
        filled: true,
        fillColor: Colors.grey.withOpacity(0.1),
        border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(20)),
        hintStyle: Theme.of(context).textTheme.caption);
    return TextFormField(
      autocorrect: true,
      maxLines: 8,
      autovalidateMode: AutovalidateMode.always,
      validator: widget.validator,
      controller: widget.controller,
      obscureText: visible,
      decoration: inputDecoration,
    );
  }
}

class PhoneAuthField extends StatelessWidget {
  const PhoneAuthField(
      {Key? key,
      required this.onInputChanged,
      required this.hintText,
      this.initialValue,
      this.textEditingController})
      : super(key: key);
  final Function(PhoneNumber) onInputChanged;
  final String hintText;
  final PhoneNumber? initialValue;
  final TextEditingController? textEditingController;
  @override
  Widget build(BuildContext context) {
    return InternationalPhoneNumberInput(
      textFieldController: textEditingController,
      onInputChanged: onInputChanged,
      formatInput: true,
      selectorConfig: SelectorConfig(
        selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
        countryComparator: (p0, p1) {
          if (p1.name!.codeUnitAt(0) > p0.name!.codeUnitAt(0)) {
            return 0;
          }
          return 1;
        },
      ),
      initialValue: initialValue,
      inputDecoration: InputDecoration(
          focusColor: Colors.black,
          suffixIconColor: Colors.black,
          hintText: hintText,
          filled: true,
          fillColor: Colors.grey.withOpacity(0.1),
          border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(20)),
          hintStyle: Theme.of(context).textTheme.caption),
    );
  }
}
