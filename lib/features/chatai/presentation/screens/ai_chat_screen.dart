import 'package:exim_lab/features/chatai/data/datasources/ai_chat_data_remote.dart';
import 'package:exim_lab/features/chatai/domain/ai_chat_repository.dart';
import 'package:exim_lab/localization/app_localization.dart';
import 'package:flutter/material.dart';

class AiChatScreen extends StatefulWidget {
  const AiChatScreen({super.key});

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<_Message> _messages = [];
  bool _isTyping = false;

  late final AiChatRepository _repo;

  @override
  void initState() {
    super.initState();

    _repo = AiChatRepository(AiChatRemote());

    _messages.add(
      _Message(
        text:
            'Hi 👋 I’m Exim AI.\nAsk me anything about import–export, prices, documents or courses.',
        isUser: false,
      ),
    );
  }

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.insert(0, _Message(text: text, isUser: true));
      _controller.clear();
      _isTyping = true;
    });

    try {
      final reply = await _repo.askAi(text);

      setState(() {
        _messages.insert(0, _Message(text: reply, isUser: false));
        _isTyping = false;
      });
    } catch (e) {
      setState(() {
        _messages.insert(
          0,
          _Message(
            text: '⚠️ Something went wrong. Please try again.',
            isUser: false,
          ),
        );
        _isTyping = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        backgroundColor: cs.surface,
        elevation: 0,
        title: Text(
          'Exim AI',
          style: TextStyle(color: cs.onSurface, fontWeight: FontWeight.w600),
        ),
      ),
      body: Column(
        children: [
          // 🔹 CHAT LIST (BOTTOM → TOP)
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              reverse: true,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                // 🔹 Typing indicator always on top (which is index 0 in reverse)
                if (_isTyping && index == 0) {
                  return const _TypingIndicator();
                }

                // 🔹 Correct message index mapping
                final messageIndex = _isTyping ? index - 1 : index;

                // With reverse: true, index 0 is at bottom (newest).
                // Our internal list has newest at 0. So we can just use index.
                final message = _messages[messageIndex];

                return _ChatBubble(message: message);
              },
            ),
          ),

          // 🔹 INPUT BAR
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: cs.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: t.translate('chat_hint'),
                      filled: true,
                      fillColor: cs.surfaceContainerHighest,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onSubmitted: _sendMessage,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () => _sendMessage(_controller.text),
                  icon: Icon(Icons.send, color: cs.primary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ================= MODELS =================

class _Message {
  final String text;
  final bool isUser;

  _Message({required this.text, required this.isUser});
}

// ================= UI =================

class _ChatBubble extends StatelessWidget {
  final _Message message;

  const _ChatBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(14),
        constraints: const BoxConstraints(maxWidth: 320),
        decoration: BoxDecoration(
          color: message.isUser ? cs.primary : cs.surface,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Text(
          message.text,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: message.isUser ? cs.onPrimary : cs.onSurface,
            height: 1.4,
          ),
        ),
      ),
    );
  }
}

class _TypingIndicator extends StatelessWidget {
  const _TypingIndicator();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Text(
          'Exim AI is typing...',
          style: TextStyle(
            fontSize: 13,
            color: cs.onSurface.withValues(alpha: 0.6),
          ),
        ),
      ),
    );
  }
}
