import 'package:exim_lab/core/services/shared_pref_service.dart';
import 'package:exim_lab/features/quiz/presentation/states/quiz_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:exim_lab/localization/app_localization.dart';
import 'package:exim_lab/core/services/analytics_service.dart';
import 'package:sizer/sizer.dart';
import 'package:animate_do/animate_do.dart';

class QuizQuestionScreen extends StatefulWidget {
  final String topicId;
  final String topicTitle;

  const QuizQuestionScreen({
    super.key,
    required this.topicId,
    required this.topicTitle,
  });

  @override
  State<QuizQuestionScreen> createState() => _QuizQuestionScreenState();
}

class _QuizQuestionScreenState extends State<QuizQuestionScreen> {
  int? selectedIndex;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final user = await SharedPrefService().getUser();

      if (!mounted) return;

      if (user?.id != null) {
        context.read<QuizProvider>().startQuiz(user!.id, widget.topicId);
        context.read<AnalyticsService>().logQuizStart(
          quizId: widget.topicId,
          title: widget.topicTitle,
        );
      } else {
        // Handle case where user is not found (e.g. logout or error)
        Navigator.pop(context);
      }
    });
  }

  void _handleOptionTap(int index, String questionId, int correctIndex) async {
    if (selectedIndex != null) return; // Prevent multiple taps

    setState(() {
      selectedIndex = index;
    });

    // Wait for 1 second to show feedback
    await Future.delayed(const Duration(milliseconds: 1000));

    if (mounted) {
      await context.read<QuizProvider>().submitAnswer(questionId, index);
      setState(() {
        selectedIndex = null;
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
        title: Text(widget.topicTitle),
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
            if (provider.isLoading && provider.currentAttempt == null) {
              return const Center(child: CircularProgressIndicator());
            }

            if (provider.error != null) {
              return Center(
                child: Text(
                  "${t.translate('generic_error')}: ${provider.error}",
                ),
              );
            }

            final questions = provider.questions;
            final attempt = provider.currentAttempt;

            if (questions.isEmpty) {
              return Center(child: Text(t.translate('no_questions')));
            }

            if (attempt != null && attempt.isCompleted) {
              // 📊 LOG FINISH
              WidgetsBinding.instance.addPostFrameCallback((_) {
                context.read<AnalyticsService>().logQuizFinish(
                  quizId: widget.topicId,
                );
              });

              return Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 4.h),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Animated success icon
                      Pulse(
                        duration: const Duration(milliseconds: 1000),
                        infinite: false,
                        child: Container(
                          padding: EdgeInsets.all(2.5.h),
                          decoration: BoxDecoration(
                            gradient: RadialGradient(
                              colors: [
                                Colors.green.withValues(alpha: 0.2),
                                Colors.green.withValues(alpha: 0.05),
                              ],
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Container(
                            padding: EdgeInsets.all(3.h),
                            decoration: BoxDecoration(
                              color: Colors.green.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.emoji_events_rounded,
                              size: 60.sp,
                              color: Colors.green.shade600,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 4.h),

                      // Title with fade in
                      FadeInDown(
                        duration: const Duration(milliseconds: 500),
                        delay: const Duration(milliseconds: 300),
                        child: Text(
                          t.translate('quiz_completed'),
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: cs.onSurface,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 1.5.h),

                      // Subtitle with fade in
                      FadeInDown(
                        duration: const Duration(milliseconds: 500),
                        delay: const Duration(milliseconds: 400),
                        child: Text(
                          'Excellent work! 🎉',
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: Colors.green.shade700,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 1.h),

                      FadeInDown(
                        duration: const Duration(milliseconds: 500),
                        delay: const Duration(milliseconds: 500),
                        child: Text(
                          'You\'ve successfully completed this quiz.\nKeep up the great progress!',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: cs.onSurfaceVariant,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      SizedBox(height: 5.h),

                      // Decorative stats card (optional)
                      FadeInUp(
                        duration: const Duration(milliseconds: 500),
                        delay: const Duration(milliseconds: 600),
                        child: Container(
                          padding: EdgeInsets.all(2.h),
                          decoration: BoxDecoration(
                            color: cs.primaryContainer.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: cs.primary.withValues(alpha: 0.2),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.quiz_rounded,
                                color: cs.primary,
                                size: 24.sp,
                              ),
                              SizedBox(width: 2.w),
                              Text(
                                'Quiz completed successfully',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: cs.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 4.h),

                      // Back button with animation
                      FadeInUp(
                        duration: const Duration(milliseconds: 500),
                        delay: const Duration(milliseconds: 700),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: cs.primary,
                              foregroundColor: cs.onPrimary,
                              padding: EdgeInsets.symmetric(vertical: 1.8.h),
                              elevation: 2,
                              shadowColor: cs.primary.withValues(alpha: 0.4),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.arrow_back_rounded, size: 20.sp),
                                SizedBox(width: 2.w),
                                Text(
                                  t.translate('back_to_topics'),
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: cs.onPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            final currentQuestionIndex = attempt?.currentQuestionIndex ?? 0;
            final currentQuestion = questions[currentQuestionIndex];

            return SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(5.w, 10.h, 5.w, 2.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Progress Bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: (currentQuestionIndex + 1) / questions.length,
                      color: cs.primary,
                      backgroundColor: cs.surfaceContainerHighest,
                      minHeight: 8,
                    ),
                  ),
                  SizedBox(height: 1.2.h),
                  Text(
                    "${t.translate('question_label')} ${currentQuestionIndex + 1}/${questions.length}",
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 3.h),

                  // Question Card
                  Container(
                    padding: EdgeInsets.all(2.5.h),
                    decoration: BoxDecoration(
                      color: cs.surface,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 30,
                          offset: const Offset(0, 10),
                        ),
                      ],
                      border: Border.all(
                        color: cs.outlineVariant.withValues(alpha: 0.5),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      currentQuestion.prompt,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        height: 1.4,
                        color: cs.onSurface,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 3.h),

                  // Options
                  ...List.generate(currentQuestion.options.length, (index) {
                    final bool isSelected = selectedIndex == index;
                    final bool isCorrect =
                        index == currentQuestion.correctOptionIndex;

                    Color tileColor = cs.surface;
                    Color borderColor = cs.outlineVariant;
                    Color dotColor = cs.surfaceContainerHighest.withValues(
                      alpha: 0.5,
                    );
                    Color charColor = cs.primary;

                    if (selectedIndex != null) {
                      if (isSelected) {
                        tileColor = isCorrect
                            ? Colors.green.withValues(alpha: 0.12)
                            : Colors.red.withValues(alpha: 0.12);
                        borderColor = isCorrect ? Colors.green : Colors.red;
                        dotColor = isCorrect ? Colors.green : Colors.red;
                        charColor = Colors.white;
                      } else if (isCorrect) {
                        tileColor = Colors.green.withValues(alpha: 0.05);
                        borderColor = Colors.green.withValues(alpha: 0.5);
                      }
                    }

                    return Padding(
                      padding: EdgeInsets.only(bottom: 1.5.h),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => _handleOptionTap(
                            index,
                            currentQuestion.id,
                            currentQuestion.correctOptionIndex,
                          ),
                          borderRadius: BorderRadius.circular(14),
                          child: Ink(
                            padding: EdgeInsets.all(2.h),
                            decoration: BoxDecoration(
                              color: tileColor,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: borderColor,
                                width: isSelected ? 2.5 : 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.08),
                                  blurRadius: 15,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 42,
                                  height: 42,
                                  decoration: BoxDecoration(
                                    color: dotColor,
                                    shape: BoxShape.circle,
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    String.fromCharCode(65 + index),
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: charColor,
                                        ),
                                  ),
                                ),
                                SizedBox(width: 3.w),
                                Expanded(
                                  child: Text(
                                    currentQuestion.options[index],
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      color: cs.onSurface,
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ),
                                if (selectedIndex != null && isSelected)
                                  Icon(
                                    isCorrect
                                        ? Icons.check_circle_rounded
                                        : Icons.cancel_rounded,
                                    color: isCorrect
                                        ? Colors.green
                                        : Colors.red,
                                    size: 24.sp,
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
