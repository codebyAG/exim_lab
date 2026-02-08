import 'package:exim_lab/core/navigation/app_navigator.dart';
import 'package:exim_lab/core/services/analytics_service.dart';
import 'package:exim_lab/features/courses/data/models/course_details_model.dart';
import 'package:provider/provider.dart';
import 'package:exim_lab/features/courses/presentation/screens/video_lesson_screen.dart';
import 'package:exim_lab/features/courses/presentation/widgets/lesson_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

class LessonsScreen extends StatefulWidget {
  final List<LessonModel> lessons;
  final String courseTitle;

  const LessonsScreen({
    super.key,
    required this.lessons,
    required this.courseTitle,
  });

  @override
  State<LessonsScreen> createState() => _LessonsScreenState();
}

class _LessonsScreenState extends State<LessonsScreen> {
  final bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const LessonShimmer();
    }

    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final groupedLessons = _groupByChapter(widget.lessons);

    return Scaffold(
      backgroundColor: cs.surface,

      appBar: AppBar(
        backgroundColor: cs.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: cs.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(widget.courseTitle, style: theme.textTheme.titleLarge),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment:
                CrossAxisAlignment.start, // Align to top for multiline
            children: [
              Expanded(
                child: Text(
                  chapter.title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 17,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: cs.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${chapter.lessons.length} Lessons',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: cs.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
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
        context.read<AnalyticsService>().logLessonStart(
          lessonId: lesson.id,
          lessonName: lesson.title,
          courseName:
              'Unknown', // We don't have course name in LessonTile context easily without passing down
        );

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
              height: 42,
              width: 42,
              decoration: BoxDecoration(
                color: _getLessonColor(lesson.type).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getLessonIcon(lesson.type),
                color: _getLessonColor(lesson.type),
                size: 20,
              ),
            ),

            const SizedBox(width: 12),

            // TITLE
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lesson.title,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: cs.onSurface,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    lesson.type.toUpperCase(),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: cs.onSurfaceVariant,
                      letterSpacing: 0.5,
                      fontWeight: FontWeight.w500,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),

            // TRAILING
            Icon(
              Icons.play_circle_fill,
              color: cs.primary.withValues(alpha: 0.8),
              size: 28,
            ),
          ],
        ),
      ),
    );
  }

  IconData _getLessonIcon(String type) {
    switch (type.toLowerCase()) {
      case 'video':
        return Icons.play_arrow_rounded;
      case 'quiz':
        return Icons.quiz_rounded;
      case 'document':
      case 'pdf':
        return Icons.description_rounded;
      default:
        return Icons.play_circle_outline_rounded;
    }
  }

  Color _getLessonColor(String type) {
    switch (type.toLowerCase()) {
      case 'quiz':
        return Colors.orange;
      case 'document':
      case 'pdf':
        return Colors.blue;
      default:
        return const Color(0xFFE53935); // Primary Redish
    }
  }
}

// ================= INTERNAL MODELS =================

class _Chapter {
  final String title;
  final List<LessonModel> lessons;

  const _Chapter({required this.title, required this.lessons});
}
