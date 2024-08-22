import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallpaper/product/theme/app_colors.dart';

class ThemeProvider extends ChangeNotifier {
  final SharedPreferences _prefs;
  late ThemeMode _themeMode;

  ThemeProvider(this._prefs) {
    _themeMode = _getSavedTheme();

    // getMainColors();
  }

  ThemeMode get themeMode => _themeMode;

  ThemeMode _getSavedTheme() {
    final themeString = _prefs.getString('theme') ?? 'ThemeMode.dark';
    return themeString == 'ThemeMode.dark'
        ? ThemeMode.dark
        : themeString == 'ThemeMode.light'
            ? ThemeMode.light
            : ThemeMode.system;
  }

  Future<void> setTheme(ThemeMode themeMode) async {
    _themeMode = themeMode;
    await _prefs.setString('theme', themeMode.toString());
    AppColors.updateTheme(isDarkTheme: themeMode == ThemeMode.dark);
    // ! Tema değiştirme düzeltileceği zaman burası dikkate alınmalı.
    // Get.changeThemeMode(themeMode);
    // Get.changeTheme(themeMode == ThemeMode.dark ? ThemeData.dark() : ThemeData.light());
    notifyListeners();
  }

  void updateColor() {
    notifyListeners();
  }

  // void getMainColors() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   AppColors.main = Color(prefs.getInt('mainColor') ?? AppColors.main.value);
  //   AppColors.lightMain = Color(prefs.getInt('lightMainColor') ?? AppColors.lightMain.value);
  //   AppColors.deepMain = Color(prefs.getInt('deepMainColor') ?? AppColors.deepMain.value);
  // }
}
