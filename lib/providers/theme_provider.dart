import 'package:flutter/material.dart';

import '../settings/preferences.dart';
import '../settings/themes.dart';

class ThemeProvider with ChangeNotifier {
  bool synced = false;
  ThemeEnum _theme = ThemeEnum.auto;

  void syncFromPrefs() {
    if (synced) return;
    Preferences.getTheme().then((t) {
      synced = true;
      _theme = t;
      notifyListeners();
    });
  }

  ThemeEnum get theme => _theme;

  set theme(ThemeEnum theme) {
    Preferences.setTheme(theme);
    _theme = theme;
    notifyListeners();
  }
}
