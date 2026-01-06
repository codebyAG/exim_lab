import 'package:exim_lab/core/navigation/app_navigator.dart';
import 'package:exim_lab/features/courses/presentation/screens/courses_details_screen.dart';
import 'package:flutter/material.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
          _courseList(context),
          _myCoursesMockList(context),
          _courseList(context),
        ],
      ),
    );
  }

  // 🔹 ALL COURSES LIST
  Widget _courseList(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _courses.length,
      itemBuilder: (context, index) {
        final course = _courses[index];
        return _CourseTile(course: course);
      },
    );
  }
}

// 🔹 COURSE TILE
class _CourseTile extends StatelessWidget {
  final _Course course;

  const _CourseTile({required this.course});

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
                  course.title,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  course.subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.65),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.star, size: 14, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text(
                      '${course.rating} • ${course.learners} learners',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // ACTION
          ElevatedButton(
            onPressed: () {
              AppNavigator.push(context, const CourseDetailsScreen());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 0,
            ),
            child: const Text('View'),
          ),
        ],
      ),
    );
  }
}

// 🔹 COURSE MODEL
class _Course {
  final String id;
  final String title;
  final String subtitle;
  final String rating;
  final String learners;
  final int totalLessons;

  const _Course({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.rating,
    required this.learners,
    required this.totalLessons,
  });
}

const List<_Course> _courses = [
  _Course(
    id: 'export_strategy',
    title: 'Advanced Export Strategy',
    subtitle: 'Learn how to scale exports and find global buyers',
    rating: '4.8',
    learners: '2.1k',
    totalLessons: 10,
  ),
  _Course(
    id: 'import_docs',
    title: 'Import Documentation Mastery',
    subtitle: 'Understand bills, invoices, HS codes & compliance',
    rating: '4.8',
    learners: '1.9k',
    totalLessons: 8,
  ),
];

// 🔹 MY COURSES CARD
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

          const SizedBox(height: 6),

          Text(
            '${course.completedLessons}/${course.totalLessons} lessons completed',
            style: theme.textTheme.bodySmall,
          ),

          const SizedBox(height: 12),

          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: course.progress,
              minHeight: 8,
              backgroundColor: theme.colorScheme.onSurface.withOpacity(0.15),
              color: theme.colorScheme.primary,
            ),
          ),

          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            height: 42,
            child: ElevatedButton(
              onPressed: () {
                AppNavigator.push(context, const CourseDetailsScreen());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text('Resume Learning'),
            ),
          ),
        ],
      ),
    );
  }
}

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
