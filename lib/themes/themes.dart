import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData lightmode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    surface: Color(0xFFBDBDBD),
    primary: Color(0xFF292929),
    secondary: Color(0xFF5DA349),
    tertiary: Color(0xFF385E2F)
  ),
  textTheme: TextTheme(
    displayLarge: GoogleFonts.poppins(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Color(0xFFBDBDBD)
    ),
    displayMedium: GoogleFonts.poppins(
      fontSize: 17.5,
      fontWeight: FontWeight.bold,
      color: Color(0xFFBDBDBD)
    ),
    displaySmall: GoogleFonts.poppins(
      fontSize: 15,
      fontWeight: FontWeight.bold,
      color: Color(0xFFBDBDBD)
    ),
    titleLarge: GoogleFonts.poppins(
      fontSize: 25,
      fontWeight: FontWeight.bold,
      color: Color(0xFFBDBDBD)
    ),
    titleMedium: GoogleFonts.poppins(
      fontSize: 60,
      fontWeight: FontWeight.bold,
      color: Color(0xFF292929)
    )
  )
);