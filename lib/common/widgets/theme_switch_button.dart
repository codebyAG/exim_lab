import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:exim_lab/core/theme/theme_provider.dart';

class ThemeSwitchButton extends StatelessWidget {
  const ThemeSwitchButton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeProvider = context.watch<ThemeProvider>();

    // 🔹 Resolve actual brightness (important for system mode)
    final isDark =
        themeProvider.themeMode == ThemeMode.dark ||
        (themeProvider.themeMode == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);

    return GestureDetector(
      onTap: () {
        // ✅ USE YOUR EXISTING toggleTheme()
        themeProvider.toggleTheme();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          // ✅ Always readable on image backgrounds
          color: Colors.black.withOpacity(0.28),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.35)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isDark ? Icons.dark_mode : Icons.light_mode,
              size: 16,
              color: Colors.white,
            ),
            const SizedBox(width: 6),
            Text(
              _label(themeProvider.themeMode, isDark),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔹 Text based on ThemeMode
  String _label(ThemeMode mode, bool isDarkResolved) {
    switch (mode) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return isDarkResolved ? 'System (Dark)' : 'System (Light)';
    }
  }
}
