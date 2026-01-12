import 'package:flutter/material.dart';

class CourseOfTheDayCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String priceText;
  final String badgeText;
  final String imagePath;
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
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        height: 260, // 🎯 dashboard-friendly height
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26),
          gradient: const LinearGradient(
            colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: isDark
              ? Border.all(color: Colors.white.withOpacity(0.25), width: 1.1)
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.35),
              blurRadius: 24,
              offset: const Offset(0, 14),
            ),
            if (isDark)
              BoxShadow(color: Colors.white.withOpacity(0.12), blurRadius: 22),
          ],
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // 👧 GIRL IMAGE – LEFT, BLEEDING OUT
            Positioned(
              left: -10,
              bottom: -20,
              top: -20,
              child: Image.asset(imagePath, width: 170, fit: BoxFit.contain),
            ),

            // ✨ SOFT GLOW BEHIND IMAGE
            Positioned(
              left: 10,
              bottom: 30,
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Colors.white.withOpacity(0.18),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            // 📄 CONTENT – RIGHT SIDE
            Padding(
              padding: const EdgeInsets.fromLTRB(160, 22, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CurvedGradientText(text: 'COURSE'),
                  CurvedGradientText(text: 'OF THE DAY'),

                  const SizedBox(height: 14),

                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      height: 1.2,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.85),
                      height: 1.4,
                    ),
                  ),

                  const Spacer(),

                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          priceText,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          badgeText,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.8),
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
}

///
/// 🔥 CURVED PROMO TEXT (No package – stable)
///
class CurvedGradientText extends StatelessWidget {
  final String text;

  const CurvedGradientText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Transform(
      alignment: Alignment.centerLeft,
      transform: Matrix4.identity()
        ..rotateZ(-0.045)
        ..scale(1.05, 1.18),
      child: ShaderMask(
        shaderCallback: (bounds) {
          return const LinearGradient(
            colors: [Color(0xFF22F3A6), Color(0xFF00E676)],
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
