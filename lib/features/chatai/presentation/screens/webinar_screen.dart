import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:exim_lab/core/functions/whatsapp_utils.dart';
import 'package:exim_lab/core/providers/config_provider.dart';
import 'package:exim_lab/features/chatai/presentation/widgets/promo_hero_video.dart';

/// Free LIVE webinar registration. Date/time/topics come from the live-event
/// config; registration goes to WhatsApp using the dynamic live number.
class WebinarScreen extends StatelessWidget {
  const WebinarScreen({super.key});

  // 🎥 Replace with the real webinar intro video (YouTube URL/id).
  static const String _videoUrl = "";

  void _register(BuildContext context) {
    final config = context.read<ConfigProvider>();
    final webinar = config.effectiveLiveEvent.webinar;
    WhatsAppUtils.launch(
      number: config.effectiveLinks.liveWhatsappNumber,
      message: webinar.whatsappMessage,
    );
  }

  @override
  Widget build(BuildContext context) {
    final event = context.watch<ConfigProvider>().effectiveLiveEvent;
    final webinar = event.webinar;

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // ── Hero ──
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.fromLTRB(
                14,
                MediaQuery.of(context).padding.top + 10,
                14,
                4,
              ),
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(18, 14, 18, 22),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF0A2066), Color(0xFF020C28)],
                ),
                borderRadius: BorderRadius.all(Radius.circular(24)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    borderRadius: BorderRadius.circular(30),
                    child: const Padding(
                      padding: EdgeInsets.all(6),
                      child:
                          Icon(Icons.arrow_back_rounded, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Color(0xFFC8151B),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.sensors_rounded,
                                color: Colors.white, size: 13),
                            SizedBox(width: 4),
                            Text(
                              "FREE LIVE",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    webinar.title ?? "Weekly Import/Export Webinar",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Date + time pills
                  Row(
                    children: [
                      _pill(Icons.calendar_today_rounded,
                          "${webinar.day} ${webinar.month}"),
                      const SizedBox(width: 10),
                      _pill(Icons.access_time_rounded, "${webinar.time} IST"),
                    ],
                  ),
                  const SizedBox(height: 18),
                  const PromoHeroVideo(videoUrl: _videoUrl),
                ],
              ),
            ),
          ),

          // ── What you'll learn ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
              child: Text(
                "What you'll learn",
                style: TextStyle(
                  color: Color(0xFF0A2066),
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, i) => _LearnTile(text: event.achievements[i]),
              childCount: event.achievements.length,
            ),
          ),

          // ── Free note ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Color(0xFF1BA672).withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(14),
                  border:
                      Border.all(color: Color(0xFF1BA672).withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.card_giftcard_rounded,
                        color: Color(0xFF1BA672), size: 22),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "100% Free — limited seats. Register on WhatsApp to get the joining link.",
                        style: TextStyle(
                          color: Color(0xFF334155),
                          fontSize: 12.5,
                          height: 1.4,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),

      // ── Sticky Register CTA ──
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
          child: SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton.icon(
              onPressed: () => _register(context),
              icon: const Icon(Icons.sensors_rounded, size: 20),
              label: const Text(
                "Register Free",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFC8151B),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _pill(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Color(0xFFFFD000), size: 15),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _LearnTile extends StatelessWidget {
  final String text;
  const _LearnTile({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle_rounded,
              color: Color(0xFF1BA672), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Color(0xFF334155),
                fontSize: 14,
                height: 1.4,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
