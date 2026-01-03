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
        children: [_courseList(), _myCoursesEmpty(), _courseList()],
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

  // 🔹 EMPTY STATE (MY COURSES)
  Widget _myCoursesEmpty() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.menu_book_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'You haven’t enrolled in any course yet.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 6),
            Text(
              'Start learning to see your courses here.',
              style: TextStyle(color: Colors.black54),
            ),
          ],
        ),
      ),
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
  final String title;
  final String subtitle;
  final String rating;
  final String learners;

  const _Course({
    required this.title,
    required this.subtitle,
    required this.rating,
    required this.learners,
  });
}

const List<_Course> _courses = [
  _Course(
    title: 'Advanced Export Strategy',
    subtitle: 'Learn how to scale exports and find global buyers',
    rating: '4.8',
    learners: '2.1k',
  ),
  _Course(
    title: 'Import Documentation Mastery',
    subtitle: 'Understand bills, invoices, HS codes & compliance',
    rating: '4.8',
    learners: '1.9k',
  ),
  _Course(
    title: 'Logistics & Shipping Basics',
    subtitle: 'Shipping methods, incoterms and freight basics',
    rating: '4.7',
    learners: '1.4k',
  ),
];
