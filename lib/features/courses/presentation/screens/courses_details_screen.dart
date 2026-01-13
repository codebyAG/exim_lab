import 'package:exim_lab/core/navigation/app_navigator.dart';
import 'package:exim_lab/features/courses/presentation/screens/lesson_screen.dart';
import 'package:exim_lab/features/courses/presentation/states/course_details_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: theme.brightness == Brightness.light
                        ? Colors.black.withOpacity(0.05)
                        : Colors.black.withOpacity(0.25),
                    blurRadius: 12,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 180,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: cs.surfaceContainerHighest,
                    ),
                    clipBehavior: Clip.antiAlias,
                    child:
                        course.imageUrl != null && course.imageUrl!.isNotEmpty
                        ? Image.network(
                            course.imageUrl!,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) {
                              return Image.asset(
                                'assets/course1.png', // 🔁 fallback asset
                                fit: BoxFit.cover,
                              );
                            },
                          )
                        : Image.asset(
                            'assets/course1.png', // 🔁 fallback asset
                            fit: BoxFit.cover,
                          ),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    course.title,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    course.description,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: cs.onSurface.withOpacity(0.65),
                      height: 1.4,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      _StatChip(
                        icon: Icons.menu_book,
                        text: '${course.lessons.length} lessons',
                      ),
                      const SizedBox(width: 8),
                      _StatChip(
                        icon: Icons.currency_rupee,
                        text: course.basePrice == 0
                            ? 'Free'
                            : '₹${course.basePrice}',
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // ================= CTA =================
            SizedBox(
              width: double.infinity,
              height: 56,
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
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Start Learning',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(BuildContext context, String text) {
    final theme = Theme.of(context);
    return Text(
      text,
      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
    );
  }
}

// ================= STAT CHIP =================
class _StatChip extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool isAccent;

  const _StatChip({
    required this.icon,
    required this.text,
    this.isAccent = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.onSurface.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 14,
            color: isAccent
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurface.withOpacity(0.7),
          ),
          const SizedBox(width: 4),
          Text(text, style: theme.textTheme.bodySmall),
        ],
      ),
    );
  }
}
