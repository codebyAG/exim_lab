import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:exim_lab/localization/app_localization.dart';
import 'package:exim_lab/features/dashboard/presentation/widgets/section_header.dart';

class SocialConnectSection extends StatelessWidget {
  const SocialConnectSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final t = AppLocalizations.of(context);

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
              color: cs.surface,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: cs.outlineVariant.withValues(alpha: 0.5),
              ),
              boxShadow: [
                BoxShadow(
                  color: cs.shadow.withValues(alpha: 0.05),
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
                  label: "Youtube 1",
                  color: const Color(0xFFFF0000),
                  onTap: () => launchUrl(
                    Uri.parse(
                      "https://youtu.be/f7eSa2jkUZM?si=Krq_Ke-2fPaj6obO",
                    ),
                    mode: LaunchMode.externalApplication,
                  ),
                ),
                _socialIcon(
                  assetPath: 'assets/icons/youtube.png',
                  label: "Youtube 2",
                  color: const Color(0xFFFF0000),
                  onTap: () => launchUrl(
                    Uri.parse(
                      "https://youtu.be/HiyHpVwbGgw?si=XcdW0LDkUDaRZoB8",
                    ),
                    mode: LaunchMode.externalApplication,
                  ),
                ),
                _socialIcon(
                  assetPath: 'assets/icons/instagram.png',
                  label: "Instagram",
                  color: const Color(0xFFE4405F),
                  onTap: () => launchUrl(
                    Uri.parse("https://www.instagram.com/siieadigital"),
                    mode: LaunchMode.externalApplication,
                  ),
                ),
                _socialIcon(
                  icon: Icons.language_rounded,
                  label: t.translate('website'),
                  color: const Color(0xFF0077B5),
                  onTap: () => launchUrl(
                    Uri.parse("https://www.siiea.in"),
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
              ? Image.asset(assetPath, width: 40, height: 40)
              : Icon(icon, color: color, size: 40),
          const SizedBox(height: 10),
          Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
