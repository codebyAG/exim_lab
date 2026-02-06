import 'package:flutter/material.dart';

class AnimatedSearchBar extends StatefulWidget {
  final VoidCallback? onTap;
  final List<String> hints;

  const AnimatedSearchBar({super.key, this.onTap, required this.hints});

  @override
  State<AnimatedSearchBar> createState() => _AnimatedSearchBarState();
}

class _AnimatedSearchBarState extends State<AnimatedSearchBar> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _startHintRotation();
  }

  void _startHintRotation() async {
    while (mounted) {
      await Future.delayed(const Duration(seconds: 3));
      if (!mounted) return;
      setState(() {
        _currentIndex = (_currentIndex + 1) % widget.hints.length;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withValues(alpha: 0.45)
                  : Colors.black.withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(Icons.search, color: cs.onSurface.withValues(alpha: 0.5)),
            const SizedBox(width: 12),

            // 🔥 ANIMATED HINT
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft, // 🔥 THIS LINE FIXES IT

                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) {
                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.3),
                        end: Offset.zero,
                      ).animate(animation),
                      child: FadeTransition(opacity: animation, child: child),
                    );
                  },
                  child: Text(
                    widget.hints[_currentIndex],
                    key: ValueKey(_currentIndex),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: cs.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ),
              ),
            ),

            Icon(Icons.tune, color: cs.onSurface.withValues(alpha: 0.4)),
          ],
        ),
      ),
    );
  }
}
