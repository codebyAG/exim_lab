import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:exim_lab/core/functions/whatsapp_utils.dart';
import 'package:exim_lab/core/providers/config_provider.dart';
import 'package:exim_lab/core/services/notification_router.dart';

/// Global draggable help button.
///
/// Wrapped around the whole app via [MaterialApp.builder] so it floats over
/// every screen (login included). The user can drag it anywhere; on release it
/// snaps to the nearest side edge and keeps that spot for the session.
class FloatingHelpButton extends StatefulWidget {
  final Widget child;
  const FloatingHelpButton({super.key, required this.child});

  // Hidden on the splash screen — SplashScreen flips this in initState /
  // dispose, since there's no logged-in/logged-out screen for it to help
  // with yet at that point.
  static final ValueNotifier<bool> visible = ValueNotifier(true);

  @override
  State<FloatingHelpButton> createState() => _FloatingHelpButtonState();
}

class _FloatingHelpButtonState extends State<FloatingHelpButton> {
  static const double _width = 52;
  static const double _height = 52;
  static const double _margin = 12;

  // Kept static so the button holds its position across screen changes.
  static Offset? _position;

  // Drives only the button's own rebuild during drag — setState() here
  // would rebuild the whole app (widget.child sits in the same Stack),
  // which is what made dragging feel sluggish on a large widget tree.
  final ValueNotifier<bool> _dragging = ValueNotifier(false);
  late final ValueNotifier<Offset> _pos;

  @override
  void initState() {
    super.initState();
    _pos = ValueNotifier(_position ?? Offset.zero);
  }

  @override
  void dispose() {
    _pos.dispose();
    _dragging.dispose();
    super.dispose();
  }

  void _snapToEdge(Size screen, EdgeInsets padding) {
    final pos = _pos.value;
    final snapRight = pos.dx + _width / 2 > screen.width / 2;

    final minY = padding.top + _margin;
    final maxY = screen.height - padding.bottom - _height - _margin;
    _dragging.value = false;
    _position = Offset(
      snapRight ? screen.width - _width - _margin : _margin,
      pos.dy.clamp(minY, maxY <= minY ? minY : maxY),
    );
    _pos.value = _position!;
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

  static const _button = Material(
    type: MaterialType.transparency,
    child: _ButtonFace(),
  );

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final screen = media.size;
    final padding = media.padding;

    // Defaults to the bottom-LEFT so it never sits on top of the blue
    // "AI Support" FAB, which lives bottom-right on the dashboard. Synced
    // into _pos once, outside setState, so the very first build doesn't
    // need a rebuild of the whole (heavy) widget.child subtree.
    if (_position == null) {
      _position = Offset(
        _margin,
        screen.height - padding.bottom - _height - 120,
      );
      _pos.value = _position!;
    }

    return Stack(
      children: [
        widget.child,
        ValueListenableBuilder<bool>(
          valueListenable: FloatingHelpButton.visible,
          builder: (context, isVisible, child) =>
              isVisible ? child! : const SizedBox.shrink(),
          // Hidden until ConfigProvider.loadConfig() has finished — its
          // WhatsApp number should come from the API, not the hardcoded
          // fallback, and showing the button before that resolves risks
          // it firing with a stale/default number if tapped immediately.
          // Gates on isLoading (not on links != null) so a failed load
          // still reveals the button (with its fallback number) instead
          // of hiding help forever.
          child: Selector<ConfigProvider, bool>(
            selector: (_, config) => !config.isLoading,
            builder: (context, configReady, child) =>
                configReady ? child! : const SizedBox.shrink(),
            child: ValueListenableBuilder<Offset>(
              valueListenable: _pos,
              builder: (context, pos, child) {
                return Positioned(
                  left: pos.dx,
                  top: pos.dy,
                  // GestureDetector + notifiers instead of setState() —
                  // this button sits above the Navigator (MaterialApp
                  // .builder), so a setState() here previously forced
                  // Flutter to diff the *entire app's* element tree on
                  // every drag frame, which is what made dragging feel
                  // sluggish.
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: _openHelp,
                    onPanStart: (_) => _dragging.value = true,
                    onPanUpdate: (details) {
                      final next = pos + details.delta;
                      _position = Offset(
                        next.dx.clamp(0.0, screen.width - _width),
                        next.dy.clamp(
                          padding.top,
                          screen.height - padding.bottom - _height,
                        ),
                      );
                      _pos.value = _position!;
                    },
                    onPanEnd: (_) => _snapToEdge(screen, padding),
                    onPanCancel: () => _snapToEdge(screen, padding),
                    child: child,
                  ),
                );
              },
              // This button sits above the Navigator (via MaterialApp
              // .builder), so it has no Scaffold/Material ancestor of its
              // own — without this, Text/Icon fall back to a debug-only
              // underline style.
              child: ValueListenableBuilder<bool>(
                valueListenable: _dragging,
                builder: (context, dragging, child) => AnimatedScale(
                  scale: dragging ? 1.06 : 1.0,
                  duration: const Duration(milliseconds: 150),
                  child: child,
                ),
                child: _button,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ButtonFace extends StatelessWidget {
  const _ButtonFace();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _FloatingHelpButtonState._width,
      height: _FloatingHelpButtonState._height,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
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
      child: const Icon(Icons.headset_mic_rounded, color: Colors.white, size: 24),
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
                final number = context
                    .read<ConfigProvider>()
                    .effectiveLinks
                    .whatsappNumber;
                Navigator.pop(context);
                WhatsAppUtils.launch(
                  number: number,
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
