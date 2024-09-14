import 'package:flutter/material.dart';
import 'package:music_app/ui/theme/theme.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = false; // Biến boolean lưu trữ trạng thái chủ đề

  ThemeData get themeData => _isDarkMode ? darkMode : lightMode;

  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}
