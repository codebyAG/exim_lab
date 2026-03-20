import 'package:flutter/material.dart';

class AppColorSchemes {
  // 🌞 LIGHT THEME — Global Academy Navy & Red
  static const ColorScheme light = ColorScheme.light(
    // 🟦 PRIMARY — Pure Navy Blue
    primary: Color(0xFF000080), 
    onPrimary: Color(0xFFFFFFFF),

    // 🟥 SECONDARY — Vibrant Red (CTAs)
    secondary: Color(0xFFD32F2F),
    onSecondary: Color(0xFFFFFFFF),

    // 🧱 SURFACE — Light Off-White / Blue Tint
    surface: Color(0xFFF8FAFC),
    onSurface: Color(0xFF0A1D37), // Navy for text

    // ❌ ERROR
    error: Color(0xFFB00020),
    onError: Color(0xFFFFFFFF),

    // 🧩 OUTLINES
    outline: Color(0xFFBDC3C7),
    outlineVariant: Color(0xFFECF0F1),

    // 🌫 SHADOWS
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),

    // ✨ MATERIAL OVERLAY
    surfaceTint: Color(0xFF0A1D37),
  );

  // 🌙 DARK THEME — Deep Navy on Darker Surface
  static const ColorScheme dark = ColorScheme.dark(
    // 🟦 PRIMARY — Deep Navy
    primary: Color(0xFF1B2A4E),
    onPrimary: Color(0xFFFFFFFF),

    // 🟥 SECONDARY — Vibrant Red
    secondary: Color(0xFFE57373),
    onSecondary: Color(0xFFFFFFFF),

    // 🧱 SURFACE — Deep Charcoal / Navy
    surface: Color(0xFF0F172A),
    onSurface: Color(0xFFE2E8F0),

    // ❌ ERROR
    error: Color(0xFFF87171),
    onError: Color(0xFFFFFFFF),

    // 🧩 OUTLINES
    outline: Color(0xFF334155),
    outlineVariant: Color(0xFF1E293B),

    // 🌫 SHADOWS
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),

    // ✨ MATERIAL OVERLAY
    surfaceTint: Color(0xFF1B2A4E),
  );
}
