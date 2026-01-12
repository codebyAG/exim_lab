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
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        height: 500, // 🔥 TALL POSTER STYLE
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26),
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
                blurRadius: 26,
              ),
            BoxShadow(
              color: Colors.black.withOpacity(0.35),
              blurRadius: 26,
              offset: const Offset(0, 14),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(26),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔥 TOP CONTENT AREA (TEXT ONLY)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 22, 20, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CurvedGradientText(text: 'COURSE'),
                    CurvedGradientText(text: 'OF THE DAY'),

                    const SizedBox(height: 24),

                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white.withOpacity(0.85),
                        height: 1.35,
                      ),
                    ),

                    const SizedBox(height: 14),

                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
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
                        const SizedBox(width: 12),
                        Text(
                          badgeText,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // 🖼 IMAGE AREA (SEPARATE – NO OVERLAP)
              Container(
                height: 150,
                alignment: Alignment.center,
                child: Image.asset(
                  imagePath,
                  height: 140,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//
// 🔥 CURVED PROMO TEXT
//
class CurvedGradientText extends StatelessWidget {
  final String text;

  const CurvedGradientText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Transform(
      alignment: Alignment.centerLeft,
      transform: Matrix4.identity()
        ..rotateZ(-0.045)
        ..scale(1.05, 1.2),
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
            fontSize: 26,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.8,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
