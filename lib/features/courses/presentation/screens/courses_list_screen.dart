import 'package:exim_lab/core/navigation/app_navigator.dart';
import 'package:exim_lab/features/courses/data/course_progress_helper.dart';
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
      backgroundColor: const Color(0xFFF6F7FB),

      // 🔹 APP BAR
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Courses',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // TODO: Search
            },
            icon: const Icon(Icons.search, color: Colors.black),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFFFF8A00),
          unselectedLabelColor: Colors.grey,
          indicatorColor: const Color(0xFFFF8A00),
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
          _courseList(),
          _myCoursesMockList(), // ✅ mock data
          _courseList(),
        ],
      ),
    );
  }

  // 🔹 ALL COURSES LIST
  Widget _courseList() {
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
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          // 🔹 THUMBNAIL PLACEHOLDER
          Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.play_circle_fill,
              size: 36,
              color: Color(0xFFFF8A00),
            ),
          ),

          const SizedBox(width: 14),

          // 🔹 DETAILS
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  course.title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  course.subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 13, color: Colors.black54),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.star, size: 14, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text(
                      '${course.rating} • ${course.learners} learners',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // 🔹 ACTION
          ElevatedButton(
            onPressed: () {
              AppNavigator.push(context, const CourseDetailsScreen());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF8A00),
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

// 🔹 COURSE MODEL (STATIC DATA)
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

class _MyCourseCard extends StatelessWidget {
  final _MyCourse course;

  const _MyCourseCard({required this.course});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            course.title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 6),

          Text(
            '${course.completedLessons}/${course.totalLessons} lessons completed',
            style: const TextStyle(fontSize: 13, color: Colors.black54),
          ),

          const SizedBox(height: 12),

          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: course.progress,
              minHeight: 8,
              backgroundColor: Colors.grey.shade200,
              color: const Color(0xFFFF8A00),
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
                backgroundColor: const Color(0xFFFF8A00),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Resume Learning',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
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
Widget _myCoursesMockList() {
  return ListView.builder(
    padding: const EdgeInsets.all(16),
    itemCount: _mockMyCourses.length,
    itemBuilder: (context, index) {
      final course = _mockMyCourses[index];
      return _MyCourseCard(course: course);
    },
  );
}
