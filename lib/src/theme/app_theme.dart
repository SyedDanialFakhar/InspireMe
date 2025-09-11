import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      brightness: Brightness.light,
      scaffoldBackgroundColor: const Color(0xFFF6F9FB),
      textTheme: const TextTheme(
        headlineMedium: TextStyle(fontWeight: FontWeight.w700),
        bodyLarge: TextStyle(fontSize: 18),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal, brightness: Brightness.dark),
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF0F141A),
      textTheme: const TextTheme(
        headlineMedium: TextStyle(fontWeight: FontWeight.w700),
        bodyLarge: TextStyle(fontSize: 18),
      ),
    );
  }
}


