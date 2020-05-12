import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeChanger with ChangeNotifier {
  // ThemeData _themeData;

  // ThemeChanger(this._themeData);

  // getTheme()=> _themeData;

  // setTheme(ThemeData theme){
  //   _themeData = theme;
  //   notifyListeners();
  // }
  bool isDarkModeOn = false;

  ThemeChanger() {
    // We load theme at the start
    _loadTheme();
  }

  _loadTheme() {
    SharedPreferences.getInstance().then((prefs) {
      bool dark = prefs.getBool("isDarkMode") ?? false;
      print(dark);
      isDarkModeOn = dark;
      notifyListeners();
    });
  }

  void updateTheme(bool isDarkModeOn) {
    this.isDarkModeOn = isDarkModeOn;
    SharedPreferences.getInstance().then((prefs) {
      print("setting value");
      prefs.setBool("isDarkMode", isDarkModeOn);
    });
    notifyListeners();
  }
}
