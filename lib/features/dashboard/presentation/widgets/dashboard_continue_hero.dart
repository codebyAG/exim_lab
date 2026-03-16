import 'package:cached_network_image/cached_network_image.dart';
import 'package:exim_lab/features/courses/data/models/course_model.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class DashboardContinueHero extends StatelessWidget {
  final CourseModel course;
  final bool isLocked;
  final VoidCallback onTap;
  final VoidCallback? onDownloadPdf;

  const DashboardContinueHero({
    super.key,
    required this.course,
    required this.onTap,
    this.isLocked = false,
    this.onDownloadPdf,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final progress = 0.45; // Placeholder until API provides progress

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: cs.outlineVariant.withValues(alpha: 0.5),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.07),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Lock overlay if needed
              if (isLocked)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.lock_rounded,
                        color: Colors.white,
                        size: 36,
                      ),
                    ),
                  ),
                ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ── Left: Text content ──────────────────────────────
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(18, 18, 12, 18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Continue Learning',
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: cs.primary,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            course.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w800,
                              color: cs.onSurface,
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 12),
                          // Progress Bar
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Progress: ${(progress * 100).toInt()}%',
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  color: cs.onSurfaceVariant,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 6),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: LinearProgressIndicator(
                                  value: progress,
                                  minHeight: 6,
                                  backgroundColor: cs.primary.withValues(
                                    alpha: 0.15,
                                  ),
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    cs.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          // CTA Button
                          SizedBox(
                            child: ElevatedButton.icon(
                              onPressed: onTap,
                              icon: isLocked
                                  ? const Icon(Icons.lock_rounded, size: 14)
                                  : const Icon(
                                      Icons.play_arrow_rounded,
                                      size: 14,
                                    ),
                              label: Text(
                                isLocked ? 'Unlock' : 'Continue →',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: cs.primary,
                                foregroundColor: cs.onPrimary,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 9,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // ── Right: Thumbnail ───────────────────────────────
                  ClipRRect(
                    borderRadius: const BorderRadius.horizontal(
                      right: Radius.circular(20),
                    ),
                    child: SizedBox(
                      width: 35.w,
                      child: course.imageUrl != null &&
                              course.imageUrl!.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: course.imageUrl!,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                color: cs.primary.withValues(alpha: 0.1),
                              ),
                              errorWidget: (context, url, error) => Container(
                                color: cs.primary.withValues(alpha: 0.1),
                                child: Icon(
                                  Icons.import_export_rounded,
                                  size: 36,
                                  color: cs.primary.withValues(alpha: 0.5),
                                ),
                              ),
                            )
                          : Container(
                              color: cs.primary.withValues(alpha: 0.1),
                              child: Icon(
                                Icons.import_export_rounded,
                                size: 36,
                                color: cs.primary.withValues(alpha: 0.5),
                              ),
                            ),
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
