import 'package:flutter/material.dart';

class ThemeSettings {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    primaryColor: Colors.purple,
    fontFamily: 'Manrope',
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    fontFamily: 'Manrope',
    colorScheme: const ColorScheme.dark().copyWith(
      primary: Colors.purple,
    ),
  );
}
