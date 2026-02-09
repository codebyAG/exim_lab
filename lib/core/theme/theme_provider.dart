import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light; // Default to Light

  ThemeMode get themeMode => _themeMode;

  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString('theme_mode');

    if (value == 'dark') {
      _themeMode = ThemeMode.dark;
    } else if (value == 'system') {
      _themeMode = ThemeMode.system;
    } else {
      _themeMode = ThemeMode.light; // Default to Light if null or 'light'
    }
    notifyListeners();
  }

  Future<void> _save(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme_mode', value);
  }

  void toggleTheme() {
    if (_themeMode == ThemeMode.system) {
      _themeMode = ThemeMode.light;
      _save('light');
    } else if (_themeMode == ThemeMode.light) {
      _themeMode = ThemeMode.dark;
      _save('dark');
    } else {
      _themeMode = ThemeMode.system;
      _save('system');
    }
    notifyListeners();
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
