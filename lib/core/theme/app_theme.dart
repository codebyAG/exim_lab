import 'package:flutter/material.dart';

ThemeData buildAppTheme(ColorScheme scheme) {
  return ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    colorScheme: scheme,
    scaffoldBackgroundColor: scheme.background,
    cardColor: scheme.surface,

    appBarTheme: AppBarTheme(
      backgroundColor: scheme.surface,
      foregroundColor: scheme.onSurface,
      elevation: 0,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 14),
      ),
    ),

    textTheme: TextTheme(
      headlineMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: scheme.onBackground,
      ),
      titleLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: scheme.onBackground,
      ),
      bodyLarge: TextStyle(fontSize: 16, color: scheme.onBackground),
      bodyMedium: TextStyle(fontSize: 14, color: scheme.onBackground),
    ),
  );
}
