import 'package:flutter/material.dart';

class AppColorSchemes {
  // 🌞 LIGHT THEME — Metallic & Premium
  static const ColorScheme light = ColorScheme.light(
    // 🔷 PRIMARY — Metallic Blue Steel
    primary: Color(0xFF1E3A8A), // Deep steel blue
    onPrimary: Color(0xFFFFFFFF),

    // 🟢 SECONDARY — Emerald Metal
    secondary: Color(0xFF059669),
    onSecondary: Color(0xFFFFFFFF),

    // 🧱 SURFACE — Polished White Steel
    surface: Color(0xFFF8FAFC), // slightly metallic white
    onSurface: Color(0xFF0F172A),

    // ❌ ERROR
    error: Color(0xFFB91C1C),
    onError: Color(0xFFFFFFFF),

    // 🧩 OUTLINES / DIVIDERS
    outline: Color(0xFFCBD5E1), // silver border
    outlineVariant: Color(0xFFE2E8F0),

    // 🌫 SHADOWS
    shadow: Color(0xFF020617),
    scrim: Color(0xFF020617),

    // ✨ MATERIAL OVERLAY (used in M3 elevation)
    surfaceTint: Color(0xFF1E3A8A),
  );

  // 🌙 DARK THEME — Metallic Night Steel
  static const ColorScheme dark = ColorScheme.dark(
    // 🔷 PRIMARY — Metallic Ice Blue
    primary: Color(0xFF93C5FD), // frosted steel blue
    onPrimary: Color(0xFF020617),

    // 🟢 SECONDARY — Soft Emerald Glow
    secondary: Color(0xFF34D399),
    onSecondary: Color(0xFF020617),

    // 🧱 SURFACE — Graphite Metal
    surface: Color(0xFF020617), // true dark steel
    onSurface: Color(0xFFE5E7EB),

    // ❌ ERROR
    error: Color(0xFFF87171),
    onError: Color(0xFF020617),

    // 🧩 OUTLINES / DIVIDERS
    outline: Color(0xFF334155), // steel grey
    outlineVariant: Color(0xFF1E293B),

    // 🌫 SHADOWS
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),

    // ✨ MATERIAL OVERLAY
    surfaceTint: Color(0xFF93C5FD),
  );
}
