import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:exim_lab/features/dashboard/presentation/painters/dashboard_icons_painter.dart';
import 'package:exim_lab/core/functions/whatsapp_utils.dart';

class MasterclassCard extends StatelessWidget {
  const MasterclassCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.5.h),
      child: Container(
        height: 38.h,
        decoration: BoxDecoration(
          color: const Color(0xFF030E30), // Deep Navy
          borderRadius: BorderRadius.circular(32),
          border: Border.all(
            color: const Color(
              0xFF1E5FFF,
            ).withValues(alpha: 0.5), // Glowing blue border
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF1E5FFF).withValues(alpha: 0.15),
              blurRadius: 30,
              spreadRadius: 2,
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 40,
              offset: const Offset(0, 20),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // 🟥 RIGHT RED STRIPE (Matches Screenshot)
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              child: Container(width: 6, color: const Color(0xFFC8151B)),
            ),

            // 🚢 SHIP WATERMARK (Bottom Right)
            Positioned(
              bottom: -1.h,
              right: -2.w,
              child: Opacity(
                opacity: 0.06,
                child: SizedBox(
                  width: 55.w,
                  height: 25.h,
                  child: CustomPaint(
                    painter: MasterclassShipWatermarkPainter(),
                  ),
                ),
              ),
            ),

            // ✈️ PLANE WATERMARK (Top Right)
            Positioned(
              top: 5.h,
              right: 12.w,
              child: Opacity(
                opacity: 0.12,
                child: SizedBox(
                  width: 25.w,
                  height: 10.h,
                  child: CustomPaint(
                    painter: MasterclassPlaneWatermarkPainter(),
                  ),
                ),
              ),
            ),

            // 📝 CONTENT
            Padding(
              padding: EdgeInsets.all(6.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🏷️ TAGS ROW
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildMainTag("★ FEATURED MASTERCLASS"),
                        SizedBox(width: 2.w),
                        _buildSubTag("🛡️ Export Beginner"),
                        SizedBox(width: 2.w),
                        _buildSubTag("🏆 Advanced"),
                      ],
                    ),
                  ),
                  SizedBox(height: 3.h),

                  // 🏠 TITLE
                  Text(
                    "Master Import–\nExport Business",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w900,
                      height: 1.1,
                      letterSpacing: -1,
                    ),
                  ),
                  SizedBox(height: 1.5.h),

                  // 📍 SUBTITLE
                  Text(
                    "Become a Global Trade Expert ✈️🚢",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),

                  // 🔘 ACTIONS
                  Row(
                    children: [
                      // ENROLL BUTTON
                      Expanded(
                        flex: 3,
                        child: InkWell(
                          onTap: () => WhatsAppUtils.launch(
                            message:
                                "Hi, I want to enroll in the Master Import-Export Business class.",
                          ),
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 2.h),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFC8151B), Color(0xFFFF2D35)],
                              ),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xFFC8151B,
                                  ).withValues(alpha: 0.6),
                                  blurRadius: 20,
                                  spreadRadius: 2,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                "Enroll Now 🚀",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 3.w),
                      // TIME CAPSULE
                      Expanded(
                        flex: 2,
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 2.h),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.15),
                              width: 1,
                            ),
                          ),
                          child: Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.calendar_today_rounded,
                                  size: 13.sp,
                                  color: Colors.white70,
                                ),
                                SizedBox(width: 2.w),
                                Text(
                                  "April · 7 PM",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11.5.sp,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainTag(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.8.h),
      decoration: BoxDecoration(
        color: const Color(0xFFC8151B),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFC8151B).withValues(alpha: 0.3),
            blurRadius: 10,
          ),
        ],
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 11.sp,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildSubTag(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.5.w, vertical: 0.8.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.85),
          fontSize: 10.5.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
