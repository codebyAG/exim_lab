import 'package:flutter/material.dart';

ThemeData buildAppTheme(ColorScheme scheme) {
  return ThemeData(
    useMaterial3: false,
    fontFamily: 'Poppins',

    // 🔹 CORE COLORS
    colorScheme: scheme,
    scaffoldBackgroundColor: scheme.surface,
    cardColor: scheme.surface,
    dividerColor: scheme.outline.withValues(alpha: 0.3),

    // 🔹 APP BAR
    appBarTheme: AppBarTheme(
      backgroundColor: scheme.surface,
      foregroundColor: scheme.onSurface,
      elevation: 0,
      iconTheme: IconThemeData(color: scheme.onSurface),
      titleTextStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: scheme.onSurface,
        fontFamily: 'Poppins',
      ),
    ),

    // 🔹 ICONS (GLOBAL)
    iconTheme: IconThemeData(color: scheme.onSurface, size: 22),

    // 🔹 TEXT
    textTheme: TextTheme(
      headlineMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: scheme.onSurface,
      ),
      titleLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: scheme.onSurface,
      ),
      titleMedium: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: scheme.onSurface,
      ),
      bodyLarge: TextStyle(fontSize: 16, color: scheme.onSurface),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: scheme.onSurface.withValues(alpha: 0.85),
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        color: scheme.onSurface.withValues(alpha: 0.65),
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: scheme.primary,
      ),
    ),

    // 🔹 BUTTONS
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          fontFamily: 'Poppins',
        ),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: scheme.primary,
        textStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          fontFamily: 'Poppins',
        ),
      ),
    ),

    // 🔹 INPUTS
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: scheme.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      hintStyle: TextStyle(color: scheme.onSurface.withValues(alpha: 0.5)),
    ),

    // 🔹 BOTTOM NAV
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: scheme.surface,
      selectedItemColor: scheme.primary,
      unselectedItemColor: scheme.onSurface.withValues(alpha: 0.5),
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
      showUnselectedLabels: true,
      elevation: 8,
    ),

    // 🔹 FLOATING ACTION BUTTON
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: scheme.primary,
      foregroundColor: scheme.onPrimary,
      elevation: 6,
    ),

    // 🔹 LIST TILE
    listTileTheme: ListTileThemeData(
      iconColor: scheme.onSurface,
      textColor: scheme.onSurface,
    ),
  );
}
