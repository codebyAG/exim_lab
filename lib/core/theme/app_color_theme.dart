import 'package:flutter/material.dart';

class AppColorSchemes {
  // 🌞 LIGHT THEME — Bright Orange & Soft White
  static const ColorScheme light = ColorScheme.light(
    // 🟧 PRIMARY — Bright Clean Orange
    primary: Color(0xFFFF8A00), // vivid orange
    onPrimary: Color(0xFFFFFFFF),

    // 🟨 SECONDARY — Soft Peach Accent
    secondary: Color(0xFFFFB703),
    onSecondary: Color(0xFF3B1D00),

    // 🧱 SURFACE — Clean White
    surface: Color(0xFFFFFFFF),
    onSurface: Color(0xFF1F2937),

    // ❌ ERROR
    error: Color(0xFFEF4444),
    onError: Color(0xFFFFFFFF),

    // 🧩 OUTLINES
    outline: Color(0xFFE5E7EB),
    outlineVariant: Color(0xFFF3F4F6),

    // 🌫 SHADOWS
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),

    // ✨ MATERIAL OVERLAY
    surfaceTint: Color(0xFFFF8A00),
  );

  // 🌙 DARK THEME — Bright Orange on Soft Charcoal
  static const ColorScheme dark = ColorScheme.dark(
    // 🟧 PRIMARY — Bright Orange (same identity)
    primary: Color(0xFFFF9F1C),
    onPrimary: Color(0xFF1F2937),

    // 🟨 SECONDARY — Warm Gold
    secondary: Color(0xFFFFC857),
    onSecondary: Color(0xFF1F2937),

    // 🧱 SURFACE — Soft Dark Grey (NOT black)
    surface: Color(0xFF1E1E1E),
    onSurface: Color(0xFFE5E7EB),

    // ❌ ERROR
    error: Color(0xFFF87171),
    onError: Color(0xFF1F2937),

    // 🧩 OUTLINES
    outline: Color(0xFF374151),
    outlineVariant: Color(0xFF2D2D2D),

    // 🌫 SHADOWS
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),

    // ✨ MATERIAL OVERLAY
    surfaceTint: Color(0xFFFF9F1C),
  );
}
