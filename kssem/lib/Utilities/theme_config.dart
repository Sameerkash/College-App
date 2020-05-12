import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const Color _appBarIcon = Colors.white;
  static Color _iconColor = Colors.deepPurple[600];
  static Color _primaryColor = Colors.deepPurple[900];
  static Color _secondaryColor = Colors.deepPurple[800];
  static Color _secondaryVarientColor = Colors.deepPurple[200];
  static Color _accentColor = Colors.deepPurple[400];
  static Color _secondaryBackgroundColor = Colors.grey;
  static Color _lightTextColor = Colors.black;
  static Color _darkTextColor = Colors.white;
  static const Color _lightbackColor = Colors.white;
  static Color _darkbackColor = Colors.black;
  static Color _darkScaffold = Colors.grey[800];
  static Color _lightScaffold = Colors.grey[100];

// static final TextTheme _lightTextTheme = TextTheme(
//   headline6:  _lightTextColor
//   );

  static final ThemeData lightTheme = ThemeData(
    appBarTheme: AppBarTheme(
      color: _primaryColor,
      iconTheme: IconThemeData(color: _appBarIcon),
    ),
    brightness: Brightness.light,
    scaffoldBackgroundColor: _lightScaffold,
    accentColor: _accentColor,

    colorScheme: ColorScheme.light(
        onSecondary: _darkbackColor,
        primary: _primaryColor,
        secondary: _secondaryVarientColor,
        background: _lightbackColor,
        primaryVariant: _accentColor,
        secondaryVariant: _secondaryColor),
    iconTheme: IconThemeData(
      color: _iconColor,
    ),
    // textTheme: _lightTextColor,
  );

  static final ThemeData darkTheme = ThemeData(
    appBarTheme: AppBarTheme(
      color: _primaryColor,
      iconTheme: IconThemeData(color: _appBarIcon),
    ),
    brightness: Brightness.dark,
    scaffoldBackgroundColor: _darkScaffold,
    accentColor: _accentColor,
    colorScheme: ColorScheme.dark(
        onSecondary: _lightbackColor,
        onBackground: _secondaryBackgroundColor,
        background: _darkbackColor,
        primary: _primaryColor,
        secondary: _secondaryColor,
        primaryVariant: _accentColor,
        secondaryVariant: _secondaryVarientColor),
    iconTheme: IconThemeData(
      color: _iconColor,
    ),
  );
}
