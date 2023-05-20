import 'package:flutter/material.dart';

import '../settings/preferences.dart';

class ThemeProvider with ChangeNotifier {
  bool synced = false;
  ThemeData? _theme;

  void syncFromPrefs() {
    if (synced) return;
    Preferences.getTheme().then((t) {
      synced = true;
      _theme = t;
      notifyListeners();
    });
  }

  ThemeData? get theme => _theme;

  set theme(ThemeData? theme) {
    Preferences.setTheme(theme);
    _theme = theme;
    notifyListeners();
  }
}
