import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class PremiumCourseCard extends StatelessWidget {
  final String title;
  final String category;
  final String badgeText;
  final Color badgeColor;
  final String duration;
  final String rating;
  final String reviews;
  final String price;
  final List<Color> gradientColors;
  final CustomPainter painter;
  final Color enrollButtonColor;

  const PremiumCourseCard({
    super.key,
    required this.title,
    required this.category,
    required this.badgeText,
    required this.badgeColor,
    required this.duration,
    required this.rating,
    required this.reviews,
    required this.price,
    required this.gradientColors,
    required this.painter,
    required this.enrollButtonColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72.w, // Standard width for horizontal scroll
      margin: EdgeInsets.only(right: 4.w),
      decoration: BoxDecoration(
        color: const Color(0xFF030E30), // Deep Navy
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🖼️ THUMBNAIL AREA
          Stack(
            children: [
              Container(
                height: 18.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: gradientColors,
                  ),
                ),
                child: CustomPaint(painter: painter),
              ),
              // Overlays
              Positioned(
                top: 1.5.h,
                left: 3.w,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 2.5.w,
                    vertical: 0.6.h,
                  ),
                  decoration: BoxDecoration(
                    color: badgeColor,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: badgeColor.withValues(alpha: 0.4),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Text(
                    badgeText,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 1.5.h,
                right: 3.w,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 2.5.w,
                    vertical: 0.6.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        size: 10.sp,
                        color: Colors.white70,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        duration,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // 📝 BODY
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category.toUpperCase(),
                  style: TextStyle(
                    color: gradientColors.last.withValues(alpha: 0.8),
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w800,
                    height: 1.25,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 1.8.h),

                // META ROW (Rating & Price)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.star_rounded,
                          color: const Color(0xFFFFD000),
                          size: 14.sp,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          rating,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11.5.sp,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          " ($reviews)",
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "₹$price",
                      style: TextStyle(
                        color: const Color(0xFFFFD000),
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),

                // ENROLL BUTTON
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 1.4.h),
                  decoration: BoxDecoration(
                    color: enrollButtonColor,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: enrollButtonColor.withValues(alpha: 0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      "Enroll Now →",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
