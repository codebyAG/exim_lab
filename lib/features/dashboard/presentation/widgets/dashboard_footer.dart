import 'package:exim_lab/features/dashboard/presentation/painters/dashboard_icons_painter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sizer/sizer.dart';

class DashboardFooter extends StatelessWidget {
  const DashboardFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5.w),
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        color: const Color(0xFF030E30).withValues(alpha: 0.5), // Translucent Navy
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
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'Plus Jakarta Sans',
                        letterSpacing: 0.5,
                      ),
                    ),
                    Text(
                      "India's #1 Import Export Academy",
                      style: TextStyle(
                        color: const Color(0xFFFFD000),
                        fontSize: 9.sp,
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
              fontSize: 10.sp,
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
                fontSize: 14.sp,
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
            childAspectRatio: 0.9,
            children: [
              _buildSocialBtn(
                "Instagram",
                FontAwesomeIcons.instagram,
                const [Color(0xFF833AB4), Color(0xFFFD1D1D), Color(0xFFFCB045)],
              ),
              _buildSocialBtn(
                "Facebook",
                FontAwesomeIcons.facebookF,
                const [Color(0xFF1877F2), Color(0xFF1877F2)],
              ),
              _buildSocialBtn(
                "YouTube",
                FontAwesomeIcons.youtube,
                const [Color(0xFFFF0000), Color(0xFFCC0000)],
              ),
              _buildSocialBtn(
                "WhatsApp",
                FontAwesomeIcons.whatsapp,
                const [Color(0xFF25D366), Color(0xFF128C7E)],
              ),
              _buildSocialBtn(
                "X (Twitter)",
                FontAwesomeIcons.xTwitter,
                const [Color(0xFF000000), Color(0xFF000000)],
                isOutline: true,
              ),
              _buildSocialBtn(
                "LinkedIn",
                FontAwesomeIcons.linkedinIn,
                const [Color(0xFF0A66C2), Color(0xFF0A66C2)],
              ),
              _buildSocialBtn(
                "Telegram",
                FontAwesomeIcons.telegram,
                const [Color(0xFF229ED9), Color(0xFF229ED9)],
              ),
              _buildSocialBtn(
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
              _buildFooterLink("About Us"),
              _buildDot(),
              _buildFooterLink("Courses"),
              _buildDot(),
              _buildFooterLink("Contact"),
              _buildDot(),
              _buildFooterLink("Privacy"),
              _buildDot(),
              _buildFooterLink("Terms"),
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
                  fontSize: 8.5.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSocialBtn(String label, dynamic icon, List<Color> colors,
      {bool isOutline = false}) {
    return Column(
      children: [
        Container(
          width: 14.w,
          height: 14.w,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: colors,
            ),
            borderRadius: BorderRadius.circular(16),
            border: isOutline ? Border.all(color: Colors.white30, width: 1) : null,
            boxShadow: [
              BoxShadow(
                color: colors[0].withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Icon(icon, color: Colors.white, size: 16.sp),
          ),
        ),
        SizedBox(height: 0.8.h),
        Text(
          label,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 7.sp,
            fontWeight: FontWeight.w800,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
        ),
      ],
    );
  }

  Widget _buildFooterLink(String label) {
    return Text(
      label,
      style: TextStyle(
        color: const Color(0xFF1E5FFF),
        fontSize: 9.sp,
        fontWeight: FontWeight.w800,
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
          fontSize: 10.sp,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
