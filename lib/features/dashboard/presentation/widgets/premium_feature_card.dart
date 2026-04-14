import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class PremiumFeatureCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final String buttonLabel;
  final Color themeColor;
  final VoidCallback onTap;

  const PremiumFeatureCard({
    super.key,
    required this.title,
    required this.icon,
    required this.buttonLabel,
    required this.themeColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 15.h,
      height: 15.h, // Adjusted height for better spacing
      margin: EdgeInsets.only(right: 4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // 🌊 BOTTOM ACCENT WAVE
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: 10.h,
              child: CustomPaint(painter: _CardWavePainter(color: themeColor)),
            ),

            // 📦 DYNAMIC CONTENT COLUMN (Prevents overlap)
            Padding(
              padding: EdgeInsets.fromLTRB(3.w, 1.5.h, 3.w, 1.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // 📝 TITLE
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xFF001A3D),
                      fontWeight: FontWeight.w500,
                      fontSize: 15.sp, // Slightly balanced
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  // 🎨 ICON AREA
                  Expanded(
                    child: Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 15.sp,
                            height: 15.sp,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: themeColor.withValues(alpha: 0.15),
                                  blurRadius: 15,
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            icon,
                            size: 28.sp,
                            color: themeColor.withValues(alpha: 0.9),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // 🔘 ACTION PILL
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: onTap,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 4.w,
                          vertical: 0.7.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: Text(
                                buttonLabel,
                                style: TextStyle(
                                  color: themeColor,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 12.sp,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (buttonLabel.contains(">")) ...[
                              SizedBox(width: 1.w),
                              Icon(
                                Icons.chevron_right_rounded,
                                size: 14,
                                color: themeColor,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CardWavePainter extends CustomPainter {
  final Color color;
  _CardWavePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.4)
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height * 0.4);
    path.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.1,
      size.width * 0.5,
      size.height * 0.5,
    );
    path.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.9,
      size.width,
      size.height * 0.4,
    );
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
