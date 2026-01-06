import 'package:exim_lab/localization/app_localization.dart';
import 'package:flutter/material.dart';

class AiChatScreen extends StatefulWidget {
  const AiChatScreen({super.key});

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<_Message> _messages = [];
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _messages.add(
      _Message(
        text:
            'Hi 👋 I’m Exim AI.\nAsk me anything about import–export, documents, or courses.',
        isUser: false,
      ),
    );
  }

  void _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add(_Message(text: text, isUser: true));
      _controller.clear();
      _isTyping = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _messages.add(_Message(text: _getAiReply(text), isUser: false));
      _isTyping = false;
    });
  }

  String _getAiReply(String question) {
    final q = question.toLowerCase();

    if (q.contains('iec')) {
      return 'IEC (Import Export Code) is mandatory to start import or export business in India.';
    }
    if (q.contains('gst')) {
      return 'GST registration is required for exporting goods or services.';
    }
    if (q.contains('document')) {
      return 'Key documents include Invoice, Packing List, Bill of Lading and Shipping Bill.';
    }
    if (q.contains('course')) {
      return 'Start with “Import–Export Basics” before moving to advanced trade strategies.';
    }

    return 'That’s a great question 📘\nPlease explore our courses and resources for more clarity.';
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

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
          // 🔹 CHAT LIST
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (_isTyping && index == _messages.length) {
                  return const _TypingIndicator();
                }
                return _ChatBubble(message: _messages[index]);
              },
            ),
          ),

          // 🔹 SUGGESTED QUESTION CHIPS
          if (_messages.length <= 1)
            Container(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 6),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _suggestedChip(context, 'What is IEC?'),
                    _suggestedChip(context, 'GST for export?'),
                    _suggestedChip(context, 'Required documents'),
                    _suggestedChip(context, 'Best course to start'),
                  ],
                ),
              ),
            ),

          // 🔹 INPUT BAR
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: cs.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
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
                    style: TextStyle(color: cs.onSurface),
                    decoration: InputDecoration(
                      hintText: t.translate('chat_hint'),
                      hintStyle: TextStyle(
                        color: cs.onSurface.withOpacity(0.5),
                      ),
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

  Widget _suggestedChip(BuildContext context, String text) {
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: () => _sendMessage(text),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: cs.primary.withOpacity(0.12),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: cs.primary,
            ),
          ),
        ),
      ),
    );
  }
}

// 🔹 MESSAGE MODEL
class _Message {
  final String text;
  final bool isUser;

  _Message({required this.text, required this.isUser});
}

// 🔹 CHAT BUBBLE
class _ChatBubble extends StatelessWidget {
  final _Message message;

  const _ChatBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        constraints: const BoxConstraints(maxWidth: 300),
        decoration: BoxDecoration(
          color: message.isUser ? cs.primary : cs.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          message.text,
          style: TextStyle(
            color: message.isUser ? cs.onPrimary : cs.onSurface,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

// 🔹 TYPING INDICATOR
class _TypingIndicator extends StatelessWidget {
  const _TypingIndicator();

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          t.translate('ai_typing'),
          style: TextStyle(fontSize: 13, color: cs.onSurface.withOpacity(0.6)),
        ),
      ),
    );
  }
}
