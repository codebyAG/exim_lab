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
                itemCount: 3,
                separatorBuilder: (context, index) => SizedBox(height: 1.5.h),
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: cs.surface,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Shimmer.fromColors(
                      baseColor: cs.surfaceContainerHighest,
                      highlightColor: cs.surface,
                      child: Padding(
                        padding: EdgeInsets.all(2.h),
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
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                SizedBox(width: 3.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 40.w,
                                        height: 2.h,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 1.h),
                                      Container(
                                        width: 30.w,
                                        height: 1.5.h,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
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
                                  width: 20.w,
                                  height: 2.5.h,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                SizedBox(width: 2.w),
                                Container(
                                  width: 15.w,
                                  height: 2.5.h,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                const Spacer(),
                                Container(
                                  width: 3.h,
                                  height: 3.h,
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
                    ),
                  );
                },
              );
            }

            if (provider.error != null) {
              return Center(
                child: Text(
                  "${t.translate('generic_error')}: ${provider.error}",
                ),
              );
            }

            if (provider.topics.isEmpty) {
              return Center(child: Text(t.translate('no_quizzes')));
            }

            return ListView.separated(
              padding: EdgeInsets.fromLTRB(5.w, 12.h, 5.w, 2.h),
              itemCount: provider.topics.length,
              separatorBuilder: (context, index) => SizedBox(height: 1.5.h),
              itemBuilder: (context, index) {
                final topic = provider.topics[index];
                return FadeInUp(
                  duration: const Duration(milliseconds: 400),
                  delay: Duration(milliseconds: (index < 6 ? index : 5) * 70),
                  child: Container(
                    decoration: BoxDecoration(
                      color: cs.surface,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
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
                                  Container(
                                    padding: EdgeInsets.all(1.2.h),
                                    decoration: BoxDecoration(
                                      color: cs.primaryContainer,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      Icons.quiz_rounded,
                                      color: cs.primary,
                                      size: 24.sp,
                                    ),
                                  ),
                                  SizedBox(width: 3.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          topic.title,
                                          style: theme.textTheme.titleMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                        SizedBox(height: 0.4.h),
                                        Text(
                                          topic.description,
                                          style: theme.textTheme.bodyMedium
                                              ?.copyWith(
                                                color: cs.onSurfaceVariant,
                                              ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 1.5.h),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 2.5.w,
                                          vertical: 0.6.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color: topic.hasAttempted
                                              ? Colors.green.withValues(
                                                  alpha: 0.1,
                                                )
                                              : cs.surfaceContainerHighest,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              topic.hasAttempted
                                                  ? Icons.check_circle_outline
                                                  : Icons.circle_outlined,
                                              size: 14.sp,
                                              color: topic.hasAttempted
                                                  ? Colors.green
                                                  : cs.onSurfaceVariant,
                                            ),
                                            SizedBox(width: 1.w),
                                            Text(
                                              topic.hasAttempted
                                                  ? t.translate('attempted')
                                                  : t.translate('not_started'),
                                              style: theme.textTheme.labelSmall
                                                  ?.copyWith(
                                                    color: topic.hasAttempted
                                                        ? Colors.green
                                                        : cs.onSurfaceVariant,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 2.w),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 2.5.w,
                                          vertical: 0.6.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color: cs.primaryContainer.withValues(
                                            alpha: 0.3,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.quiz_outlined,
                                              size: 14.sp,
                                              color: cs.primary,
                                            ),
                                            SizedBox(width: 1.w),
                                            Text(
                                              '${topic.totalQuestions}',
                                              style: theme.textTheme.labelSmall
                                                  ?.copyWith(
                                                    color: cs.primary,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Icon(
                                    Icons.arrow_forward_rounded,
                                    color: cs.primary,
                                    size: 20.sp,
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
