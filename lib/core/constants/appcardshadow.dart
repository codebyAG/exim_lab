import 'package:flutter/material.dart';

List<BoxShadow> appCardShadow(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  return [
    BoxShadow(
      color: isDark
          ? Colors.black.withOpacity(0.4)
          : Colors.black.withOpacity(0.08),
      blurRadius: 16,
      offset: const Offset(0, 8),
    ),
  ];
}
