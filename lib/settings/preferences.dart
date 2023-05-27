import 'package:shared_preferences/shared_preferences.dart';

import '../settings/themes.dart';

class Preferences {
  static SharedPreferences? _prefs;

  static Future<SharedPreferences> get prefs async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  static Future<ThemeEnum> getTheme() async {
    switch ((await prefs).getString('theme')) {
      case 'light':
        return ThemeEnum.light;
      case 'dark':
        return ThemeEnum.dark;
    }
    return ThemeEnum.auto;
  }

  static void setTheme(ThemeEnum? theme) {
    prefs.then((p) {
      if (theme == ThemeEnum.light) {
        p.setString('theme', 'light');
      } else if (theme == ThemeEnum.dark) {
        p.setString('theme', 'dark');
      } else {
        p.remove('theme');
      }
    });
  }
}
