import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:sizer/sizer.dart';

class CourseCard extends StatelessWidget {
  final String title;
  final String rating;
  final String learners;
  final String image;
  final VoidCallback? onTap;

  final bool isLocked;

  const CourseCard({
    super.key,
    required this.title,
    required this.rating,
    required this.learners,
    required this.image,
    this.onTap,
    this.isLocked = false,
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
          width: 58.w,
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: cs.shadow.withValues(alpha: 0.1),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: cs.primary.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(
              color: cs.outlineVariant.withValues(alpha: 0.12),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // IMAGE with rating chip overlay
              Stack(
                children: [
                  Container(
                    height: 13.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: cs.surfaceContainerHighest,
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: image.startsWith('http')
                        ? CachedNetworkImage(
                            imageUrl: image,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    cs.primary.withValues(alpha: 0.1),
                                    cs.secondary.withValues(alpha: 0.1),
                                  ],
                                ),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.play_circle_outline_rounded,
                                  size: 32,
                                  color: cs.primary.withValues(alpha: 0.4),
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    cs.primary.withValues(alpha: 0.15),
                                    cs.secondary.withValues(alpha: 0.15),
                                  ],
                                ),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.play_circle_outline_rounded,
                                  size: 32,
                                  color: cs.primary.withValues(alpha: 0.5),
                                ),
                              ),
                            ),
                          )
                        : Image.asset(image, fit: BoxFit.cover),
                  ),
                  // Rating chip
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: isLocked
                            ? Colors.red.withValues(alpha: 0.8)
                            : Colors.black.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isLocked ? Icons.lock_rounded : Icons.star_rounded,
                            size: 14,
                            color: isLocked ? Colors.white : Colors.amber,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            isLocked ? "LOCK" : rating,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 1.h),

              // TITLE
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: cs.onSurface,
                ),
              ),

              SizedBox(height: 0.5.h),

              // META
              Row(
                children: [
                  Icon(
                    Icons.people_outline_rounded,
                    size: 14,
                    color: cs.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    learners,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontSize: 12.sp,
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
