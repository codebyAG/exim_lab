import 'package:exim_lab/core/navigation/app_navigator.dart';
import 'package:exim_lab/features/courses/presentation/screens/lesson_screen.dart';
import 'package:exim_lab/features/courses/presentation/states/course_details_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:exim_lab/localization/app_localization.dart';

class CourseDetailsScreen extends StatefulWidget {
  final String courseId;

  const CourseDetailsScreen({super.key, required this.courseId});

  @override
  State<CourseDetailsScreen> createState() => _CourseDetailsScreenState();
}

class _CourseDetailsScreenState extends State<CourseDetailsScreen> {
  @override
  void initState() {
    super.initState();

    /// ✅ Correct way to call provider API from initState
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CourseDetailsState>().fetchCourseDetails(widget.courseId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final state = context.watch<CourseDetailsState>();
    final t = AppLocalizations.of(context);

    // ================= LOADING =================
    if (state.isLoading) {
      return Scaffold(
        backgroundColor: cs.surface,
        appBar: AppBar(backgroundColor: cs.surface, elevation: 0),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    // ================= ERROR =================
    if (state.errorMessage != null) {
      return Scaffold(
        backgroundColor: cs.surface,
        body: Center(child: Text(state.errorMessage!)),
      );
    }

    // ================= SAFE NULL CHECK =================
    final course = state.course;
    if (course == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // ================= UI =================
    return Scaffold(
      backgroundColor: cs.surface,

      appBar: AppBar(
        backgroundColor: cs.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: cs.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(course.title, style: theme.textTheme.titleLarge),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ================= HERO CARD =================
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: cs.surface,
                borderRadius: BorderRadius.circular(24), // Increased radius
                boxShadow: [
                  BoxShadow(
                    color: theme.brightness == Brightness.light
                        ? Colors.black.withValues(alpha: 0.08)
                        : Colors.black.withValues(alpha: 0.3),
                    blurRadius: 24, // Increased blur
                    offset: const Offset(0, 12),
                  ),
                ],
                border: Border.all(
                  color: cs.outlineVariant.withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 200, // Slightly taller
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: cs.surfaceContainerHighest,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child:
                        course.imageUrl != null && course.imageUrl!.isNotEmpty
                        ? Image.network(
                            course.imageUrl!,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                'assets/course1.png',
                                fit: BoxFit.cover,
                              );
                            },
                          )
                        : Image.asset('assets/course1.png', fit: BoxFit.cover),
                  ),

                  const SizedBox(height: 20),

                  Text(
                    course.title,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800, // Extra Bold
                      color: cs.onSurface,
                      height: 1.2,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    course.description,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: cs.onSurface.withValues(alpha: 0.7),
                      height: 1.5,
                      fontSize: 15,
                    ),
                  ),

                  const SizedBox(height: 16),

                  Row(
                    children: [
                      _StatChip(
                        icon: Icons.menu_book_rounded,
                        text:
                            '${course.lessons.length} ${t.translate('lessons_count')}',
                      ),
                      const SizedBox(width: 10),
                      _StatChip(
                        icon: Icons.currency_rupee_rounded,
                        text: course.basePrice == 0
                            ? t.translate('free_cost')
                            : '₹${course.basePrice}',
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // ================= CTA =================
            // ================= CTA =================
            Container(
              width: double.infinity,
              height: 58,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: cs.primary.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () {
                  AppNavigator.push(
                    context,
                    LessonsScreen(
                      lessons: course.lessons,
                      courseTitle: course.title,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: cs.primary,
                  foregroundColor: cs.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 0, // Using Container shadow instead
                ),
                child: const Text(
                  'Start Learning',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ================= STAT CHIP =================
class _StatChip extends StatelessWidget {
  final IconData icon;
  final String text;

  const _StatChip({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.onSurface.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 14,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
          ),
          const SizedBox(width: 4),
          Text(text, style: theme.textTheme.bodySmall),
        ],
      ),
    );
  }
}
