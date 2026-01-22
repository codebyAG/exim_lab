import 'package:exim_lab/features/quiz/presentation/states/quiz_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    // TODO: Get actual user ID
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<QuizProvider>().startQuiz(
        "64f0cccc3333333333333333",
        widget.topicId,
      );
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
            colors: [cs.surfaceContainerHighest.withOpacity(0.5), cs.surface],
          ),
        ),
        child: Consumer<QuizProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading && provider.currentAttempt == null) {
              return const Center(child: CircularProgressIndicator());
            }

            if (provider.error != null) {
              return Center(child: Text("Error: ${provider.error}"));
            }

            final questions = provider.questions;
            final attempt = provider.currentAttempt;

            if (questions.isEmpty || attempt == null) {
              return const Center(child: Text("No questions found"));
            }

            if (attempt.isCompleted) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.check_circle,
                      size: 80,
                      color: Colors.green,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      "Quiz Completed!",
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: cs.onSurface,
                      ),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: cs.primary,
                        foregroundColor: cs.onPrimary,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text("Back to Topics"),
                    ),
                  ],
                ),
              );
            }

            final currentQuestion = questions[attempt.currentQuestionIndex];

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 100, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Progress Bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value:
                          (attempt.currentQuestionIndex + 1) / questions.length,
                      color: cs.primary,
                      backgroundColor: cs.surfaceContainerHighest,
                      minHeight: 8,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Question ${attempt.currentQuestionIndex + 1}/${questions.length}",
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),

                  // Question Card
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: cs.surface,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Text(
                      currentQuestion.prompt,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        height: 1.3,
                        color: cs.onSurface,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Options
                  ...List.generate(currentQuestion.options.length, (index) {
                    final bool isSelected = selectedIndex == index;
                    final bool isCorrect =
                        index == currentQuestion.correctOptionIndex;

                    Color tileColor = cs.surface;
                    Color borderColor = cs.outlineVariant.withOpacity(0.5);
                    Color dotColor = cs.surfaceContainerHighest.withOpacity(
                      0.5,
                    );
                    Color charColor = cs.primary;

                    if (selectedIndex != null) {
                      if (isSelected) {
                        tileColor = isCorrect
                            ? Colors.green.withOpacity(0.12)
                            : Colors.red.withOpacity(0.12);
                        borderColor = isCorrect ? Colors.green : Colors.red;
                        dotColor = isCorrect ? Colors.green : Colors.red;
                        charColor = Colors.white;
                      } else if (isCorrect) {
                        tileColor = Colors.green.withOpacity(0.05);
                        borderColor = Colors.green.withOpacity(0.5);
                      }
                    }

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => _handleOptionTap(
                            index,
                            currentQuestion.id,
                            currentQuestion.correctOptionIndex,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          child: Ink(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: tileColor,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: borderColor,
                                width: isSelected ? 2 : 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.02),
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
                                const SizedBox(width: 16),
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
