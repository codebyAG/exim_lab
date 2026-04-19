import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class PopularCourseCard extends StatelessWidget {
  final String rank;
  final String title;
  final String category;
  final String meta;
  final String price;
  final CustomPainter iconPainter;
  final Color categoryColor;
  final List<Color> iconBgColors;

  final VoidCallback? onTap;

  const PopularCourseCard({
    super.key,
    required this.rank,
    required this.title,
    required this.category,
    required this.meta,
    required this.price,
    required this.iconPainter,
    required this.categoryColor,
    required this.iconBgColors,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        margin: EdgeInsets.only(bottom: 1.5.h),
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: const Color(
            0xFF0A2066,
          ).withValues(alpha: 0.3), // Translucent Navy
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: const Color(0xFF1E5FFF).withValues(alpha: 0.15),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            // 🔢 RANK NUMBER
            SizedBox(
              width: 12.w,
              child: Text(
                rank,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.15),
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'Plus Jakarta Sans',
                ),
              ),
            ),

            // 🖼️ MINI ICON THUMBNAIL
            Container(
              width: 15.w,
              height: 15.w,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: iconBgColors,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: CustomPaint(painter: iconPainter),
            ),
            SizedBox(width: 4.w),

            // 📝 INFO
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category.toUpperCase(),
                    style: TextStyle(
                      color: categoryColor,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(height: 0.4.h),
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'Plus Jakarta Sans',
                      height: 1.2,
                    ),
                  ),
                  SizedBox(height: 0.6.h),
                  Text(
                    meta,
                    style: TextStyle(
                      color: Colors.white60,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            // 💰 PRICE
            Padding(
              padding: EdgeInsets.only(left: 2.w),
              child: Text(
                "₹$price",
                style: TextStyle(
                  color: const Color(0xFFFFD000),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
