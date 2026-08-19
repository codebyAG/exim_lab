import 'package:flutter/material.dart';
import 'package:exim_lab/core/functions/whatsapp_utils.dart';
import 'package:exim_lab/core/services/notification_router.dart';

/// Global draggable help button.
///
/// Wrapped around the whole app via [MaterialApp.builder] so it floats over
/// every screen (login included). The user can drag it anywhere; on release it
/// snaps to the nearest side edge and keeps that spot for the session.
class FloatingHelpButton extends StatefulWidget {
  final Widget child;
  const FloatingHelpButton({super.key, required this.child});

  @override
  State<FloatingHelpButton> createState() => _FloatingHelpButtonState();
}

class _FloatingHelpButtonState extends State<FloatingHelpButton> {
  static const double _width = 116;
  static const double _height = 46;
  static const double _margin = 12;

  // Kept static so the button holds its position across screen changes.
  static Offset? _position;

  bool _dragging = false;

  void _snapToEdge(Size screen, EdgeInsets padding) {
    final pos = _position;
    if (pos == null) return;
    final snapRight = pos.dx + _width / 2 > screen.width / 2;

    final minY = padding.top + _margin;
    final maxY = screen.height - padding.bottom - _height - _margin;
    setState(() {
      _dragging = false;
      _position = Offset(
        snapRight ? screen.width - _width - _margin : _margin,
        pos.dy.clamp(minY, maxY <= minY ? minY : maxY),
      );
    });
  }

  void _openHelp() {
    // This widget wraps the Navigator (via MaterialApp.builder), so its own
    // `context` has no Navigator ancestor — use the app's global one instead.
    final navContext = NotificationRouter.navigatorKey.currentContext;
    if (navContext == null) return;
    showModalBottomSheet(
      context: navContext,
      backgroundColor: Colors.transparent,
      builder: (_) => const _HelpSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final screen = media.size;
    final padding = media.padding;

    // Defaults to the bottom-LEFT so it never sits on top of the blue
    // "AI Support" FAB, which lives bottom-right on the dashboard.
    final pos =
        _position ??
        Offset(_margin, screen.height - padding.bottom - _height - 120);

    return Stack(
      children: [
        widget.child,
        Positioned(
          left: pos.dx,
          top: pos.dy,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _openHelp,
            onPanStart: (_) => setState(() => _dragging = true),
            onPanUpdate: (details) {
              setState(() {
                final next = pos + details.delta;
                _position = Offset(
                  next.dx.clamp(0.0, screen.width - _width),
                  next.dy.clamp(
                    padding.top,
                    screen.height - padding.bottom - _height,
                  ),
                );
              });
            },
            onPanEnd: (_) => _snapToEdge(screen, padding),
            onPanCancel: () => _snapToEdge(screen, padding),
            child: AnimatedScale(
              scale: _dragging ? 1.06 : 1.0,
              duration: const Duration(milliseconds: 150),
              // This button sits above the Navigator (via MaterialApp.builder),
              // so it has no Scaffold/Material ancestor of its own — without
              // this, Text/Icon fall back to a debug-only underline style.
              child: Material(
                type: MaterialType.transparency,
                child: Container(
                  width: _width,
                  height: _height,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(_height / 2),
                    // WhatsApp green — deliberately distinct from the blue
                    // "AI Support" FAB so the two are never confused.
                    gradient: const LinearGradient(
                      colors: [Color(0xFF25D366), Color(0xFF128C4A)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.35),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF25D366).withValues(alpha: 0.45),
                        blurRadius: 18,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.headset_mic_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Text(
                        "Help",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _HelpSheet extends StatelessWidget {
  const _HelpSheet();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 42,
              height: 4,
              decoration: BoxDecoration(
                color: cs.onSurface.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "Need Help?",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: cs.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Our team replies within minutes",
              style: TextStyle(
                fontSize: 13,
                color: cs.onSurface.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 18),
            _tile(
              context,
              Icons.chat_rounded,
              "Chat on WhatsApp",
              const Color(0xFF25D366),
              () {
                Navigator.pop(context);
                WhatsAppUtils.launch(
                  message:
                      "Hi, I need help with the Import Export Academy app.",
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _tile(
    BuildContext context,
    IconData icon,
    String label,
    Color color,
    VoidCallback onTap,
  ) {
    final cs = Theme.of(context).colorScheme;
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        backgroundColor: color.withValues(alpha: 0.15),
        child: Icon(icon, color: color),
      ),
      title: Text(
        label,
        style: TextStyle(fontWeight: FontWeight.w700, color: cs.onSurface),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios_rounded,
        size: 14,
        color: cs.onSurface.withValues(alpha: 0.4),
      ),
    );
  }
}
