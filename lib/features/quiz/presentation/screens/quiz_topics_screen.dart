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

    // Modern Gradient Palette
    final gradients = [
      [const Color(0xFF6A11CB), const Color(0xFF2575FC)], // Purple-Blue
      [const Color(0xFFFF9A9E), const Color(0xFFFECFEF)], // Pink-Rose
      [const Color(0xFFFBAB7E), const Color(0xFFF7CE68)], // Orange-Gold
      [const Color(0xFF85FFBD), const Color(0xFFFFFB7D)], // Green-Yellow
      [const Color(0xFFFF3CAC), const Color(0xFF784BA0)], // Pink-Purple
      [const Color(0xFF0093E9), const Color(0xFF80D0C7)], // Blue-Cyan
    ];

    return Scaffold(
      backgroundColor: cs.surface,
      body: Consumer<QuizProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading || _isInitLoading) {
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 18.h,
                  floating: false,
                  pinned: true,
                  backgroundColor: cs.surface,
                  surfaceTintColor: Colors.transparent,
                  flexibleSpace: FlexibleSpaceBar(
                    titlePadding: EdgeInsets.only(left: 5.w, bottom: 2.h),
                    title: Text(
                      t.translate('quizzes_title'),
                      style: theme.textTheme.headlineMedium?.copyWith(
                        color: cs.onSurface,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 4.w,
                      mainAxisSpacing: 2.h,
                      childAspectRatio: 0.8,
                    ),
                    delegate: SliverChildBuilderDelegate((context, index) {
                      return Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                      );
                    }, childCount: 6),
                  ),
                ),
              ],
            );
          }

          if (provider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 40.sp, color: cs.error),
                  SizedBox(height: 2.h),
                  Text("${t.translate('generic_error')}\n${provider.error}"),
                  ElevatedButton(
                    onPressed: _loadTopics,
                    child: Text(t.translate('retry')),
                  ),
                ],
              ),
            );
          }

          if (provider.topics.isEmpty) {
            return Center(child: Text(t.translate('no_quizzes')));
          }

          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Large Header
              SliverAppBar(
                expandedHeight: 18.h,
                floating: false,
                pinned: true,
                backgroundColor: cs.surface,
                surfaceTintColor: Colors.transparent,
                flexibleSpace: FlexibleSpaceBar(
                  expandedTitleScale: 1.5,
                  titlePadding: EdgeInsets.only(left: 5.w, bottom: 2.h),
                  title: Row(
                    children: [
                      Text(
                        t.translate('quizzes_title'),
                        style: theme.textTheme.headlineLarge?.copyWith(
                          color: cs.onSurface,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -1,
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: cs.primaryContainer,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.local_fire_department_rounded,
                          color: cs.primary,
                          size: 14.sp,
                        ),
                      ),
                    ],
                  ),
                  background: Align(
                    alignment: Alignment.topRight,
                    child: Opacity(
                      opacity: 0.1,
                      child: Transform.translate(
                        offset: const Offset(50, -50),
                        child: Icon(
                          Icons.quiz_rounded,
                          size: 150.sp,
                          color: cs.primary,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Grid Content
              SliverPadding(
                padding: EdgeInsets.fromLTRB(5.w, 1.h, 5.w, 5.h),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 4.w,
                    mainAxisSpacing: 2.5.h,
                    childAspectRatio: 0.75, // Taller cards
                  ),
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final topic = provider.topics[index];
                    final gradient = gradients[index % gradients.length];
                    final isAttempted = topic.hasAttempted;

                    return FadeInUp(
                      duration: const Duration(milliseconds: 600),
                      delay: Duration(milliseconds: index * 100),
                      child: GestureDetector(
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
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: gradient,
                            ),
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: gradient[0].withValues(alpha: 0.4),
                                blurRadius: 15,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Stack(
                            children: [
                              // Background Pattern
                              Positioned(
                                right: -20,
                                top: -20,
                                child: Icon(
                                  Icons.extension_rounded,
                                  size: 80.sp,
                                  color: Colors.white.withValues(alpha: 0.1),
                                ),
                              ),

                              // Content
                              Padding(
                                padding: EdgeInsets.all(2.h),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Icon
                                    Container(
                                      padding: EdgeInsets.all(1.2.h),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(
                                          alpha: 0.2,
                                        ),
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.white.withValues(
                                            alpha: 0.4,
                                          ),
                                          width: 1,
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.school_rounded,
                                        color: Colors.white,
                                        size: 20.sp,
                                      ),
                                    ),
                                    const Spacer(),
                                    // Title
                                    Text(
                                      topic.title,
                                      style: theme.textTheme.titleLarge
                                          ?.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            height: 1.1,
                                          ),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 0.5.h),
                                    // Questions Count
                                    Text(
                                      "${topic.totalQuestions} Questions",
                                      style: theme.textTheme.bodyMedium
                                          ?.copyWith(
                                            color: Colors.white.withValues(
                                              alpha: 0.8,
                                            ),
                                          ),
                                    ),
                                    SizedBox(height: 1.5.h),
                                    // Status / Button
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 1.5.h,
                                        vertical: 0.8.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            isAttempted ? "Retake" : "Start",
                                            style: theme.textTheme.labelMedium
                                                ?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: gradient[0],
                                                ),
                                          ),
                                          SizedBox(width: 0.5.w),
                                          Icon(
                                            Icons.play_arrow_rounded,
                                            size: 14.sp,
                                            color: gradient[0],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }, childCount: provider.topics.length),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
