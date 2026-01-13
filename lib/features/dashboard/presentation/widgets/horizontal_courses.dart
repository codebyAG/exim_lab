import 'package:exim_lab/features/dashboard/presentation/widgets/course_card.dart';
import 'package:flutter/material.dart';

class HorizontalCourses extends StatelessWidget {
  const HorizontalCourses();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 210,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          const CourseCard(
            title: 'Advanced Export Strategy',
            rating: '4.8',
            learners: '2.1k',
            image: 'assets/course1.png',
          ),
          const SizedBox(width: 14),
          const CourseCard(
            title: 'Import Documentation Mastery',
            rating: '4.8',
            learners: '1.9k',
            image: 'assets/course2.png',
          ),
          const SizedBox(width: 14),
          const CourseCard(
            title: 'Export Business Basics',
            rating: '4.7',
            learners: '1.4k',
            image: 'assets/course3.jpg',
          ),
        ],
      ),
    );
  }
}
