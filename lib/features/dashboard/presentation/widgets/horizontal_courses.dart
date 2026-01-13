import 'package:exim_lab/features/dashboard/presentation/widgets/course_card.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class HorizontalCourses extends StatelessWidget {
  const HorizontalCourses({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 25.h, // 🔹 responsive height
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        children: [
          CourseCard(
            title: 'Advanced Export Strategy',
            rating: '4.8',
            learners: '2.1k',
            image: 'assets/course1.png',
          ),

          SizedBox(width: 2.w),

          CourseCard(
            title: 'Import Documentation Mastery',
            rating: '4.8',
            learners: '1.9k',
            image: 'assets/course2.png',
          ),

          SizedBox(width: 2.w),

          CourseCard(
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
