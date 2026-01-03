import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoLessonScreen extends StatefulWidget {
  const VideoLessonScreen({super.key});

  @override
  State<VideoLessonScreen> createState() => _VideoLessonScreenState();
}

class _VideoLessonScreenState extends State<VideoLessonScreen> {
  late YoutubePlayerController _controller;
  final TextEditingController _questionController = TextEditingController();

  final List<_Question> _questions = [
    _Question(
      user: 'Amit',
      question: 'Is IEC mandatory before starting export?',
      answer: 'Yes, IEC is mandatory for almost all export activities.',
    ),
    _Question(
      user: 'Rohit',
      question: 'Can an individual do export without a company?',
      answer: 'Yes, individuals can export as proprietors after registration.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(
        'https://www.youtube.com/watch?v=DeRSvxYpA00&list=PL1V2X_hj0A0JmXVTsXLaL5tJf1KWF65l9',
      )!,
      flags: const YoutubePlayerFlags(autoPlay: false, mute: false),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _questionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Introduction to Export Business',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
      ),
      body: YoutubePlayerBuilder(
        player: YoutubePlayer(
          controller: _controller,
          showVideoProgressIndicator: true,
          progressIndicatorColor: const Color(0xFFFF8A00),
        ),
        builder: (context, player) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔹 VIDEO
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: player,
                ),

                const SizedBox(height: 16),

                // 🔹 DESCRIPTION
                const Text(
                  'About this lesson',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),

                const SizedBox(height: 6),

                const Text(
                  'In this lesson, you will understand what export business is, '
                  'who can start exporting, and the overall flow of export activities.',
                  style: TextStyle(height: 1.5),
                ),

                const SizedBox(height: 24),

                // 🔹 WHAT YOU WILL LEARN
                const Text(
                  'What you will learn',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),

                const SizedBox(height: 12),

                const _Bullet(text: 'Meaning of export business'),
                const _Bullet(text: 'Who can start exporting'),
                const _Bullet(text: 'Basic export workflow'),

                const SizedBox(height: 32),

                // 🔹 ASK QUESTION
                const Text(
                  'Ask a question',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),

                const SizedBox(height: 8),

                TextField(
                  controller: _questionController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Type your question here...',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_questionController.text.isNotEmpty) {
                        setState(() {
                          _questions.insert(
                            0,
                            _Question(
                              user: 'You',
                              question: _questionController.text,
                            ),
                          );
                          _questionController.clear();
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF8A00),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Submit Question',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // 🔹 QUESTIONS LIST
                const Text(
                  'Questions & Answers',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),

                const SizedBox(height: 12),

                Column(
                  children: _questions
                      .map((q) => _QuestionCard(question: q))
                      .toList(),
                ),
              ],
            ),
          );
        },
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Icon(Icons.check_circle, size: 18, color: Color(0xFF22C55E)),
          const SizedBox(width: 10),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

// 🔹 QUESTION MODEL
class _Question {
  final String user;
  final String question;
  final String? answer;

  _Question({required this.user, required this.question, this.answer});
}

// 🔹 QUESTION CARD
class _QuestionCard extends StatelessWidget {
  final _Question question;

  const _QuestionCard({required this.question});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question.user,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          Text(question.question),
          if (question.answer != null) ...[
            const Divider(height: 20),
            const Text('Answer', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text(question.answer!),
          ],
        ],
      ),
    );
  }
}
