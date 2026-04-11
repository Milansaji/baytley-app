import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ArabicTheme {
  ArabicTheme._();

  static ThemeData light(ThemeData base) {
    final textTheme = GoogleFonts.cairoTextTheme(base.textTheme);
    return base.copyWith(
      textTheme: textTheme,
      primaryTextTheme: GoogleFonts.cairoTextTheme(base.primaryTextTheme),
      appBarTheme: base.appBarTheme.copyWith(
        titleTextStyle: GoogleFonts.cairo(
          textStyle: base.appBarTheme.titleTextStyle,
        ),
      ),
    );
  }

  static ThemeData dark(ThemeData base) {
    final textTheme = GoogleFonts.cairoTextTheme(base.textTheme);
    return base.copyWith(
      textTheme: textTheme,
      primaryTextTheme: GoogleFonts.cairoTextTheme(base.primaryTextTheme),
      appBarTheme: base.appBarTheme.copyWith(
        titleTextStyle: GoogleFonts.cairo(
          textStyle: base.appBarTheme.titleTextStyle,
        ),
      ),
    );
  }
}
