import 'package:flutter/material.dart';
import 'package:exim_lab/core/theme/app_colors.dart';

/// A button that runs an async [onPressed], showing a spinner and disabling
/// itself until the future completes. Prevents duplicate API calls from
/// double taps.
///
/// Usage:
/// ```dart
/// AsyncButton(
///   label: 'Enroll Now',
///   onPressed: () => provider.enroll(id),
/// )
/// ```
class AsyncButton extends StatefulWidget {
  final String label;
  final Future<void> Function()? onPressed;
  final Color color;
  final Color foreground;
  final double height;
  final double radius;
  final IconData? icon;
  final bool expand;

  const AsyncButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.color = AppColors.navy,
    this.foreground = Colors.white,
    this.height = 54,
    this.radius = 16,
    this.icon,
    this.expand = true,
  });

  @override
  State<AsyncButton> createState() => _AsyncButtonState();
}

class _AsyncButtonState extends State<AsyncButton> {
  bool _loading = false;

  Future<void> _handleTap() async {
    if (_loading || widget.onPressed == null) return; // guard re-entry
    setState(() => _loading = true);
    try {
      await widget.onPressed!();
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool disabled = _loading || widget.onPressed == null;

    final button = SizedBox(
      height: widget.height,
      child: ElevatedButton(
        onPressed: disabled ? null : _handleTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: widget.color,
          foregroundColor: widget.foreground,
          disabledBackgroundColor: widget.color.withValues(alpha: 0.5),
          disabledForegroundColor: widget.foreground,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(widget.radius),
          ),
        ),
        child: _loading
            ? SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: widget.foreground,
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.icon != null) ...[
                    Icon(widget.icon, size: 20),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    widget.label,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
      ),
    );

    return widget.expand ? SizedBox(width: double.infinity, child: button) : button;
  }
}
