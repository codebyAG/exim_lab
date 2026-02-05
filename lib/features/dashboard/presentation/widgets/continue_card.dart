import 'package:exim_lab/core/constants/appcardshadow.dart';
import 'package:exim_lab/features/courses/data/models/course_model.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ContinueCard extends StatelessWidget {
  final CourseModel course;
  final VoidCallback? onTap;

  const ContinueCard({super.key, required this.course, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final progress = (course.completionPercentage ?? 0) / 100.0;

    return Padding(
      padding: EdgeInsets.only(right: 3.w, bottom: 1.5.h),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 80.w, // Fixed width for horizontal scrolling
          padding: EdgeInsets.all(2.h),
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(18),
            boxShadow: appCardShadow(context),
          ),
          child: Row(
            children: [
              // 🔹 COURSE IMAGE
              Container(
                height: 7.h,
                width: 7.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
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

              // 🔹 TEXT + PROGRESS
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: cs.onSurface,
                      ),
                    ),

                    SizedBox(height: 0.8.h),

                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 0.8.h,
                        backgroundColor: cs.surfaceContainerHighest,
                        color: cs.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
