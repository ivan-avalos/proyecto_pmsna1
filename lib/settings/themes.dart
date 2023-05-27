import 'package:flutter/material.dart';

enum ThemeEnum { light, dark, auto }

class ThemeSettings {
  static ThemeData lightTheme(ColorScheme? lightDynamic) => ThemeData(
        useMaterial3: true,
        primaryColor: Colors.purple,
        fontFamily: 'Manrope',
        colorScheme: lightDynamic,
      );

  static ThemeData darkTheme(ColorScheme? darkDynamic) => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        fontFamily: 'Manrope',
        primaryColor: Colors.purple,
        colorScheme: (darkDynamic ?? const ColorScheme.dark()),
      );
}
