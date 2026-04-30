import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:exim_lab/core/functions/whatsapp_utils.dart';

import 'package:provider/provider.dart';
import 'package:exim_lab/core/providers/config_provider.dart';

class AchieveLiveCard extends StatelessWidget {
  const AchieveLiveCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ConfigProvider>(
      builder: (context, configProvider, _) {
        final config = configProvider.effectiveLiveEvent;
        final webinar = config.webinar;

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.5.h),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF030E30), // Deep Navy
              borderRadius: BorderRadius.circular(32),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.1),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 25,
                  offset: const Offset(0, 15),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 👈 LEFT SECTION: ACHIEVE
                  Expanded(
                    flex: 14,
                    child: Padding(
                      padding: EdgeInsets.all(5.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              style: TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                              children: [
                                const TextSpan(text: "What You'll "),
                                TextSpan(
                                  text: "Achieve",
                                  style: TextStyle(
                                    color: const Color(0xFFFFD000),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 2.5.h),
                          ...config.achievements.map(
                            (item) => _buildAchieveItem(item),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // ｜ VERTICAL DIVIDER
                  Container(
                    width: 1,
                    color: Colors.white.withValues(alpha: 0.1),
                  ),

                  // 👉 RIGHT SECTION: LIVE WEBINAR
                  Expanded(
                    flex: 9,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 5.w,
                        vertical: 4.w,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // LIVE TAG
                          Row(
                            children: [
                              if (webinar.isLive) _buildLiveDot(),
                              SizedBox(width: 2.w),
                              RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white70,
                                    letterSpacing: 0.5,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: webinar.isLive
                                          ? "LIVE "
                                          : "Upcoming ",
                                    ),
                                    TextSpan(
                                      text: webinar.isLive ? "NOW" : "LIVE",
                                      style: TextStyle(
                                        color: const Color(0xFFFF4444),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 1.h),
                          if (webinar.title != null)
                            Text(
                              webinar.title!,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.6),
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w700,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          SizedBox(height: 1.5.h),

                          // DATE
                          Text(
                            webinar.day,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24.sp,
                              fontWeight: FontWeight.w900,
                              height: 1,
                            ),
                          ),
                          Text(
                            webinar.month,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w800,
                              height: 1,
                            ),
                          ),
                          SizedBox(height: 1.5.h),

                          // TIME
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_month_rounded,
                                color: Colors.white54,
                                size: 14.sp,
                              ),
                              SizedBox(width: 2.w),
                              Text(
                                webinar.time,
                                style: TextStyle(
                                  color: const Color(0xFFFFD000),
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),

                          // 🔘 REGISTER / JOIN BUTTON
                          InkWell(
                            onTap: () {
                              if (webinar.isLive &&
                                  webinar.meetingUrl != null) {
                                // Launch Meeting URL via WhatsApp message for now
                                WhatsAppUtils.launch(
                                  message:
                                      "Hi, I want to join the LIVE session: ${webinar.meetingUrl}",
                                );
                              } else {
                                WhatsAppUtils.launch(
                                  message: webinar.whatsappMessage,
                                );
                              }
                            },
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(vertical: 1.4.h),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: webinar.isLive
                                      ? [
                                          const Color(0xFFFF4444),
                                          const Color(0xFFC8151B),
                                        ]
                                      : [
                                          const Color(0xFF0F47D1),
                                          const Color(0xFF1E5FFF),
                                        ],
                                ),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        (webinar.isLive
                                                ? const Color(0xFFFF4444)
                                                : const Color(0xFF1E5FFF))
                                            .withValues(alpha: 0.4),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  webinar.isLive
                                      ? "Join Now →"
                                      : "Register Now →",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAchieveItem(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.6.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: const Color(0xFF1E5FFF),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(Icons.check_rounded, color: Colors.white, size: 12.sp),
          ),
          SizedBox(width: 3.5.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.9),
                fontSize: 12.5.sp,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLiveDot() {
    return Container(
      width: 10,
      height: 10,
      decoration: const BoxDecoration(
        color: Color(0xFFFF4444),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: Color(0xFFFF4444), blurRadius: 8, spreadRadius: 2),
        ],
      ),
    );
  }
}
