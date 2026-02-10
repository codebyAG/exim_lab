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
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 18,
                color: Colors.white,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        actions: const [],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [cs.primary, cs.secondary], // Theme colors
          ),
        ),
        child: Consumer<QuizProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading && provider.currentAttempt == null) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            }

            if (provider.error != null) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(3.h),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 48.sp,
                        color: Colors.white,
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        "${t.translate('generic_error')}\n${provider.error}",
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            final questions = provider.questions;
            final attempt = provider.currentAttempt;

            if (questions.isEmpty) {
              return Center(
                child: Text(
                  t.translate('no_questions'),
                  style: const TextStyle(color: Colors.white),
                ),
              );
            }

            // --- COMPLETION SCREEN ---
            if (attempt != null && attempt.isCompleted) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                context.read<AnalyticsService>().logQuizFinish(
                  quizId: widget.topicId,
                );
              });
              return Center(
                child: Container(
                  margin: EdgeInsets.all(3.h),
                  padding: EdgeInsets.all(3.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Pulse(
                        child: Icon(
                          Icons.emoji_events_rounded,
                          size: 60.sp,
                          color: Colors.orange,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        t.translate('quiz_completed'),
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: cs.onSurface,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        'Great job! You finished all questions.',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      // Topic Title on completion
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: cs.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          widget.topicTitle,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: cs.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: cs.primary,
                            foregroundColor: cs.onPrimary,
                            padding: EdgeInsets.symmetric(vertical: 2.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(t.translate('back_to_topics')),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            final currentQuestionIndex = attempt?.currentQuestionIndex ?? 0;
            final currentQuestion = questions[currentQuestionIndex];

            // --- MAIN QUIZ UI ---
            return Column(
              children: [
                // Top Section (Question & Progress)
                Expanded(
                  flex: 4,
                  child: SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(5.w, 2.h, 5.w, 4.h),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Topic Badge
                          FadeInDown(
                            duration: const Duration(milliseconds: 600),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.3),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.auto_awesome_rounded,
                                    size: 14,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    widget.topicTitle.toUpperCase(),
                                    style: theme.textTheme.labelMedium
                                        ?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.5,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 3.h),
                          // Circular Progress
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                width: 8.h,
                                height: 8.h,
                                child: CircularProgressIndicator(
                                  value:
                                      (currentQuestionIndex + 1) /
                                      questions.length,
                                  strokeWidth: 6,
                                  backgroundColor: Colors.white.withValues(
                                    alpha: 0.2,
                                  ),
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                ),
                              ),
                              Text(
                                "${currentQuestionIndex + 1}",
                                style: theme.textTheme.titleLarge?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 4.h),
                          // Question Text
                          Text(
                            currentQuestion.prompt,
                            style: theme.textTheme.headlineSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              height: 1.3,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Bottom Section (Options)
                Expanded(
                  flex: 6,
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(4.h),
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          children: List.generate(
                            currentQuestion.options.length,
                            (index) {
                              final bool isSelected = selectedIndex == index;
                              final bool isCorrect =
                                  index == currentQuestion.correctOptionIndex;

                              Color bgColor = cs.surface;
                              Color borderColor = cs.outlineVariant.withValues(
                                alpha: 0.3,
                              );
                              Color textColor = cs.onSurface;

                              if (selectedIndex != null) {
                                if (isSelected) {
                                  bgColor = isCorrect
                                      ? Colors.green.withValues(alpha: 0.1)
                                      : Colors.red.withValues(alpha: 0.1);
                                  borderColor = isCorrect
                                      ? Colors.green
                                      : Colors.red;
                                  textColor = isCorrect
                                      ? Colors.green
                                      : Colors.red;
                                } else if (isCorrect) {
                                  bgColor = Colors.green.withValues(alpha: 0.1);
                                  borderColor = Colors.green;
                                  textColor = Colors.green;
                                }
                              }

                              return FadeInUp(
                                duration: const Duration(milliseconds: 500),
                                delay: Duration(milliseconds: index * 100),
                                child: Padding(
                                  padding: EdgeInsets.only(bottom: 2.h),
                                  child: InkWell(
                                    onTap: () => _handleOptionTap(
                                      index,
                                      currentQuestion.id,
                                      currentQuestion.correctOptionIndex,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                    child: AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 300,
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 3.w,
                                        vertical: 2.5.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: bgColor,
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: borderColor,
                                          width: isSelected ? 2 : 1,
                                        ),
                                        boxShadow: [
                                          if (!isSelected &&
                                              selectedIndex == null)
                                            BoxShadow(
                                              color: Colors.black.withValues(
                                                alpha: 0.05,
                                              ),
                                              blurRadius: 10,
                                              offset: const Offset(0, 4),
                                            ),
                                        ],
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 40,
                                            height: 40,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: borderColor.withValues(
                                                alpha: 0.2,
                                              ),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Text(
                                              String.fromCharCode(65 + index),
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: textColor,
                                                fontSize: 14.sp,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 4.w),
                                          Expanded(
                                            child: Text(
                                              currentQuestion.options[index],
                                              style: theme.textTheme.bodyLarge
                                                  ?.copyWith(
                                                    color: cs.onSurface,
                                                    fontWeight: isSelected
                                                        ? FontWeight.bold
                                                        : FontWeight.w500,
                                                  ),
                                            ),
                                          ),
                                          if (selectedIndex != null &&
                                              isSelected)
                                            Icon(
                                              isCorrect
                                                  ? Icons.check_circle
                                                  : Icons.cancel,
                                              color: isCorrect
                                                  ? Colors.green
                                                  : Colors.red,
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
