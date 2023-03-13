import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:soul_date/services/date_format.dart';

import '../constants/constants.dart';

class SecondaryInputDecoration {
  static InputDecoration decoration(context) => InputDecoration(
      focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
              color: Theme.of(context).colorScheme.outline, width: 2)),
      border: UnderlineInputBorder(
          borderSide: BorderSide(
              color: Theme.of(context).colorScheme.outline, width: 1.5)),
      isDense: true,
      errorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 1)),
      focusedErrorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 1.5)),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 0, vertical: defaultMargin),
      floatingLabelBehavior: FloatingLabelBehavior.always);

  static InputDecoration decorationBordered(context) => InputDecoration(
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: Theme.of(context).colorScheme.outline, width: 2)),
      border: OutlineInputBorder(
          borderSide: BorderSide(
              color: Theme.of(context).colorScheme.outline, width: 1.5)),
      isDense: true,
      errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 1)),
      focusedErrorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 1.5)),
      contentPadding: const EdgeInsets.symmetric(
          horizontal: defaultPadding, vertical: defaultMargin),
      floatingLabelBehavior: FloatingLabelBehavior.always);
}

class SecondaryTextInput extends StatelessWidget {
  const SecondaryTextInput({
    Key? key,
    required this.label,
    this.controller,
    this.validator,
    this.textInputType,
    this.labelColor,
    this.maxLines,
  }) : super(key: key);
  final String label;
  final TextEditingController? controller;
  final String? Function(String? value)? validator;
  final TextInputType? textInputType;
  final Color? labelColor;
  final int? maxLines;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context)
              .textTheme
              .bodyText1!
              .copyWith(color: labelColor ?? textBlack97),
        ),
        if (maxLines != null)
          const SizedBox(
            height: defaultMargin,
          ),
        TextFormField(
            maxLines: maxLines,
            controller: controller,
            keyboardType: textInputType,
            validator: validator,
            style: Theme.of(context).textTheme.bodyText1,
            decoration: SecondaryInputDecoration.decoration(context)),
      ],
    );
  }
}

class DateInputField extends StatefulWidget {
  const DateInputField(
      {Key? key,
      this.labelColor,
      required this.label,
      this.initialDate,
      required this.selectedDate})
      : super(key: key);

  @override
  State<DateInputField> createState() => _DateInputFieldState();
  final Color? labelColor;
  final String label;
  final DateTime? initialDate;
  final Function(DateTime selected)? selectedDate;
}

class _DateInputFieldState extends State<DateInputField> {
  InputDecoration decoration(context, String hintText) =>
      SecondaryInputDecoration.decoration(context).copyWith(
          hintText: hintText,
          hintStyle: Theme.of(context)
              .textTheme
              .caption!
              .copyWith(fontSize: 12, fontWeight: FontWeight.w600));

  @override
  void initState() {
    if (widget.initialDate != null) {
      setState(() {});
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: Theme.of(context)
              .textTheme
              .bodyText1!
              .copyWith(color: widget.labelColor ?? textBlack97),
        ),
        DateTimeFormField(
          dateTextStyle: Theme.of(context).textTheme.bodyText1,
          mode: DateTimeFieldPickerMode.date,
          onDateSelected: widget.selectedDate,
          decoration: decoration(
              context,
              widget.initialDate != null
                  ? formatDate(widget.initialDate!,
                      pattern: formatDate(widget.initialDate!,
                          pattern: DateFormat.yMMMd().pattern))
                  : 'When were you born :)'),
          initialDate: widget.initialDate,
          lastDate: DateTime(DateTime.now().year),
          firstDate: DateTime(1920),
        )
      ],
    );
  }
}
