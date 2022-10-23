import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  final String Function(String? value)? validator;
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

  TextInputType textInputType = TextInputType.number;
  TextEditingController day = TextEditingController();
  TextEditingController month = TextEditingController();
  TextEditingController year = TextEditingController();

  @override
  void initState() {
    if (widget.initialDate != null) {
      setState(() {
        day.text = widget.initialDate!.day.toString();
        month.text = widget.initialDate!.month.toString();
        year.text = widget.initialDate!.year.toString();
      });
    }
    super.initState();
  }

  void onChange(String value) {
    int dayTemp = int.parse(day.text);
    int monthTemp = int.parse(month.text);
    int yearTemp = int.parse(year.text);
    if (widget.selectedDate != null) {
      setState(() {
        widget.selectedDate!(DateTime(yearTemp, monthTemp, dayTemp));
      });
    }
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
        Row(
          children: [
            Expanded(
              child: TextFormField(
                  style: Theme.of(context).textTheme.bodyText1,
                  controller: day,
                  keyboardType: textInputType,
                  onChanged: onChange,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    FilteringTextInputFormatter.allow(RegExp(r'[1-31]'))
                  ],
                  textAlign: TextAlign.center,
                  decoration: decoration(context, "Day")),
            ),
            const SizedBox(
              width: defaultMargin * 2,
              child: Text(
                "/",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ),
            Expanded(
              child: TextFormField(
                  style: Theme.of(context).textTheme.bodyText1,
                  controller: month,
                  keyboardType: textInputType,
                  textAlign: TextAlign.center,
                  onChanged: onChange,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    FilteringTextInputFormatter.allow(RegExp(r'[1-12]'))
                  ],
                  validator: ((value) {
                    if (value != null) {
                      var month = int.parse(value);
                      if (month > 12 || month < 1) {
                        return "Enter a valid month";
                      }
                    }
                    return null;
                  }),
                  decoration: decoration(context, "Month")),
            ),
            const SizedBox(
              width: defaultMargin * 2,
              child: Text(
                "/",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ),
            Expanded(
              child: TextFormField(
                  style: Theme.of(context).textTheme.bodyText1,
                  controller: year,
                  keyboardType: textInputType,
                  onChanged: onChange,
                  validator: (value) {
                    if (value != null) {
                      var now = DateTime.now();
                      var selected = int.parse(value);
                      if ((now.year - selected) < 18) {
                        return "You don't meet the age requirements.";
                      }
                    }
                    return null;
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  textAlign: TextAlign.center,
                  decoration: decoration(context, "Year")),
            ),
          ],
        )
      ],
    );
  }
}
