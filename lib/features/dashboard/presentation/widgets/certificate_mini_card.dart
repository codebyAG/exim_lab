import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CertificateMiniCard extends StatelessWidget {
  final String title;
  final String level;
  final List<Color> gradientColors;
  final Widget icon;
  final Color levelColor;

  const CertificateMiniCard({
    super.key,
    required this.title,
    required this.level,
    required this.gradientColors,
    required this.icon,
    required this.levelColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.2.h),
      margin: EdgeInsets.only(right: 3.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 🏷️ Icon Area
          Container(
            padding: EdgeInsets.all(1.5.w),
            child: SizedBox(width: 5.w, height: 5.w, child: icon),
          ),
          SizedBox(width: 2.w),

          // 📝 Text Info
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 13.sp, // Substantially Increased
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                level,
                style: TextStyle(
                  color: levelColor,
                  fontSize: 11.sp, // Substantially Increased
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
