import 'package:flutter/material.dart';

class AppColorSchemes {
  // 🌞 LIGHT THEME
  static const ColorScheme light = ColorScheme.light(
    primary: Color(0xFF2563EB), // Brand blue
    secondary: Color(0xFF10B981), // Success / accent

    background: Color(0xFFF8FAFC), // App background
    surface: Color(0xFFFFFFFF), // Cards / sheets

    onPrimary: Color(0xFFFFFFFF),
    onSecondary: Color(0xFFFFFFFF),
    onBackground: Color(0xFF0F172A),
    onSurface: Color(0xFF0F172A),
    // 🔹 EXTRA IMPORTANT COLORS
    error: Color(0xFFDC2626),
    onError: Color(0xFFFFFFFF),

    outline: Color(0xFFCBD5E1), // borders / dividers
    outlineVariant: Color(0xFFE2E8F0),

    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),

    surfaceTint: Color(0xFF2563EB), // material overlay
  );

  // 🌙 DARK THEME
  static const ColorScheme dark = ColorScheme.dark(
    primary: Color(0xFF60A5FA), // Softer blue for dark
    secondary: Color(0xFF34D399),

    background: Color(0xFF020617), // App background
    surface: Color(0xFF0F172A), // Cards

    onPrimary: Color(0xFF020617),
    onSecondary: Color(0xFF020617),
    onBackground: Color(0xFFE5E7EB),
    onSurface: Color(0xFFE5E7EB),

    // 🔹 EXTRA IMPORTANT COLORS
    error: Color(0xFFF87171),
    onError: Color(0xFF020617),

    outline: Color(0xFF334155),
    outlineVariant: Color(0xFF1E293B),

    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),

    surfaceTint: Color(0xFF60A5FA),
  );
}
