import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/constants.dart';

class AppTheme {
  static ThemeData primary() {
    return ThemeData(
        primaryColor: primaryPink,
        colorScheme: ColorScheme.fromSwatch().copyWith(
            secondary: primaryDark,
            primaryContainer: const Color(0xFF241D1E),
            outline: primaryLight,
            tertiary: spotifyGreen),
        textTheme: GoogleFonts.poppinsTextTheme(const TextTheme(
            headline1: TextStyle(
                fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black),
            headline2: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
            headline3: TextStyle(
                fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
            headline4: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
            headline5: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
            headline6: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
            bodyText1: TextStyle(
                fontSize: 14, color: Colors.black, fontWeight: FontWeight.w600),
            caption: TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
            bodyText2: TextStyle(fontSize: 14, color: Colors.black))));
  }
}
