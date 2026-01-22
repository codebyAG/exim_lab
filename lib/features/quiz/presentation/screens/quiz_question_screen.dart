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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.topicTitle),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Consumer<QuizProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
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
                  const Icon(Icons.check_circle, size: 64, color: Colors.green),
                  const SizedBox(height: 16),
                  const Text(
                    "Quiz Completed!",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Back to Topics"),
                  ),
                ],
              ),
            );
          }

          final currentQuestion = questions[attempt.currentQuestionIndex];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                LinearProgressIndicator(
                  value: (attempt.currentQuestionIndex + 1) / questions.length,
                  color: Theme.of(context).colorScheme.primary,
                  backgroundColor: Colors.grey[200],
                ),
                const SizedBox(height: 20),
                Text(
                  "Question ${attempt.currentQuestionIndex + 1}/${questions.length}",
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
                const SizedBox(height: 12),
                Text(
                  currentQuestion.prompt,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 32),
                ...List.generate(currentQuestion.options.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        side: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      onPressed: () {
                        provider.submitAnswer(currentQuestion.id, index);
                      },
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          currentQuestion.options[index],
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 16,
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
    );
  }
}
