import 'package:flutter/material.dart';
import '../../core/app_export.dart';

class ThemeProvider extends ChangeNotifier {
  // String _themeType = PrefUtils().getThemeData() ?? 'lightCode';
  String _themeType = PrefUtils().getThemeData() ?? 'system';


  String get themeType => _themeType;

  void toggleTheme() {
    _themeType = _themeType == 'lightCode' ? 'darkCode' : 'lightCode';
    PrefUtils().setThemeData(_themeType); // Save the theme in shared preferences
    notifyListeners();
  }

  ThemeMode get currentThemeMode {
    if (_themeType == 'lightCode') {
      return ThemeMode.light;
    } else if (_themeType == 'darkCode') {
      return ThemeMode.dark;
    } else {
      return ThemeMode.system;  // System default
    }
  }

}