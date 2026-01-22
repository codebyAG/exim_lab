import 'package:exim_lab/features/quiz/presentation/screens/quiz_question_screen.dart';
import 'package:exim_lab/features/quiz/presentation/states/quiz_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QuizTopicsScreen extends StatefulWidget {
  const QuizTopicsScreen({super.key});

  @override
  State<QuizTopicsScreen> createState() => _QuizTopicsScreenState();
}

class _QuizTopicsScreenState extends State<QuizTopicsScreen> {
  @override
  void initState() {
    super.initState();
    // TODO: Replace with actual user ID from auth provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<QuizProvider>().fetchTopics("64f0cccc3333333333333333");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quizzes'),
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

          if (provider.topics.isEmpty) {
            return const Center(child: Text("No quizzes available"));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: provider.topics.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final topic = provider.topics[index];
              return Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  title: Text(
                    topic.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(topic.description),
                      const SizedBox(height: 8),
                    ],
                  ),
                  trailing: ElevatedButton(
                    onPressed: () {
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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                    ),
                    child: Text(topic.hasAttempted ? "Resume" : "Start"),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
