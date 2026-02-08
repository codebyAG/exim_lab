import 'package:exim_lab/core/navigation/app_navigator.dart';
import 'package:exim_lab/features/courses/data/models/course_details_model.dart';
import 'package:exim_lab/features/courses/presentation/screens/video_lesson_screen.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

class LessonsScreen extends StatelessWidget {
  final List<LessonModel> lessons;
  final String courseTitle;

  const LessonsScreen({
    super.key,
    required this.lessons,
    required this.courseTitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final groupedLessons = _groupByChapter(lessons);

    return Scaffold(
      backgroundColor: cs.surface,

      appBar: AppBar(
        backgroundColor: cs.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: cs.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(courseTitle, style: theme.textTheme.titleLarge),
      ),

      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: groupedLessons.length,
        itemBuilder: (context, index) {
          final chapter = groupedLessons[index];
          return FadeInUp(
            duration: const Duration(milliseconds: 600),
            delay: Duration(milliseconds: index * 100),
            child: _ChapterCard(chapter: chapter),
          );
        },
      ),
    );
  }

  /// 🔹 GROUP LESSONS BY CHAPTER
  List<_Chapter> _groupByChapter(List<LessonModel> lessons) {
    final Map<String, List<LessonModel>> map = {};

    for (final lesson in lessons) {
      map.putIfAbsent(lesson.chapterTitle, () => []);
      map[lesson.chapterTitle]!.add(lesson);
    }

    return map.entries.map((e) {
      return _Chapter(title: e.key, lessons: e.value);
    }).toList();
  }
}

// ================= CHAPTER CARD =================

class _ChapterCard extends StatelessWidget {
  final _Chapter chapter;

  const _ChapterCard({required this.chapter});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surface,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // CHAPTER TITLE
          Text(
            chapter.title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 12),

          Column(
            children: chapter.lessons.asMap().entries.map((entry) {
              final index = entry.key;
              final lesson = entry.value;
              return FadeInRight(
                delay: Duration(milliseconds: 200 + (index * 50)),
                child: _LessonTile(lesson: lesson),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

// ================= LESSON TILE =================

class _LessonTile extends StatelessWidget {
  final LessonModel lesson;

  const _LessonTile({required this.lesson});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return InkWell(
      onTap: () {
        AppNavigator.push(
          context,
          VideoLessonScreen(videoUrl: lesson.contentUrl, title: lesson.title),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            // ICON
            Container(
              height: 38,
              width: 38,
              decoration: BoxDecoration(
                color: cs.primary.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.play_arrow, color: cs.primary),
            ),

            const SizedBox(width: 12),

            // TITLE
            Expanded(
              child: Text(
                lesson.title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ================= INTERNAL MODELS =================

class _Chapter {
  final String title;
  final List<LessonModel> lessons;

  const _Chapter({required this.title, required this.lessons});
}
