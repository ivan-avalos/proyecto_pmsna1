import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../settings/themes.dart';

class Preferences {
  static SharedPreferences? _prefs;

  static Future<SharedPreferences> get prefs async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  static Future<ThemeData?> getTheme() async {
    switch ((await prefs).getString('theme')) {
      case 'light':
        return ThemeSettings.lightTheme;
      case 'dark':
        return ThemeSettings.darkTheme;
    }
    return null;
  }

  static void setTheme(ThemeData? theme) {
    prefs.then((p) {
      if (theme == ThemeSettings.lightTheme) {
        p.setString('theme', 'light');
      } else if (theme == ThemeSettings.darkTheme) {
        p.setString('theme', 'dark');
      } else {
        p.remove('theme');
      }
    });
  }
}
