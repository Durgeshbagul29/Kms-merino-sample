import 'package:flutter/material.dart';

ThemeData get appTheme {
  return ThemeData(
    fontFamily: 'Outfit',
    primaryColor: Colors.blue.shade800,
    // primaryColor: Color(0xFF2C3E50),
    secondaryHeaderColor: const Color(0xFF1ED7AA),
    disabledColor: const Color(0xFFBABFC4),
    scaffoldBackgroundColor: const Color(0xFFF1F0F5),
    hoverColor: const Color(0xFFe9ecee),
    brightness: Brightness.light,
    hintColor: const Color(0xFF9F9F9F),
    cardColor: Colors.white,
    colorScheme: ColorScheme.light(
      primary: Colors.blue.shade800,
      secondary: Colors.blue.shade800,
      error: const Color(0xFFE84D4F),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: Colors.blue.shade800),
    ),
  );
}
