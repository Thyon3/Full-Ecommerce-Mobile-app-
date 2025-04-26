import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  colorScheme: ColorScheme.light(
    brightness: Brightness.light,
    background: Color(0xFFFAFAFA), // Gray 50
    primary: Color(0xFFF5F5F5), // Gray 100
    secondary: Color(0xFFEEEEEE), // Gray 200
    inversePrimary: Color(0xFF616161), // Gray 700
    tertiary: Color(0xFF757575), // Gray 600
    onPrimaryContainer: Color(0xFF424242), // Gray 800
    onSecondaryContainer: Color(0xFF212121), // Gray 900
  ),
);
