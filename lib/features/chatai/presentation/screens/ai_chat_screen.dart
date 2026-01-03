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
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Exim AI',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
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

          // 🔹 SUGGESTED QUESTION CHIPS (BOTTOM)
          if (_messages.length <= 1)
            Container(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 6),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _suggestedChip('What is IEC?', const Color(0xFFE0F2FE)),
                    _suggestedChip('GST for export?', const Color(0xFFDCFCE7)),
                    _suggestedChip(
                      'Required documents',
                      const Color(0xFFFFEDD5),
                    ),
                    _suggestedChip(
                      'Best course to start',
                      const Color(0xFFFCE7F3),
                    ),
                  ],
                ),
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
                      hintText: 'Ask something about import–export...',
                      filled: true,
                      fillColor: const Color(0xFFF3F4F6),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onSubmitted: (val) => _sendMessage(val),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () => _sendMessage(_controller.text),
                  icon: const Icon(Icons.send, color: Color(0xFFFF8A00)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _suggestedChip(String text, Color bgColor) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: () => _sendMessage(text),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            text,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
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
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        constraints: const BoxConstraints(maxWidth: 300),
        decoration: BoxDecoration(
          color: message.isUser ? const Color(0xFFFF8A00) : Colors.white,
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
