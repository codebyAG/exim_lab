import 'package:exim_lab/core/services/shared_pref_service.dart';
import 'package:exim_lab/features/quiz/presentation/states/quiz_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:exim_lab/localization/app_localization.dart';
import 'package:exim_lab/core/services/analytics_service.dart';
import 'package:sizer/sizer.dart';
import 'package:animate_do/animate_do.dart';
import 'package:exim_lab/core/theme/app_colors.dart';

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

  // Mockup light palette
  static const Color _bg = AppColors.lightBg;
  static const Color _navy = AppColors.navy;
  static const Color _blue = AppColors.blue;

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
        Navigator.pop(context);
      }
    });
  }

  void _selectOption(int index) {
    if (selectedIndex != null) return; // lock after choosing
    setState(() => selectedIndex = index);
  }

  Future<void> _handleNext(String questionId) async {
    if (selectedIndex == null) return;
    final chosen = selectedIndex!;
    setState(() => selectedIndex = null);
    await context.read<QuizProvider>().submitAnswer(questionId, chosen);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: _navy),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          "Quiz",
          style: TextStyle(
            color: _navy,
            fontWeight: FontWeight.w800,
            fontSize: 18,
          ),
        ),
      ),
      body: Consumer<QuizProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.currentAttempt == null) {
            return const Center(
              child: CircularProgressIndicator(color: _blue),
            );
          }

          if (provider.error != null) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(6.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 48.sp, color: _navy),
                    SizedBox(height: 2.h),
                    Text(
                      "${t.translate('generic_error')}\n${provider.error}",
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyLarge?.copyWith(color: _navy),
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
                style: const TextStyle(color: _navy),
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
            return _buildCompletion(context, theme, t);
          }

          final currentQuestionIndex = attempt?.currentQuestionIndex ?? 0;
          final currentQuestion = questions[currentQuestionIndex];
          final progress = (currentQuestionIndex + 1) / questions.length;

          // --- MAIN QUIZ UI (mockup light) ---
          return SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(5.w, 1.h, 5.w, 2.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Progress header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Question ${currentQuestionIndex + 1} of ${questions.length}",
                        style: TextStyle(
                          color: _navy.withValues(alpha: 0.6),
                          fontWeight: FontWeight.w700,
                          fontSize: 13.sp,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _blue.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          widget.topicTitle,
                          style: TextStyle(
                            color: _blue,
                            fontWeight: FontWeight.w800,
                            fontSize: 10.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.2.h),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 8,
                      backgroundColor: _navy.withValues(alpha: 0.08),
                      valueColor: const AlwaysStoppedAnimation<Color>(_blue),
                    ),
                  ),
                  SizedBox(height: 3.h),

                  // Question card
                  FadeIn(
                    key: ValueKey(currentQuestion.id),
                    duration: const Duration(milliseconds: 400),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(5.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: _navy.withValues(alpha: 0.08),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 14,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Text(
                        currentQuestion.prompt,
                        style: TextStyle(
                          color: _navy,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w800,
                          height: 1.35,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 2.5.h),

                  // Options
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: List.generate(
                          currentQuestion.options.length,
                          (index) => _buildOption(
                            index: index,
                            text: currentQuestion.options[index],
                            correctIndex: currentQuestion.correctOptionIndex,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Next button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: selectedIndex == null
                          ? null
                          : () => _handleNext(currentQuestion.id),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _navy,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: _navy.withValues(alpha: 0.25),
                        disabledForegroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 2.h),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        currentQuestionIndex < questions.length - 1
                            ? "Next Question"
                            : "Finish Quiz",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildOption({
    required int index,
    required String text,
    required int correctIndex,
  }) {
    final bool isSelected = selectedIndex == index;
    final bool isCorrect = index == correctIndex;
    final bool answered = selectedIndex != null;

    Color borderColor = _navy.withValues(alpha: 0.12);
    Color fillColor = Colors.white;
    Color radioColor = _navy.withValues(alpha: 0.3);

    if (answered) {
      if (isSelected) {
        borderColor = isCorrect ? AppColors.green : AppColors.red;
        fillColor = borderColor.withValues(alpha: 0.06);
        radioColor = borderColor;
      } else if (isCorrect) {
        borderColor = AppColors.green;
        fillColor = borderColor.withValues(alpha: 0.06);
        radioColor = borderColor;
      }
    }

    return Padding(
      padding: EdgeInsets.only(bottom: 1.5.h),
      child: InkWell(
        onTap: () => _selectOption(index),
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          decoration: BoxDecoration(
            color: fillColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: borderColor,
              width: (isSelected || (answered && isCorrect)) ? 2 : 1.2,
            ),
          ),
          child: Row(
            children: [
              // Letter badge
              Container(
                width: 34,
                height: 34,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: radioColor.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  String.fromCharCode(65 + index),
                  style: TextStyle(
                    color: radioColor,
                    fontWeight: FontWeight.w800,
                    fontSize: 13.sp,
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(
                    color: _navy,
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                    fontSize: 13.sp,
                  ),
                ),
              ),
              // Radio / status
              if (answered && (isSelected || isCorrect))
                Icon(
                  isCorrect ? Icons.check_circle_rounded : Icons.cancel_rounded,
                  color: radioColor,
                  size: 22,
                )
              else
                Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: radioColor, width: 2),
                    color: isSelected ? radioColor : Colors.transparent,
                  ),
                  child: isSelected
                      ? const Icon(Icons.circle, size: 8, color: Colors.white)
                      : null,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompletion(
    BuildContext context,
    ThemeData theme,
    AppLocalizations t,
  ) {
    return Center(
      child: Container(
        margin: EdgeInsets.all(6.w),
        padding: EdgeInsets.all(6.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: _navy.withValues(alpha: 0.08)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
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
                size: 56.sp,
                color: const Color(0xFFFFB300),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              t.translate('quiz_completed'),
              style: TextStyle(
                fontWeight: FontWeight.w900,
                color: _navy,
                fontSize: 20.sp,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Great job! You finished all questions.',
              textAlign: TextAlign.center,
              style: TextStyle(color: _navy.withValues(alpha: 0.6)),
            ),
            SizedBox(height: 1.5.h),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: _blue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                widget.topicTitle,
                style: const TextStyle(
                  color: _blue,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            SizedBox(height: 3.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _navy,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  elevation: 0,
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
}
