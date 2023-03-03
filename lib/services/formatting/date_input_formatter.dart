import 'package:flutter/services.dart';

class DayMonthYearValidators {
  static String? dayValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Day of birth is required';
    }
    if (int.tryParse(value) == null) {
      return 'Day of birth must be a number';
    }
    final day = int.parse(value);
    if (day < 1 || day > 31) {
      return 'Day of birth must be between 1 and 31';
    }
    return null;
  }

  static String? monthValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Month of birth is required';
    }
    if (int.tryParse(value) == null) {
      return 'Month of birth must be a number';
    }
    final month = int.parse(value);
    if (month < 1 || month > 12) {
      return 'Month of birth must be between 1 and 12';
    }
    return null;
  }

  static String? yearValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Year of birth is required';
    }
    if (int.tryParse(value) == null) {
      return 'Year of birth must be a number';
    }
    final year = int.parse(value);
    if (year < 1900 || year > 2023) {
      return 'Year of birth must be between 1900 and 2023';
    }
    return null;
  }
}

class DayMonthYearFormatters {
  static TextInputFormatter dayFormatter =
      FilteringTextInputFormatter.digitsOnly;

  static TextInputFormatter monthFormatter =
      FilteringTextInputFormatter.digitsOnly;

  static TextInputFormatter yearFormatter =
      FilteringTextInputFormatter.digitsOnly;
}
