import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:animate_do/animate_do.dart';
import 'package:exim_lab/core/navigation/app_navigator.dart';
import 'package:exim_lab/features/dashboard/data/models/dashboard_response.dart';
import 'package:exim_lab/features/freevideos/data/models/free_videos_model.dart';
import 'package:exim_lab/features/freevideos/presentation/screens/free_videos_details_screen.dart';

class MasterclassHighlightCard extends StatelessWidget {
  final DashboardResponse data;

  const MasterclassHighlightCard({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    // Find a 45-min video in the data if available, or use a placeholder
    FreeVideoModel? masterclassVideo;
    for (var section in data.sections) {
      if (section.key == 'freeVideos') {
        final videos = section.data.cast<FreeVideoModel>();
        if (videos.isNotEmpty) {
          masterclassVideo = videos.firstWhere(
            (v) => v.durationSeconds >= 2700,
            orElse: () => videos.first,
          );
        }
        break;
      }
    }

    if (masterclassVideo == null) return const SizedBox();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ✨ PREMIUM LABEL
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: cs.secondary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: cs.secondary.withValues(alpha: 0.2)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.auto_awesome_rounded, color: cs.secondary, size: 16),
                const SizedBox(width: 8),
                Text(
                  "FEATURED MASTERCLASS",
                  style: TextStyle(
                    color: cs.secondary,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 1.5.h),

          FadeInUp(
            duration: const Duration(milliseconds: 800),
            child: InkWell(
              onTap: () {
                AppNavigator.push(
                  context,
                  FreeVideoDetailsScreen(video: masterclassVideo!),
                );
              },
              borderRadius: BorderRadius.circular(32),
              child: Container(
                height: 28.h,
                width: double.infinity,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [cs.primary, cs.primary.withValues(alpha: 0.8)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: cs.primary.withValues(alpha: 0.3),
                      blurRadius: 30,
                      offset: const Offset(0, 15),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // 🚢 BACKGROUND ILLUSTRATION (ON THE RIGHT)
                    Positioned(
                      right: -10.w,
                      top: -2.h,
                      bottom: -2.h,
                      child: Opacity(
                        opacity: 0.6,
                        child: Image.network(
                          'https://img.freepik.com/free-vector/global-logistics-network-background_23-2148161521.jpg',
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) => const SizedBox(),
                        ),
                      ),
                    ),

                    // 🌓 SUBTLE OVERLAY for Text Readability
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            cs.primary.withValues(alpha: 0.95),
                            cs.primary.withValues(alpha: 0.4),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),

                    // 💎 GLASS DURATION BADGE
                    Positioned(
                      top: 16,
                      left: 20,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          color: Colors.white.withValues(alpha: 0.1),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.timer_outlined,
                                color: Colors.white70,
                                size: 12,
                              ),
                              SizedBox(width: 6),
                              Text(
                                "45 MINS",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 10,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // ▶ PLAY BUTTON (Floating on the right side)
                    Positioned(
                      right: 15.w,
                      top: 0,
                      bottom: 0,
                      child: Center(
                        child: Container(
                          height: 64,
                          width: 64,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.3),
                              width: 1,
                            ),
                          ),
                          child: Center(
                            child: Container(
                              height: 48,
                              width: 48,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 10,
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.play_arrow_rounded,
                                color: cs.primary,
                                size: 36,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // ✍️ ENGAGING CAPTIONS (Aligned Left)
                    Positioned(
                      bottom: 0,
                      top: 0,
                      left: 20,
                      right: 40.w, // Leave room for play button/illustration
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Master\nExport-Import",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w900,
                              height: 1.1,
                              letterSpacing: -1,
                            ),
                          ),
                          SizedBox(height: 1.5.h),
                          Text(
                            "The Ultimate 2026\nBeginner-to-Pro\nRoadmap Training",
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.8),
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w600,
                              height: 1.3,
                            ),
                          ),
                          SizedBox(height: 0.8.h),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: cs.primary,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              "Watch Now",
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
