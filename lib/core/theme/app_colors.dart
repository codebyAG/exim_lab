import 'package:flutter/material.dart';

/// Central palette matching the app mockup. Use these instead of one-off hex
/// values so every screen stays on-theme.
class AppColors {
  AppColors._();

  /// Primary deep navy — headers, primary buttons, titles.
  static const Color navy = Color(0xFF0A2066);

  /// Darkest navy — header background / premium dark cards.
  static const Color navyDark = Color(0xFF020C28);

  /// Gold / amber accent — highlighted words, premium.
  static const Color gold = Color(0xFFFFD000);

  /// Brand red — secondary accent, live badges.
  static const Color red = Color(0xFFC8151B);

  /// Bright blue — links, active states, "See All", chips.
  static const Color blue = Color(0xFF1E5FFF);

  /// Success green — completed / correct.
  static const Color green = Color(0xFF1BA672);

  /// Light page background (slightly grey so white cards pop).
  static const Color lightBg = Color(0xFFEEF2F8);

  /// Muted slate — secondary text, borders on light.
  static const Color slate = Color(0xFF94A3B8);

  /// Body text on light surfaces.
  static const Color slateText = Color(0xFF334155);
}
