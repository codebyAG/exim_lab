import 'package:exim_lab/core/providers/config_provider.dart';
import 'package:provider/provider.dart';
import 'package:exim_lab/core/functions/whatsapp_utils.dart';
import 'package:exim_lab/core/navigation/app_navigator.dart';
import 'package:exim_lab/features/courses/presentation/screens/courses_list_screen.dart';
import 'package:exim_lab/features/dashboard/presentation/painters/dashboard_icons_painter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class DashboardFooter extends StatelessWidget {
  const DashboardFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final config = context.watch<ConfigProvider>();
    final social = config.effectiveLinks;

    return Container(
      margin: EdgeInsets.all(5.w),
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        color: const Color(
          0xFF030E30,
        ).withValues(alpha: 0.5), // Translucent Navy
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: const Color(0xFF1E5FFF).withValues(alpha: 0.2),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          // 🌏 BRAND BLOCK
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF1040C1).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: CustomPaint(
                  size: const Size(32, 32),
                  painter: SIIEALogoPainter(),
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "SIIEA",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'Plus Jakarta Sans',
                        letterSpacing: 0.5,
                      ),
                    ),
                    Text(
                      "India's #1 Import Export Academy",
                      style: TextStyle(
                        color: const Color(0xFFFFD000),
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            "Empowering Indian entrepreneurs to go global since 1976. Join 12,000+ successful global traders.",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              height: 1.5,
            ),
          ),

          // ➖ DIVIDER
          Padding(
            padding: EdgeInsets.symmetric(vertical: 3.h),
            child: Divider(
              color: Colors.white.withValues(alpha: 0.1),
              thickness: 1,
            ),
          ),

          // 📢 FOLLOW LABEL
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Follow Us & Stay Connected",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w900,
                fontFamily: 'Plus Jakarta Sans',
              ),
            ),
          ),
          SizedBox(height: 2.5.h),

          // 📱 SOCIAL GRID (4x2)
          GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 3.w,
            crossAxisSpacing: 3.w,
            childAspectRatio: 0.75,
            children: [
              _buildSocialBtn(
                context,
                "Instagram",
                FontAwesomeIcons.instagram,
                const [Color(0xFF833AB4), Color(0xFFFD1D1D), Color(0xFFFCB045)],
                url: social.instagramUrl,
              ),
              _buildSocialBtn(
                context,
                "Facebook",
                FontAwesomeIcons.facebookF,
                const [Color(0xFF1877F2), Color(0xFF1877F2)],
                url: social.facebookUrl.isEmpty ? null : social.facebookUrl,
              ),
              _buildSocialBtn(
                context,
                "YouTube",
                FontAwesomeIcons.youtube,
                const [Color(0xFFFF0000), Color(0xFFCC0000)],
                url: social.youtubeUrl,
              ),
              _buildSocialBtn(
                context,
                "WhatsApp",
                FontAwesomeIcons.whatsapp,
                const [Color(0xFF25D366), Color(0xFF128C7E)],
                url: "WHATSAPP",
              ),
              _buildSocialBtn(
                context,
                "X (Twitter)",
                FontAwesomeIcons.xTwitter,
                const [Color(0xFF000000), Color(0xFF000000)],
                url: social.twitterUrl.isEmpty ? null : social.twitterUrl,
                isOutline: true,
              ),
              _buildSocialBtn(
                context,
                "LinkedIn",
                FontAwesomeIcons.linkedinIn,
                const [Color(0xFF0A66C2), Color(0xFF0A66C2)],
                url: social.linkedinUrl.isEmpty ? null : social.linkedinUrl,
              ),
              _buildSocialBtn(
                context,
                "Telegram",
                FontAwesomeIcons.telegram,
                const [Color(0xFF229ED9), Color(0xFF229ED9)],
                url: social.telegramUrl.isEmpty ? null : social.telegramUrl,
              ),
              _buildSocialBtn(
                context,
                "Play Store",
                FontAwesomeIcons.googlePlay,
                const [Color(0xFF3BBD70), Color(0xFF1E5FFF)],
              ),
            ],
          ),

          // ➖ DIVIDER
          Padding(
            padding: EdgeInsets.symmetric(vertical: 3.h),
            child: Divider(
              color: Colors.white.withValues(alpha: 0.1),
              thickness: 1,
            ),
          ),

          // 🔗 QUICK LINKS
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildFooterLink(
                context,
                "About Us",
                url: social.websiteUrl,
              ),
              _buildDot(),
              _buildFooterLink(context, "Courses", isCourseLink: true),
              _buildDot(),
              _buildFooterLink(context, "Contact"),
              _buildDot(),
              _buildFooterLink(context, "Privacy"),
              _buildDot(),
              _buildFooterLink(context, "Terms"),
            ],
          ),
          SizedBox(height: 2.h),

          // 🚩 COPYRIGHT
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("🇮🇳", style: TextStyle(fontSize: 12.sp)),
              SizedBox(width: 2.w),
              Text(
                "© 2025 SIIEA · Made in India with ❤️",
                style: TextStyle(
                  color: Colors.white38,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSocialBtn(
    BuildContext context,
    String label,
    dynamic icon,
    List<Color> colors, {
    bool isOutline = false,
    String? url,
  }) {
    return InkWell(
      onTap: () {
        if (url == "WHATSAPP") {
          final config = context.read<ConfigProvider>();
          WhatsAppUtils.launch(
            number: config.effectiveLinks.whatsappNumber,
            message: "Hi SIIEA team, I want to know more about your courses.",
          );
        } else if (url != null) {
          _launchSocialURL(context, url);
        } else {
          _showComingSoon(context, label);
        }
      },
      borderRadius: BorderRadius.circular(16),
      child: Column(
        children: [
          Container(
            width: 16.w,
            height: 16.w,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: colors,
              ),
              borderRadius: BorderRadius.circular(16),
              border: isOutline
                  ? Border.all(color: Colors.white30, width: 1)
                  : null,
              boxShadow: [
                BoxShadow(
                  color: colors[0].withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: FaIcon(
                icon as FaIconData?,
                color: Colors.white,
                size: 20.sp,
              ),
            ),
          ),
          SizedBox(height: 0.8.h),
          Text(
            label,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 10.sp,
              fontWeight: FontWeight.w800,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
          ),
        ],
      ),
    );
  }

  Widget _buildFooterLink(
    BuildContext context,
    String label, {
    String? url,
    bool isCourseLink = false,
  }) {
    return GestureDetector(
      onTap: () {
        if (isCourseLink) {
          AppNavigator.push(context, const CoursesListScreen());
        } else if (url != null) {
          _launchSocialURL(context, url);
        } else {
          _showComingSoon(context, label);
        }
      },
      child: Text(
        label,
        style: TextStyle(
          color: const Color(0xFF1E5FFF),
          fontSize: 12.sp,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  void _launchSocialURL(BuildContext context, String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) _showComingSoon(context, url);
      }
    } catch (e) {
      if (context.mounted) _showComingSoon(context, url);
    }
  }

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "🚀 $feature is coming soon!",
          style: const TextStyle(fontWeight: FontWeight.w900),
        ),
        backgroundColor: const Color(0xFF1E5FFF),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Widget _buildDot() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 1.5.w),
      child: Text(
        "·",
        style: TextStyle(
          color: Colors.white24,
          fontSize: 12.sp,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
