import 'dart:developer';

import 'package:exim_lab/features/courses/data/models/course_model.dart';

import 'package:exim_lab/core/navigation/app_navigator.dart';
import 'package:exim_lab/features/courses/presentation/screens/courses_details_screen.dart';
import 'package:exim_lab/features/courses/presentation/states/course_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:exim_lab/localization/app_localization.dart';

class CoursesListScreen extends StatefulWidget {
  const CoursesListScreen({super.key});

  @override
  State<CoursesListScreen> createState() => _CoursesListScreenState();
}

class _CoursesListScreenState extends State<CoursesListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    /// 🔹 API CALL
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CoursesState>().fetchCourses();
      context.read<CoursesState>().fetchMyCourses();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = context.watch<CoursesState>();
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,

      // 🔹 APP BAR
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        title: Text(
          t.translate('courses_title'),
          style: theme.textTheme.titleLarge,
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.search, color: theme.colorScheme.onSurface),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: theme.colorScheme.primary,
          unselectedLabelColor: theme.colorScheme.onSurface.withValues(
            alpha: 0.6,
          ),
          indicatorColor: theme.colorScheme.primary,
          tabs: [
            Tab(text: t.translate('tab_all')),
            Tab(text: t.translate('tab_my_courses')),
            Tab(text: t.translate('tab_popular')),
          ],
        ),
      ),

      // 🔹 BODY
      body: TabBarView(
        controller: _tabController,
        children: [
          _allCourses(context, state),
          _myCoursesList(context, state),
          _allCourses(context, state),
        ],
      ),
    );
  }

  // 🔹 ALL COURSES (API)
  Widget _allCourses(BuildContext context, CoursesState state) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.errorMessage != null) {
      return Center(child: Text(state.errorMessage!));
    }

    final t = AppLocalizations.of(context)!;
    if (state.courses.isEmpty) {
      return Center(child: Text(t.translate('no_courses_available')));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: state.courses.length,
      itemBuilder: (context, index) {
        final course = state.courses[index];
        return _CourseTile(
          title: course.title,
          subtitle: course.description,
          courseId: course.id,
        );
      },
    );
  }
}

// 🔹 COURSE TILE (API READY)
class _CourseTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String courseId;

  const _CourseTile({
    required this.title,
    required this.subtitle,
    required this.courseId,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: theme.brightness == Brightness.light
                ? Colors.black.withValues(alpha: 0.05)
                : Colors.black.withValues(alpha: 0.25),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          // THUMBNAIL
          Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              Icons.play_circle_fill,
              size: 36,
              color: theme.colorScheme.primary,
            ),
          ),

          const SizedBox(width: 14),

          // DETAILS
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.65),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          ElevatedButton(
            onPressed: () {
              log(courseId.toString());
              AppNavigator.push(
                context,
                CourseDetailsScreen(courseId: courseId),
              );
            },
            child: Text(AppLocalizations.of(context)!.translate('view_button')),
          ),
        ],
      ),
    );
  }
}

// 🔹 MY COURSES (API)
Widget _myCoursesList(BuildContext context, CoursesState state) {
  if (state.isMyCoursesLoading) {
    return const Center(child: CircularProgressIndicator());
  }

  if (state.myCourses.isEmpty) {
    final t = AppLocalizations.of(context)!;
    return Center(
      child: Text(
        t.translate('no_courses_enrolled'),
        textAlign: TextAlign.center,
      ),
    );
  }

  return GridView.builder(
    padding: const EdgeInsets.all(16),
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2, // ✅ 2 cards per row
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 0.78,
    ),
    itemCount: state.myCourses.length,
    itemBuilder: (context, index) {
      final course = state.myCourses[index];
      return _MyCourseCard(course: course, colorIndex: index);
    },
  );
}

class _MyCourseCard extends StatelessWidget {
  final CourseModel course;
  final int colorIndex;

  const _MyCourseCard({required this.course, required this.colorIndex});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    // 🎨 Adaptive background colors
    final List<Color> bgColors = [
      isDark ? cs.primaryContainer : const Color(0xFFFFE4EC),
      isDark ? cs.secondaryContainer : const Color(0xFFE6F0FF),
      isDark ? cs.tertiaryContainer : const Color(0xFFE6F7F2),
      isDark ? cs.surfaceContainerHighest : const Color(0xFFFFF3E0),
    ];

    final bgColor = bgColors[colorIndex % bgColors.length];
    final progress = (course.completionPercentage ?? 0) / 100.0;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TITLE
          Text(
            course.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: cs.onSurface,
            ),
          ),

          const SizedBox(height: 10),

          // COMPLETED TEXT
          Text(
            '${course.completionPercentage ?? 0}% ${AppLocalizations.of(context)!.translate('completed_percent')}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: cs.onSurface.withValues(alpha: 0.7),
            ),
          ),

          const SizedBox(height: 8),

          // PROGRESS
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: cs.onSurface.withValues(alpha: 0.15),
              color: cs.primary,
            ),
          ),

          const Spacer(),

          // ▶ RESUME BUTTON
          Align(
            alignment: Alignment.bottomRight,
            child: GestureDetector(
              onTap: () {
                AppNavigator.push(
                  context,
                  CourseDetailsScreen(courseId: course.id),
                );
              },
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: cs.primary,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.play_arrow, color: cs.onPrimary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
