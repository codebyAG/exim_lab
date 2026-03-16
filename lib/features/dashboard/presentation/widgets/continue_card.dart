import 'package:exim_lab/core/constants/appcardshadow.dart';
import 'package:exim_lab/features/courses/data/models/course_model.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ContinueCard extends StatelessWidget {
  final CourseModel course;
  final VoidCallback? onTap;

  final bool isLocked;

  const ContinueCard({
    super.key,
    required this.course,
    this.onTap,
    this.isLocked = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final progress = (course.completionPercentage ?? 0) / 100.0;
    final progressPercent = (course.completionPercentage ?? 0).toInt();

    return Padding(
      padding: EdgeInsets.only(right: 3.w, bottom: 1.5.h),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 80.w,
          padding: EdgeInsets.all(2.h),
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(20),
            boxShadow: appCardShadow(context),
            border: Border.all(
              color: cs.outlineVariant.withValues(alpha: 0.1),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              // COURSE IMAGE
              Container(
                height: 7.h,
                width: 7.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      cs.primary.withValues(alpha: 0.1),
                      cs.secondary.withValues(alpha: 0.1),
                    ],
                  ),
                  image: DecorationImage(
                    image:
                        (course.imageUrl != null &&
                            course.imageUrl!.startsWith('http'))
                        ? NetworkImage(course.imageUrl!)
                        : const AssetImage('assets/course1.png')
                              as ImageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              SizedBox(width: 3.w),

              // TEXT + PROGRESS
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: cs.onSurface,
                      ),
                    ),

                    SizedBox(height: 0.8.h),

                    // Progress bar with percentage
                    Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: LinearProgressIndicator(
                              value: progress,
                              minHeight: 0.8.h,
                              backgroundColor: cs.surfaceContainerHighest,
                              color: cs.primary,
                            ),
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          '$progressPercent%',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: cs.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(width: 2.w),

              // Continue pill
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isLocked ? cs.error : cs.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  isLocked ? Icons.lock_rounded : Icons.play_arrow_rounded,
                  size: 18,
                  color: isLocked ? Colors.white : cs.onPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
