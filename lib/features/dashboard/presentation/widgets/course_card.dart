import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CourseCard extends StatelessWidget {
  final String title;
  final String rating;
  final String learners;
  final String image;
  final VoidCallback? onTap;

  const CourseCard({
    super.key,
    required this.title,
    required this.rating,
    required this.learners,
    required this.image,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.only(bottom: 1.5.h),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 58.w, // 🔹 responsive width
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: cs.shadow.withValues(alpha: 0.12),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
            border: Border.all(
              color: cs.outlineVariant.withValues(alpha: 0.15),
              width: 1.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 IMAGE
              Container(
                height:
                    13.h, // 🔹 fixed responsive height (no Expanded overflow)
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: image.startsWith('http')
                        ? NetworkImage(image)
                        : AssetImage(image) as ImageProvider,
                    fit: BoxFit.cover,
                    onError: (context, error) {
                      // Fallback if network fails, or could be handled by image provider error builder context not available here easily for DecorationImage
                    },
                  ),
                ),
              ),

              SizedBox(height: 1.h),

              // 🔹 TITLE
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: cs.onSurface,
                ),
              ),

              SizedBox(height: 0.8.h),

              // 🔹 META
              Text(
                '$rating • $learners',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontSize: 14.sp,
                  color: cs.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
