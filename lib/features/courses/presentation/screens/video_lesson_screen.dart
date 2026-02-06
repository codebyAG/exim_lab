import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:exim_lab/localization/app_localization.dart';

class VideoLessonScreen extends StatefulWidget {
  final String videoUrl;
  final String title;

  const VideoLessonScreen({
    super.key,
    required this.videoUrl,
    required this.title,
  });

  @override
  State<VideoLessonScreen> createState() => _VideoLessonScreenState();
}

class _VideoLessonScreenState extends State<VideoLessonScreen> {
  late YoutubePlayerController _controller;
  final TextEditingController _questionController = TextEditingController();

  final List<_Question> _questions = [];

  @override
  void initState() {
    super.initState();

    final videoId = YoutubePlayer.convertUrlToId(widget.videoUrl);

    _controller = YoutubePlayerController(
      initialVideoId: videoId ?? '',
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        enableCaption: true,
        isLive: false,
      ),
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
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: cs.surface,

      appBar: AppBar(
        backgroundColor: cs.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: cs.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(widget.title, style: theme.textTheme.titleMedium),
      ),

      body: YoutubePlayerBuilder(
        player: YoutubePlayer(
          controller: _controller,
          showVideoProgressIndicator: true,
          progressIndicatorColor: cs.primary,
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

                const SizedBox(height: 20),

                // 🔹 ABOUT
                _sectionTitle(context, t.translate('about_lesson')),
                const SizedBox(height: 8),
                Text(
                  t.translate('lesson_description'),
                  style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
                ),

                const SizedBox(height: 24),

                // 🔹 WHAT YOU WILL LEARN
                _sectionTitle(context, t.translate('what_learn')),
                const SizedBox(height: 12),
                _Bullet(text: t.translate('learn_point_1')),
                _Bullet(text: t.translate('learn_point_2')),
                _Bullet(text: t.translate('learn_point_3')),

                const SizedBox(height: 28),

                // 🔹 ASK QUESTION
                _sectionTitle(context, t.translate('ask_question')),
                const SizedBox(height: 10),

                TextField(
                  controller: _questionController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: t.translate('question_hint'),
                    filled: true,
                    fillColor: cs.surfaceContainerHighest,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _submitQuestion,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: cs.primary,
                      foregroundColor: cs.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      t.translate('submit_question'),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                if (_questions.isNotEmpty) ...[
                  const SizedBox(height: 32),

                  _sectionTitle(context, t.translate('questions_answers')),
                  const SizedBox(height: 12),

                  Column(
                    children: _questions
                        .map((q) => _QuestionCard(question: q))
                        .toList(),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  void _submitQuestion() {
    if (_questionController.text.trim().isEmpty) return;

    // Note: 'You' could also be localized if needed, e.g. t.translate('you_user')
    // But since it is inside a method, we need access to context or pass it.
    // Ideally user name comes from profile.
    final t = AppLocalizations.of(context)!;

    setState(() {
      _questions.insert(
        0,
        _Question(
          user: t.translate('you_user'),
          question: _questionController.text.trim(),
        ),
      );
      _questionController.clear();
    });
  }

  Widget _sectionTitle(BuildContext context, String text) {
    final theme = Theme.of(context);
    return Text(
      text,
      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
    );
  }
}

// ================= BULLET =================

class _Bullet extends StatelessWidget {
  final String text;

  const _Bullet({required this.text});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(Icons.check_circle, size: 18, color: cs.secondary),
          const SizedBox(width: 10),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

// ================= QUESTION MODEL =================

class _Question {
  final String user;
  final String question;

  _Question({required this.user, required this.question});
}

// ================= QUESTION CARD =================

class _QuestionCard extends StatelessWidget {
  final _Question question;

  const _QuestionCard({required this.question});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.black.withValues(alpha: 0.05)
                : Colors.black.withValues(alpha: 0.25),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
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
        ],
      ),
    );
  }
}
