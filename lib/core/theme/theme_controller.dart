import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends ChangeNotifier {
  Color _accentColor = const Color(0xFF74C69D);

  Color get accentColor => _accentColor;

  ThemeController() {
    loadTheme();
  }

  /// LOAD
  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();

    final colorValue = prefs.getInt("themeColor");

    if (colorValue != null) {
      _accentColor = Color(colorValue);
    }

    notifyListeners();
  }

  /// CHANGE
  Future<void> changeColor(
    Color color,
  ) async {
    _accentColor = color;

    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt(
      "themeColor",
      color.value,
    );

    notifyListeners();
  }
}
