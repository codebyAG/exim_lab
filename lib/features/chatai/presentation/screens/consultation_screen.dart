import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:exim_lab/core/functions/whatsapp_utils.dart';
import 'package:exim_lab/core/providers/config_provider.dart';
import 'package:exim_lab/features/chatai/presentation/widgets/promo_hero_video.dart';

/// 1:1 Consultation — premium lead-gen screen. Booking goes to WhatsApp using
/// the dynamic handholding number from ConfigProvider.
class ConsultationScreen extends StatelessWidget {
  const ConsultationScreen({super.key});

  // 🎥 Replace with the real consultation intro video (YouTube URL/id).
  static const String _videoUrl = "";

  static const _features = <_Feature>[
    _Feature(Icons.map_rounded, "Personalized Roadmap",
        "A step-by-step plan built around your product & budget"),
    _Feature(Icons.support_agent_rounded, "1:1 Expert Mentor",
        "Direct call with an experienced import-export mentor"),
    _Feature(Icons.description_rounded, "Documentation Help",
        "IEC, licenses, invoices & customs paperwork guidance"),
    _Feature(Icons.public_rounded, "Buyer & Market Guidance",
        "Where to find international buyers and price your goods"),
    _Feature(Icons.account_balance_rounded, "Duty, GST & Costing",
        "Understand landed cost, duties and profit margins"),
    _Feature(Icons.verified_rounded, "Ongoing Support",
        "Follow-up support so you never get stuck"),
  ];

  void _book(BuildContext context) {
    final config = context.read<ConfigProvider>();
    WhatsAppUtils.launch(
      number: config.effectiveLinks.handholdingWhatsappNumber,
      message:
          "Hi, I want to book a 1:1 Consultation for my Import-Export business.",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // ── Navy hero ──
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
                  Row(
                    children: [
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        borderRadius: BorderRadius.circular(30),
                        child: const Padding(
                          padding: EdgeInsets.all(6),
                          child: Icon(Icons.arrow_back_rounded,
                              color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: Color(0xFFFFD000).withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "PREMIUM 1:1 SESSION",
                      style: TextStyle(
                        color: Color(0xFFFFD000),
                        fontWeight: FontWeight.w900,
                        fontSize: 11,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    "Personal 1:1 Consultation",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Get a dedicated expert who guides you personally — from zero to your first export order.",
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.75),
                      fontSize: 13.5,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 18),
                  const PromoHeroVideo(videoUrl: _videoUrl),
                ],
              ),
            ),
          ),

          // ── What you get ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
              child: Text(
                "What you get",
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
              (context, i) => _FeatureTile(feature: _features[i]),
              childCount: _features.length,
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
        ],
      ),

      // ── Sticky Book CTA ──
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
          child: SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton.icon(
              onPressed: () => _book(context),
              icon: const Icon(Icons.chat_rounded, size: 20),
              label: const Text(
                "Book My Session",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF0A2066),
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
}

class _Feature {
  final IconData icon;
  final String title;
  final String subtitle;
  const _Feature(this.icon, this.title, this.subtitle);
}

class _FeatureTile extends StatelessWidget {
  final _Feature feature;
  const _FeatureTile({required this.feature});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Color(0xFF94A3B8).withValues(alpha: 0.22)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Color(0xFF1E5FFF).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(feature.icon, color: Color(0xFF1E5FFF), size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    feature.title,
                    style: const TextStyle(
                      color: Color(0xFF0A2066),
                      fontSize: 14.5,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    feature.subtitle,
                    style: TextStyle(
                      color: Color(0xFF334155),
                      fontSize: 12,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
