import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:exim_lab/core/functions/whatsapp_utils.dart';
import 'package:exim_lab/core/providers/config_provider.dart';
import 'package:exim_lab/core/services/internal_link_router.dart';
import 'package:exim_lab/features/profile_questions/data/models/profile_questions_model.dart';
import 'package:exim_lab/features/profile_questions/presentation/providers/profile_questions_provider.dart';
import 'package:exim_lab/features/profile_questions/presentation/widgets/profile_questionnaire_dialog.dart';

const _navy = Color(0xFF030E30);
const _gold = Color(0xFFFFD000);

/// Server-driven home banner from `GET /api/profile-questions` — replaces
/// the old hard-coded "Your Progress" bar. Renders exactly what the server
/// sends (title/subtitle/CTA copy, and whichever of the two banner states
/// is currently active) — see PROFILE_QUESTIONS.md §3.
class ProfileQuestionsBanner extends StatelessWidget {
  const ProfileQuestionsBanner({super.key});

  void _handleTap(BuildContext context, ProfileQuestionsBannerData banner) {
    switch (banner.action) {
      case 'open_questionnaire':
        showDialog(
          context: context,
          builder: (_) => const ProfileQuestionnaireDialog(),
        );
        break;
      case 'whatsapp':
        final configuredNumber =
            context.read<ConfigProvider>().effectiveLinks.whatsappNumber;
        WhatsAppUtils.launch(
          number: banner.actionValue.isNotEmpty
              ? banner.actionValue
              : configuredNumber,
          message: 'Hi, I saw "${banner.title}" — tell me more.',
        );
        break;
      case 'call':
        if (banner.actionValue.isNotEmpty) {
          launchUrlString('tel:${banner.actionValue}');
        }
        break;
      case 'internal':
        if (banner.actionValue.isNotEmpty) {
          if (!InternalLinkRouter.tryOpen(context, banner.actionValue)) {
            launchUrlString(banner.actionValue);
          }
        }
        break;
      case 'external_url':
        if (banner.actionValue.isNotEmpty) {
          launchUrlString(banner.actionValue);
        }
        break;
      case 'none':
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileQuestionsProvider>(
      builder: (context, provider, _) {
        final banner = provider.data?.banner;
        if (banner == null || !banner.isVisible) return const SizedBox.shrink();

        final tappable = banner.action != 'none';

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
          child: InkWell(
            onTap: tappable ? () => _handleTap(context, banner) : null,
            borderRadius: BorderRadius.circular(24),
            child: Container(
              decoration: BoxDecoration(
                color: _navy,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: const Color(0xFF1E5FFF).withValues(alpha: 0.25),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.2.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              banner.title,
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                fontFamily: 'Plus Jakarta Sans',
                                letterSpacing: -0.5,
                              ),
                            ),
                            if (banner.subtitle.isNotEmpty) ...[
                              SizedBox(height: 0.8.h),
                              Text(
                                banner.subtitle,
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  color: Colors.white.withValues(alpha: 0.55),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                            if (banner.ctaLabel.isNotEmpty) ...[
                              SizedBox(height: 1.6.h),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 4.w,
                                  vertical: 1.h,
                                ),
                                decoration: BoxDecoration(
                                  color: _gold,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  banner.ctaLabel,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 11.5.sp,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    if (banner.imageUrl.isNotEmpty)
                      SizedBox(
                        width: 28.w,
                        child: CachedNetworkImage(
                          imageUrl: banner.imageUrl,
                          fit: BoxFit.cover,
                          height: double.infinity,
                          width: double.infinity,
                          errorWidget: (_, _, _) => const SizedBox.shrink(),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
