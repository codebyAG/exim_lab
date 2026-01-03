import 'package:exim_lab/core/navigation/app_navigator.dart';
import 'package:exim_lab/features/courses/presentation/screens/video_lesson_screen.dart';
import 'package:flutter/material.dart';

class LessonsScreen extends StatelessWidget {
  const LessonsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Course Lessons',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _modules.length,
        itemBuilder: (context, index) {
          final module = _modules[index];
          return _ModuleCard(module: module);
        },
      ),
    );
  }
}

// 🔹 MODULE CARD
class _ModuleCard extends StatelessWidget {
  final _Module module;

  const _ModuleCard({required this.module});

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
          // 🔹 MODULE TITLE
          Text(
            module.title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 4),

          Text(
            '${module.lessons.length} lessons • ${module.duration}',
            style: const TextStyle(fontSize: 13, color: Colors.black54),
          ),

          const SizedBox(height: 12),

          // 🔹 LESSON LIST
          Column(
            children: module.lessons.map((lesson) {
              return _LessonTile(lesson: lesson);
            }).toList(),
          ),
        ],
      ),
    );
  }
}

// 🔹 LESSON TILE
class _LessonTile extends StatelessWidget {
  final _Lesson lesson;

  const _LessonTile({required this.lesson});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: lesson.isLocked
          ? null
          : () {
              AppNavigator.push(context, const VideoLessonScreen());
            },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            // ICON
            Container(
              height: 36,
              width: 36,
              decoration: BoxDecoration(
                color: lesson.isLocked
                    ? Colors.grey.shade200
                    : const Color(0xFFFF8A00).withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                lesson.isLocked ? Icons.lock : Icons.play_arrow,
                color: lesson.isLocked ? Colors.grey : const Color(0xFFFF8A00),
              ),
            ),

            const SizedBox(width: 12),

            // TITLE + DURATION
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lesson.title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: lesson.isLocked ? Colors.grey : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    lesson.duration,
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ],
              ),
            ),

            // STATUS ICON
            if (lesson.isCompleted)
              const Icon(Icons.check_circle, color: Color(0xFF22C55E)),
          ],
        ),
      ),
    );
  }
}

// 🔹 DATA MODELS
class _Module {
  final String title;
  final String duration;
  final List<_Lesson> lessons;

  const _Module({
    required this.title,
    required this.duration,
    required this.lessons,
  });
}

class _Lesson {
  final String title;
  final String duration;
  final bool isLocked;
  final bool isCompleted;

  const _Lesson({
    required this.title,
    required this.duration,
    this.isLocked = false,
    this.isCompleted = false,
  });
}

// 🔹 STATIC DATA
const List<_Module> _modules = [
  _Module(
    title: 'Module 1: Export Fundamentals',
    duration: '45 min',
    lessons: [
      _Lesson(
        title: 'Introduction to Export Business',
        duration: '6:30',
        isCompleted: true,
      ),
      _Lesson(
        title: 'Export Opportunities',
        duration: '8:10',
        isCompleted: true,
      ),
      _Lesson(title: 'Export Registration Process', duration: '10:20'),
    ],
  ),
  _Module(
    title: 'Module 2: Documentation & Compliance',
    duration: '1 hr 10 min',
    lessons: [
      _Lesson(
        title: 'Required Export Documents',
        duration: '12:40',
        isLocked: true,
      ),
      _Lesson(title: 'HS Codes Explained', duration: '9:30', isLocked: true),
      _Lesson(
        title: 'Customs Clearance Process',
        duration: '15:00',
        isLocked: true,
      ),
    ],
  ),
];
