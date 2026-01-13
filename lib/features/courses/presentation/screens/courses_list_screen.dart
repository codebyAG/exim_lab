import 'dart:developer';

import 'package:exim_lab/core/navigation/app_navigator.dart';
import 'package:exim_lab/features/courses/presentation/screens/courses_details_screen.dart';
import 'package:exim_lab/features/courses/presentation/states/course_details_state.dart';
import 'package:exim_lab/features/courses/presentation/states/course_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = context.watch<CoursesState>();

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,

      // 🔹 APP BAR
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        title: Text('Courses', style: theme.textTheme.titleLarge),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.search, color: theme.colorScheme.onSurface),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: theme.colorScheme.primary,
          unselectedLabelColor: theme.colorScheme.onSurface.withOpacity(0.6),
          indicatorColor: theme.colorScheme.primary,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'My Courses'),
            Tab(text: 'Popular'),
          ],
        ),
      ),

      // 🔹 BODY
      body: TabBarView(
        controller: _tabController,
        children: [
          _allCourses(context, state),
          _myCoursesMockList(context),
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

    if (state.courses.isEmpty) {
      return const Center(child: Text('No courses available'));
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
                ? Colors.black.withOpacity(0.05)
                : Colors.black.withOpacity(0.25),
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
              color: theme.colorScheme.primary.withOpacity(0.15),
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
                    color: theme.colorScheme.onSurface.withOpacity(0.65),
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
            child: const Text('View'),
          ),
        ],
      ),
    );
  }
}

// ================= MOCK: MY COURSES =================

class _MyCourse {
  final String title;
  final int completedLessons;
  final int totalLessons;

  const _MyCourse({
    required this.title,
    required this.completedLessons,
    required this.totalLessons,
  });

  double get progress => completedLessons / totalLessons;
}

const List<_MyCourse> _mockMyCourses = [
  _MyCourse(
    title: 'Advanced Export Strategy',
    completedLessons: 3,
    totalLessons: 10,
  ),
  _MyCourse(
    title: 'Import Documentation Mastery',
    completedLessons: 6,
    totalLessons: 8,
  ),
];

Widget _myCoursesMockList(BuildContext context) {
  return ListView.builder(
    padding: const EdgeInsets.all(16),
    itemCount: _mockMyCourses.length,
    itemBuilder: (context, index) {
      final course = _mockMyCourses[index];
      return _MyCourseCard(course: course);
    },
  );
}

class _MyCourseCard extends StatelessWidget {
  final _MyCourse course;

  const _MyCourseCard({required this.course});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: theme.brightness == Brightness.light
                ? Colors.black.withOpacity(0.05)
                : Colors.black.withOpacity(0.25),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            course.title,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: course.progress,
            minHeight: 8,
            backgroundColor: theme.colorScheme.onSurface.withOpacity(0.15),
            color: theme.colorScheme.primary,
          ),
        ],
      ),
    );
  }
}
