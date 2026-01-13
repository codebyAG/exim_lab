import 'package:exim_lab/core/constants/appcardshadow.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ContinueCard extends StatelessWidget {
  const ContinueCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.5.h),
      child: Container(
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
                image: const DecorationImage(
                  image: AssetImage('assets/course1.png'),
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
                    'Export Basics – Lesson 3',
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
                      value: 0.65,
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
    );
  }
}
