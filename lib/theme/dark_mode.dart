import 'package:flutter/material.dart';

ThemeData darkMode = ThemeData(
  colorScheme: ColorScheme.dark(
    brightness: Brightness.dark,
    background: Color(0xFF212121), // Gray 900
    primary: Color(0xFF424242), // Gray 800
    secondary: Color(0xFF616161), // Gray 700
    inversePrimary: Color(0xFF9E9E9E), // Gray 500
    tertiary: Color(0xFFBDBDBD), // Gray 400
    onPrimaryContainer: Color(0xFFEEEEEE), // Gray 200
    onSecondaryContainer: Color(0xFFF5F5F5), // Gray 100
  ),
);
