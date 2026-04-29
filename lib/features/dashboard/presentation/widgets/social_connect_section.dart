import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import 'package:exim_lab/core/providers/config_provider.dart';
import 'package:exim_lab/localization/app_localization.dart';
import 'package:exim_lab/features/dashboard/presentation/widgets/section_header.dart';

class SocialConnectSection extends StatelessWidget {
  const SocialConnectSection({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final config = context.watch<ConfigProvider>();
    final social = config.effectiveLinks;

    return Column(
      children: [
        SectionHeader(
          title: t.translate('follow_us'),
          subtitle: t.translate('join_trade_community'),
        ),
        SizedBox(height: 1.5.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 4.w),
            decoration: BoxDecoration(
              color: const Color(0xFF030E30), // Matching Deep Navy
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.1),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 4,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.85,
              children: [
                _socialIcon(
                  assetPath: 'assets/icons/youtube.png',
                  label: "YouTube",
                  color: const Color(0xFFFF0000),
                  onTap: () => launchUrl(
                    Uri.parse(social.youtubeUrl),
                    mode: LaunchMode.externalApplication,
                  ),
                ),
                _socialIcon(
                  assetPath: 'assets/icons/instagram.png',
                  label: "Instagram",
                  color: const Color(0xFFE4405F),
                  onTap: () => launchUrl(
                    Uri.parse(social.instagramUrl),
                    mode: LaunchMode.externalApplication,
                  ),
                ),
                _socialIcon(
                  assetPath: 'assets/icons/facebook.png',
                  label: "Facebook",
                  color: const Color(0xFF1877F2),
                  onTap: () {
                    if (social.facebookUrl.isNotEmpty) {
                      launchUrl(
                        Uri.parse(social.facebookUrl),
                        mode: LaunchMode.externalApplication,
                      );
                    }
                  },
                ),
                _socialIcon(
                  icon: Icons.language_rounded,
                  label: t.translate('website'),
                  color: const Color(0xFF00B0FF),
                  onTap: () => launchUrl(
                    Uri.parse(social.websiteUrl),
                    mode: LaunchMode.externalApplication,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _socialIcon({
    IconData? icon,
    String? assetPath,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          assetPath != null
              ? Image.asset(assetPath, width: 36, height: 36)
              : Icon(icon, color: color, size: 36),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white.withValues(alpha: 0.8),
              fontFamily: 'Plus Jakarta Sans',
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
