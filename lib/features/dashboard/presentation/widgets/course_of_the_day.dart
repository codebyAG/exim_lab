import 'package:flutter/material.dart';

class CourseOfTheDayCard extends StatelessWidget {
  final String title;        // e.g. "Import Export Basics"
  final String subtitle;     // e.g. "Start your trade journey"
  final String priceText;    // e.g. "₹999"
  final String badgeText;    // e.g. "Course of the Day"
  final String imagePath;    // e.g. assets/course_banner.png
  final VoidCallback onTap;

  const CourseOfTheDayCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.priceText,
    required this.badgeText,
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        height: 220,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: const LinearGradient(
            colors: [
              Color(0xFF0F2027),
              Color(0xFF203A43),
              Color(0xFF2C5364),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: isDark
              ? Border.all(
                  color: Colors.white.withOpacity(0.35),
                  width: 1.2,
                )
              : null,
          boxShadow: [
            if (isDark)
              BoxShadow(
                color: Colors.white.withOpacity(0.18),
                blurRadius: 24,
              ),
            BoxShadow(
              color: Colors.black.withOpacity(0.35),
              blurRadius: 22,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Stack(
          children: [
            // 🔹 BACKGROUND IMAGE
            Positioned(
              right: -20,
              bottom: -10,
              child: Opacity(
                opacity: 0.9,
                child: Image.asset(
                  imagePath,
                  height: 150,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            // 🔹 CONTENT
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🔥 CURVED PROMO TEXT
                  const SizedBox(height: 6),
                  CurvedGradientText(text: 'COURSE'),
                  CurvedGradientText(text: 'OF THE DAY'),

                  const Spacer(),

                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.85),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(
                          priceText,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        badgeText,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.8),
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
}

//
// 🔥 FAKE CURVED TEXT (STABLE – NO PACKAGE)
//
class CurvedGradientText extends StatelessWidget {
  final String text;

  const CurvedGradientText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Transform(
      alignment: Alignment.centerLeft,
      transform: Matrix4.identity()
        ..rotateZ(-0.04)
        ..scale(1.0, 1.15),
      child: ShaderMask(
        shaderCallback: (bounds) {
          return const LinearGradient(
            colors: [
              Color(0xFF22F3A6),
              Color(0xFF00E676),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(bounds);
        },
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.6,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
