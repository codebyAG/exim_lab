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

  void _sendMessage() async {
    if (_controller.text.trim().isEmpty) return;

    final userMessage = _controller.text.trim();

    setState(() {
      _messages.add(_Message(text: userMessage, isUser: true));
      _controller.clear();
      _isTyping = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _messages.add(
        _Message(
          text: _getAiReply(userMessage),
          isUser: false,
        ),
      );
      _isTyping = false;
    });
  }

  String _getAiReply(String question) {
    final q = question.toLowerCase();

    if (q.contains('iec')) {
      return 'IEC (Import Export Code) is mandatory for anyone starting import or export business in India.';
    }
    if (q.contains('gst')) {
      return 'GST registration is required if you are exporting goods or services under Indian law.';
    }
    if (q.contains('document')) {
      return 'Key export documents include Invoice, Packing List, Bill of Lading, and Shipping Bill.';
    }
    if (q.contains('course')) {
      return 'You can explore beginner to advanced import–export courses under the Courses section.';
    }

    return 'That’s a great question! 📘\nPlease explore our courses or resources for detailed guidance.';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Exim AI',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          // 🔹 CHAT MESSAGES
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

          // 🔹 INPUT BAR
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Ask something...',
                      filled: true,
                      fillColor: const Color(0xFFF3F4F6),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _sendMessage,
                  icon: const Icon(Icons.send, color: Color(0xFFFF8A00)),
                ),
              ],
            ),
          ),
        ],
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
    return Align(
      alignment:
          message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        constraints: const BoxConstraints(maxWidth: 280),
        decoration: BoxDecoration(
          color: message.isUser
              ? const Color(0xFFFF8A00)
              : Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          message.text,
          style: TextStyle(
            color: message.isUser ? Colors.white : Colors.black,
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
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Text(
          'Exim AI is typing...',
          style: TextStyle(fontSize: 13, color: Colors.black54),
        ),
      ),
    );
  }
}
