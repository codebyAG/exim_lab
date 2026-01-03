import 'package:flutter/material.dart';

class AppColorSchemes {
  static const ColorScheme light = ColorScheme.light(
    primary: Color(0xFF2563EB),
    secondary: Color(0xFF10B981),
    background: Color(0xFFF8FAFC),
    surface: Colors.white,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onBackground: Color(0xFF0F172A),
    onSurface: Color(0xFF0F172A),
  );

  static const ColorScheme dark = ColorScheme.dark(
    primary: Color(0xFF60A5FA),
    secondary: Color(0xFF34D399),
    background: Color(0xFF020617),
    surface: Color(0xFF0F172A),
    onPrimary: Color(0xFF020617),
    onSecondary: Color(0xFF020617),
    onBackground: Color(0xFFE5E7EB),
    onSurface: Color(0xFFE5E7EB),
  );
}
