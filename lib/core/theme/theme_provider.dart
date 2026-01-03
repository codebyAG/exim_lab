import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString('theme_mode');

    if (value == 'light') {
      _themeMode = ThemeMode.light;
    } else if (value == 'dark') {
      _themeMode = ThemeMode.dark;
    } else {
      _themeMode = ThemeMode.system;
    }
    notifyListeners();
  }

  Future<void> _save(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme_mode', value);
  }

  void setLight() {
    _themeMode = ThemeMode.light;
    _save('light');
    notifyListeners();
  }

  void setDark() {
    _themeMode = ThemeMode.dark;
    _save('dark');
    notifyListeners();
  }

  void setSystem() {
    _themeMode = ThemeMode.system;
    _save('system');
    notifyListeners();
  }
}
