import 'package:animate_do/animate_do.dart';
import 'package:exim_lab/features/quiz/presentation/screens/quiz_question_screen.dart';
import 'package:exim_lab/features/quiz/presentation/states/quiz_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:exim_lab/core/services/shared_pref_service.dart';
import 'package:exim_lab/localization/app_localization.dart';
import 'package:exim_lab/core/services/analytics_service.dart';
import 'package:sizer/sizer.dart';
import 'package:shimmer/shimmer.dart';

class QuizTopicsScreen extends StatefulWidget {
  const QuizTopicsScreen({super.key});

  @override
  State<QuizTopicsScreen> createState() => _QuizTopicsScreenState();
}

class _QuizTopicsScreenState extends State<QuizTopicsScreen> {
  bool _isInitLoading = true;
  @override
  void initState() {
    super.initState();
    _loadTopics();
  }

  Future<void> _loadTopics() async {
    final user = await SharedPrefService().getUser();
    final userId = user?.id ?? "64f0cccc3333333333333333"; // Fallback for dev
    if (mounted) {
      await context.read<QuizProvider>().fetchTopics(userId);
      context.read<AnalyticsService>().logQuizTopicView('General');
      setState(() {
        _isInitLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final t = AppLocalizations.of(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(t.translate('quizzes_title')),
        backgroundColor: Colors.transparent,
        foregroundColor: cs.onSurface,
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              cs.surfaceContainerHighest.withValues(alpha: 0.5),
              cs.surface,
            ],
          ),
        ),
        child: Consumer<QuizProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading || _isInitLoading) {
              return ListView.separated(
                padding: EdgeInsets.fromLTRB(5.w, 12.h, 5.w, 2.h),
                itemCount: 6,
                separatorBuilder: (context, index) => SizedBox(height: 1.5.h),
                itemBuilder: (context, index) {
                  // Matches logic from dashboard_shimmer.dart
                  final isDark = theme.brightness == Brightness.dark;
                  final baseColor = isDark
                      ? Colors.grey[900]!
                      : Colors.grey[300]!;
                  final highlightColor = isDark
                      ? Colors.grey[800]!
                      : Colors.grey[100]!;

                  return Shimmer.fromColors(
                    baseColor: baseColor,
                    highlightColor: highlightColor,
                    child: Container(
                      padding: EdgeInsets.all(2.h),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 6.h,
                                height: 6.h,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              SizedBox(width: 3.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 40.w,
                                      height: 2.h,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                    SizedBox(height: 1.h),
                                    Container(
                                      width: 25.w,
                                      height: 1.5.h,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 2.h),
                          Row(
                            children: [
                              Container(
                                width: 22.w,
                                height: 3.5.h,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              SizedBox(width: 2.w),
                              Container(
                                width: 12.w,
                                height: 3.5.h,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              const Spacer(),
                              Container(
                                width: 4.h,
                                height: 4.h,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }

            if (provider.error != null) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(2.h),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline_rounded,
                        size: 48.sp,
                        color: cs.error,
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        "${t.translate('generic_error')}\n${provider.error}",
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: cs.error,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      ElevatedButton.icon(
                        onPressed: () => _loadTopics(),
                        icon: const Icon(Icons.refresh_rounded),
                        label: Text(t.translate('retry')),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (provider.topics.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.quiz_outlined,
                      size: 60.sp,
                      color: cs.outlineVariant,
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      t.translate('no_quizzes'),
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: cs.onSurfaceVariant,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView.separated(
              padding: EdgeInsets.fromLTRB(5.w, 12.h, 5.w, 5.h),
              itemCount: provider.topics.length,
              separatorBuilder: (context, index) => SizedBox(height: 2.h),
              itemBuilder: (context, index) {
                final topic = provider.topics[index];
                final isAttempted = topic.hasAttempted;

                return FadeInUp(
                  duration: const Duration(milliseconds: 500),
                  delay: Duration(milliseconds: (index < 5 ? index : 4) * 80),
                  child: Container(
                    decoration: BoxDecoration(
                      color: cs.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: cs.outlineVariant.withValues(alpha: 0.4),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => QuizQuestionScreen(
                                topicId: topic.id,
                                topicTitle: topic.title,
                              ),
                            ),
                          );
                        },
                        child: Padding(
                          padding: EdgeInsets.all(2.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Icon Container
                                  Container(
                                    padding: EdgeInsets.all(1.5.h),
                                    decoration: BoxDecoration(
                                      color: cs.primaryContainer.withValues(
                                        alpha: 0.4,
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Icon(
                                      Icons.quiz_rounded,
                                      color: cs.primary,
                                      size: 22.sp,
                                    ),
                                  ),
                                  SizedBox(width: 3.w),
                                  // Text Content
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          topic.title,
                                          style: theme.textTheme.titleMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.w700,
                                                height: 1.2,
                                              ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: 0.5.h),
                                        Text(
                                          topic.description,
                                          style: theme.textTheme.bodySmall
                                              ?.copyWith(
                                                color: cs.onSurfaceVariant,
                                                height: 1.4,
                                              ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 2.h),
                              // Bottom Row
                              Row(
                                children: [
                                  // Status Badge
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 2.5.w,
                                      vertical: 0.8.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isAttempted
                                          ? Colors.green.withValues(alpha: 0.1)
                                          : cs.surfaceContainerHighest
                                                .withValues(alpha: 0.5),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: isAttempted
                                            ? Colors.green.withValues(
                                                alpha: 0.2,
                                              )
                                            : Colors.transparent,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          isAttempted
                                              ? Icons.check_circle_rounded
                                              : Icons.circle_outlined,
                                          size: 12.sp,
                                          color: isAttempted
                                              ? Colors.green
                                              : cs.onSurfaceVariant,
                                        ),
                                        SizedBox(width: 1.5.w),
                                        Text(
                                          isAttempted
                                              ? t.translate('attempted')
                                              : t.translate('not_started'),
                                          style: theme.textTheme.labelSmall
                                              ?.copyWith(
                                                color: isAttempted
                                                    ? Colors.green.shade700
                                                    : cs.onSurfaceVariant,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 2.w),
                                  // Count Badge
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 2.5.w,
                                      vertical: 0.8.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: cs.surfaceContainerHighest
                                          .withValues(alpha: 0.5),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.format_list_numbered_rounded,
                                          size: 12.sp,
                                          color: cs.onSurfaceVariant,
                                        ),
                                        SizedBox(width: 1.5.w),
                                        Text(
                                          '${topic.totalQuestions}',
                                          style: theme.textTheme.labelSmall
                                              ?.copyWith(
                                                color: cs.onSurfaceVariant,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Spacer(),
                                  // Action Button
                                  Container(
                                    padding: EdgeInsets.all(1.h),
                                    decoration: BoxDecoration(
                                      color: cs.primaryContainer.withValues(
                                        alpha: 0.3,
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.arrow_forward_rounded,
                                      size: 18.sp,
                                      color: cs.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
