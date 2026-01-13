import 'package:flutter/material.dart';

class DotsIndicator extends StatelessWidget {
  final int count;
  final int currentIndex;

  const DotsIndicator({required this.count, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final bool isActive = index == currentIndex;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          margin: const EdgeInsets.symmetric(horizontal: 6),
          height: 7,
          width: 7,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive
                ? Colors
                      .white // ✅ ACTIVE ALWAYS WHITE
                : isDark
                ? Colors.white.withOpacity(0.35)
                : Colors.black.withOpacity(0.3),
          ),
        );
      }),
    );
  }
}


