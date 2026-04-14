import 'package:flutter/material.dart';

class AppColorSchemes {
  // 🎨 GLOBAL TRADE THEME — Premium Navy & Red
  static const ColorScheme light = ColorScheme.light(
    // 🟦 PRIMARY — Deep Global Navy
    primary: Color(0xFF0A2066),
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFFE8F0FF),
    onPrimaryContainer: Color(0xFF0A2066),

    // 🟥 SECONDARY — Flag Red
    secondary: Color(0xFFC8151B),
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFFFFDADA),
    onSecondaryContainer: Color(0xFF410002),

    // 🧱 SURFACE — Clean Blue-tinted Off-White
    surface: Color(0xFFF8FAFC),
    onSurface: Color(0xFF020C28),
    surfaceContainerHighest: Color(0xFFE1E8F0),

    // ❌ ERROR
    error: Color(0xFFB00020),
    onError: Color(0xFFFFFFFF),

    // 🧩 OUTLINES
    outline: Color(0xFFBDC3C7),
    outlineVariant: Color(0xFFECF0F1),
  );

  static const ColorScheme dark = ColorScheme.dark(
    // 🟦 PRIMARY — Accent Blue / Navy
    primary: Color(0xFF1E5FFF),
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFF0A2066),
    onPrimaryContainer: Color(0xFFD6E2FF),

    // 🟥 SECONDARY — Vibrant Red
    secondary: Color(0xFFFF2D35),
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFF93000A),
    onSecondaryContainer: Color(0xFFFFDAD6),

    // 🧱 SURFACE — Deep Space Navy
    surface: Color(0xFF020C28),
    onSurface: Color(0xFFFFFFFF),
    surfaceContainerHighest: Color(0xFF05133A),

    // ❌ ERROR
    error: Color(0xFFF87171),
    onError: Color(0xFFFFFFFF),

    // 🧩 OUTLINES
    outline: Color(0xFF1E293B),
    outlineVariant: Color(0xFF05133A),
  );
}
