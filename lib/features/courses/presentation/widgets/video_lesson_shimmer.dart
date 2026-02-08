import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class VideoLessonShimmer extends StatelessWidget {
  const VideoLessonShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final baseColor = isDark ? Colors.grey[900]! : Colors.grey[300]!;
    final highlightColor = isDark ? Colors.grey[800]! : Colors.grey[100]!;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        leading: Icon(Icons.arrow_back, color: theme.colorScheme.onSurface),
      ),
      body: Shimmer.fromColors(
        baseColor: baseColor,
        highlightColor: highlightColor,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Video Player Placeholder
              Container(
                height: 220,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              const SizedBox(height: 20),

              // "About Lesson" Title
              Container(height: 18, width: 120, color: Colors.white),
              const SizedBox(height: 8),
              // Description Lines
              Container(
                height: 14,
                width: double.infinity,
                color: Colors.white,
              ),
              const SizedBox(height: 6),
              Container(
                height: 14,
                width: double.infinity,
                color: Colors.white,
              ),
              const SizedBox(height: 6),
              Container(height: 14, width: 200, color: Colors.white),

              const SizedBox(height: 24),

              // "What you will learn" Title
              Container(height: 18, width: 150, color: Colors.white),
              const SizedBox(height: 12),

              // Bullet Points
              _buildBulletPlaceholder(),
              _buildBulletPlaceholder(),
              _buildBulletPlaceholder(),

              const SizedBox(height: 28),

              // Q&A Input Placeholder
              Container(height: 18, width: 100, color: Colors.white),
              const SizedBox(height: 10),
              Container(
                height: 80,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBulletPlaceholder() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            height: 18,
            width: 18,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Container(height: 14, width: 200, color: Colors.white),
        ],
      ),
    );
  }
}
