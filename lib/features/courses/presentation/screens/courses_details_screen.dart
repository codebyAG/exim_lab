import 'package:exim_lab/core/navigation/app_navigator.dart';
import 'package:exim_lab/features/courses/presentation/screens/lesson_screen.dart';
import 'package:flutter/material.dart';

class CourseDetailsScreen extends StatelessWidget {
  const CourseDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,

      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Course Details', style: theme.textTheme.titleLarge),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 HERO CARD
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: theme.brightness == Brightness.light
                        ? Colors.black.withOpacity(0.05)
                        : Colors.black.withOpacity(0.25),
                    blurRadius: 12,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Thumbnail
                  Container(
                    height: 180,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.play_circle_outline,
                        size: 54,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    'Advanced Export Strategy',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    'Learn how to find global buyers, price your products, and scale exports professionally.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.65),
                      height: 1.4,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Stats
                  Row(
                    children: const [
                      _StatChip(icon: Icons.star, text: '4.8', isAccent: true),
                      SizedBox(width: 8),
                      _StatChip(icon: Icons.people, text: '2.1k learners'),
                      SizedBox(width: 8),
                      _StatChip(icon: Icons.schedule, text: '6 hrs'),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 🔹 ABOUT
            _sectionTitle(context, 'About this course'),
            const SizedBox(height: 8),
            Text(
              'This course is designed for beginners and professionals who want to understand export business practically. '
              'You will learn real processes, documentation, pricing strategies, and compliance requirements.',
              style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
            ),

            const SizedBox(height: 24),

            // 🔹 WHAT YOU WILL LEARN
            _sectionTitle(context, 'What you will learn'),
            const SizedBox(height: 12),
            const _Bullet(text: 'How to find international buyers'),
            const _Bullet(text: 'Export pricing and profit calculation'),
            const _Bullet(text: 'Documents required for export'),
            const _Bullet(text: 'Shipping, logistics, and incoterms'),
            const _Bullet(text: 'Payment methods and risk management'),

            const SizedBox(height: 32),

            // 🔹 CTA
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  AppNavigator.push(context, const LessonsScreen());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Enroll & Start Learning',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(BuildContext context, String text) {
    final theme = Theme.of(context);
    return Text(
      text,
      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
    );
  }
}

// 🔹 STAT CHIP
class _StatChip extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool isAccent;

  const _StatChip({
    required this.icon,
    required this.text,
    this.isAccent = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.onSurface.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 14,
            color: isAccent
                ? Colors.amber
                : theme.colorScheme.onSurface.withOpacity(0.7),
          ),
          const SizedBox(width: 4),
          Text(text, style: theme.textTheme.bodySmall),
        ],
      ),
    );
  }
}

// 🔹 BULLET
class _Bullet extends StatelessWidget {
  final String text;

  const _Bullet({required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle,
            size: 18,
            color: theme.colorScheme.secondary,
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: theme.textTheme.bodyMedium)),
        ],
      ),
    );
  }
}
