import 'package:flutter/material.dart';

class AppThemes {
  static final lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    primaryColor: Colors.black,
    appBarTheme: const AppBarTheme(
      color: Colors.white,
    ),
  );

  static final darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.grey.shade800,
    primaryColor: Colors.white,
    appBarTheme: AppBarTheme(
      color: Colors.grey.shade900,
    ),
    colorScheme: ColorScheme.fromSwatch(
      brightness: Brightness.dark,
    ),
  );
}
