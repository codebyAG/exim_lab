import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PremiumUnlockDialog extends StatelessWidget {
  const PremiumUnlockDialog({super.key});

  void _launchWhatsApp(BuildContext context) async {
    const url =
        "https://wa.me/919871769042?text=Hi%2C%20I%20want%20to%20unlock%20Import%20Export%20Premium%20membership.";
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1A0A2E), Color(0xFF16213E)],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFF6862A).withValues(alpha: 0.3),
              blurRadius: 40,
              spreadRadius: 4,
            ),
          ],
        ),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ── Header ──────────────────────────────
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(28),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(0xFFF6862A),
                          const Color(0xFFFF5722).withValues(alpha: 0.85),
                        ],
                      ),
                    ),
                    child: Column(
                      children: [
                        // Crown emoji badge
                        Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: 0.15),
                          ),
                          child: const Center(
                            child: Text('👑', style: TextStyle(fontSize: 38)),
                          ),
                        ),
                        const SizedBox(height: 14),
                        const Text(
                          'Unlock All Features',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: 0.2,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Get full access to everything in\nImport Export Premium',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13.5,
                            color: Colors.white.withValues(alpha: 0.88),
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ── Features List ────────────────────────
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                    child: Column(
                      children: [
                        _PremiumFeatureTile(
                          icon: '🎓',
                          title: 'Full Course Library',
                          subtitle:
                              'Unlimited access to all import-export courses & lessons',
                        ),
                        _PremiumFeatureTile(
                          icon: '🤖',
                          title: 'AI Trade Expert',
                          subtitle:
                              'Get instant answers from our AI on any trade query',
                        ),
                        _PremiumFeatureTile(
                          icon: '⚡',
                          title: 'All Business Tools',
                          subtitle:
                              'Export Price, GST, Incoterms & advanced calculators',
                        ),
                        _PremiumFeatureTile(
                          icon: '📽️',
                          title: 'Shorts & Quizzes',
                          subtitle:
                              'Bite-sized videos & skill-testing quizzes, anytime',
                        ),
                        _PremiumFeatureTile(
                          icon: '🏆',
                          title: 'Certificates & Gallery',
                          subtitle: 'Earn certificates & exclusive event gallery',
                          isLast: true,
                        ),
                      ],
                    ),
                  ),

                  // ── Buttons ──────────────────────────────
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                    child: Column(
                      children: [
                        // Unlock button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => _launchWhatsApp(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFF6862A),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              elevation: 0,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text(
                                  '🔓  Unlock Premium',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Maybe later
                        InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () => Navigator.pop(context),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            child: Text(
                              'Maybe later',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.5),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.close_rounded,
                  color: Colors.white70,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Feature tile widget
// ─────────────────────────────────────────────────────────────────────────────

class _PremiumFeatureTile extends StatelessWidget {
  final String icon;
  final String title;
  final String subtitle;
  final bool isLast;

  const _PremiumFeatureTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Icon badge
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFF6862A).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(icon, style: const TextStyle(fontSize: 22)),
                ),
              ),
              const SizedBox(width: 14),
              // Text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.55),
                        fontSize: 12,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              // Checkmark
              const Icon(
                Icons.check_circle_rounded,
                color: Color(0xFFF6862A),
                size: 20,
              ),
            ],
          ),
        ),
        if (!isLast)
          Divider(
            color: Colors.white.withValues(alpha: 0.07),
            height: 1,
            thickness: 1,
          ),
      ],
    );
  }
}
