import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class DashboardJourneyBar extends StatelessWidget {
  final int completedCourses;
  final int totalCourses;
  final int streakDays;

  const DashboardJourneyBar({
    super.key,
    this.completedCourses = 0,
    this.totalCourses = 10,
    this.streakDays = 0,
  });

  @override
  Widget build(BuildContext context) {
    final progress = totalCourses > 0 ? (completedCourses / totalCourses) : 0.0;
    final percentage = (progress * 100).toInt();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.2.h),
        decoration: BoxDecoration(
          color: const Color(0xFF030E30), // Matching Deep Navy
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: const Color(0xFF1E5FFF).withValues(alpha: 0.25),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF000000).withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 📝 HEADER: TITLE + PERCENTAGE
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    const Text(
                      '📘',
                      style: TextStyle(fontSize: 18),
                    ), // Using emoji for simplicity as per screenshot vibe
                    SizedBox(width: 3.w),
                    Text(
                      'Your Progress',
                      style: TextStyle(
                        fontSize: 15.sp, // Reduced to prevent overflow
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        fontFamily: 'Plus Jakarta Sans',
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
                // 🏆 PERCENTAGE WITH GLOW
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // Glow background
                    Text(
                      '$percentage%',
                      style: TextStyle(
                        fontSize: 22.sp, // Stabilized
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFFFFD000).withValues(alpha: 0.3),
                        fontFamily: 'jakarta',
                      ),
                    ),
                    Text(
                      '$percentage%',
                      style: TextStyle(
                        fontSize: 22.sp, // Stabilized
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFFFFD000), // Premium Gold
                        fontFamily: 'jakarta',
                        shadows: [
                          Shadow(
                            color: const Color(
                              0xFFFFD000,
                            ).withValues(alpha: 0.5),
                            blurRadius: 15,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: 1.8.h),

            // 🌊 PREMIUM PROGRESS BAR
            Stack(
              children: [
                // Track
                Container(
                  height: 12,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                // Active Bar with Gradient
                FractionallySizedBox(
                  widthFactor: progress.clamp(0.02, 1.0),
                  child: Container(
                    height: 12,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF0F47D1), Color(0xFF1E5FFF)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF1E5FFF).withValues(alpha: 0.4),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 1.2.h),

            // 📍 SUBTITLE
            Text(
              'Import Fundamentals · $completedCourses of $totalCourses lessons complete',
              style: TextStyle(
                fontSize: 11.sp, // Stabilized
                color: Colors.white.withValues(alpha: 0.45),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
