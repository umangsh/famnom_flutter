import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final theme = ThemeData(
  textTheme: GoogleFonts.montserratTextTheme(),
  primaryColor: const Color(0xFF28A745),
  colorScheme:
      ColorScheme.fromSwatch().copyWith(secondary: const Color(0xFF164F23)),
  scaffoldBackgroundColor: const Color(0xFFFFFFFF),
  listTileTheme: const ListTileThemeData(selectedColor: Color(0xFF28A745)),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xFF164F23)),
    ),
    floatingLabelStyle: const TextStyle(
      color: Color(0xFF164F23),
    ),
  ),
);
