import 'package:flutter/material.dart';

class ThemeSettings {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    primaryColor: Colors.purple,
  );

  static ThemeData darkTheme = ThemeData.dark(
    useMaterial3: true,
  ).copyWith(
    colorScheme: const ColorScheme.dark().copyWith(
      primary: Colors.purple,
    ),
  );
}
