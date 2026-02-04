import 'package:exim_lab/core/navigation/app_navigator.dart';
import 'package:exim_lab/features/courses/data/models/course_model.dart';
import 'package:exim_lab/features/courses/presentation/screens/courses_details_screen.dart';
import 'package:exim_lab/features/dashboard/presentation/widgets/course_card.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class HorizontalCourses extends StatelessWidget {
  final List<CourseModel> courses;
  const HorizontalCourses({super.key, required this.courses});

  @override
  Widget build(BuildContext context) {
    if (courses.isEmpty) return const SizedBox();

    return SizedBox(
      height: 25.h, // 🔹 responsive height
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        itemCount: courses.length,
        separatorBuilder: (_, __) => SizedBox(width: 2.w),
        itemBuilder: (context, index) {
          final course = courses[index];
          // Determine learners count (mock logic if missing or assume 0)
          // CourseCard expects title, rating, learners, image.
          // Note: CourseModel has basePrice but not rating/learners.
          // We'll use mock/default for now or update CourseCard to take CourseModel.
          // Using CourseCard primitive args for now.

          return CourseCard(
            title: course.title,
            rating: (course.rating ?? 4.5).toString(),
            learners: '${course.learnersCount ?? 0} Learners',
            image: course.imageUrl ?? 'assets/course1.png',
            onTap: () {
              AppNavigator.push(
                context,
                CourseDetailsScreen(courseId: course.id),
              );
            },
          );
        },
      ),
    );
  }
}
