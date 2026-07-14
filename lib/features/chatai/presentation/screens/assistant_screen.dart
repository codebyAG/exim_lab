import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:exim_lab/core/services/analytics_service.dart';
import 'package:exim_lab/features/chatai/data/models/assistant_models.dart';
import 'package:exim_lab/features/chatai/presentation/providers/assistant_provider.dart';
import 'package:exim_lab/features/chatai/presentation/screens/assistant_history_screen.dart';

/// Import/Export AI Assistant — ChatGPT-style new chat with starter chips,
/// threaded conversation, and WhatsApp-style history.
class AssistantScreen extends StatelessWidget {
  const AssistantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      // Always opens on a fresh "New chat" (per spec).
      create: (_) => AssistantProvider()..init(),
      child: const _AssistantView(),
    );
  }
}

class _AssistantView extends StatefulWidget {
  const _AssistantView();

  @override
  State<_AssistantView> createState() => _AssistantViewState();
}

class _AssistantViewState extends State<_AssistantView> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scroll = ScrollController();

  static const int _maxLen = 4000;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AnalyticsService>().logAiChatView();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _send(String text) async {
    final provider = context.read<AssistantProvider>();
    if (text.trim().isEmpty || provider.sending) return;

    _controller.clear();
    context.read<AnalyticsService>().logAiChatMessageSent();

    final error = await provider.send(text);
    _scrollToBottom();

    if (error != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error),
          action: provider.lastFailedText != null
              ? SnackBarAction(
                  label: 'Retry',
                  onPressed: () => _send(provider.lastFailedText!),
                )
              : null,
        ),
      );
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(
          _scroll.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _openHistory() {
    final provider = context.read<AssistantProvider>();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider.value(
          value: provider,
          child: const AssistantHistoryScreen(),
        ),
      ),
    ).then((_) => _scrollToBottom());
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final provider = context.watch<AssistantProvider>();

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        backgroundColor: cs.surface,
        elevation: 0,
        titleSpacing: 0,
        title: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: cs.primary.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.smart_toy_rounded, color: cs.primary, size: 20),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  provider.isNewChat ? 'New chat' : 'AI Assistant',
                  style: TextStyle(
                    color: cs.onSurface,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
                Text(
                  'Import Export Expert',
                  style: TextStyle(
                    color: cs.onSurface.withValues(alpha: 0.5),
                    fontWeight: FontWeight.w500,
                    fontSize: 11.5,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          // "New chat" — only while inside a thread
          if (!provider.isNewChat)
            IconButton(
              tooltip: 'New chat',
              icon: Icon(Icons.edit_square, color: cs.primary, size: 22),
              onPressed: provider.startNewChat,
            ),
          // "Old chats" — only if history exists
          if (provider.hasOldChats)
            IconButton(
              tooltip: 'Old chats',
              icon: Icon(Icons.history_rounded, color: cs.onSurface, size: 24),
              onPressed: _openHistory,
            ),
          const SizedBox(width: 4),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: provider.loadingThread
                ? Center(child: CircularProgressIndicator(color: cs.primary))
                : provider.isNewChat && !provider.sending
                    ? _StartersView(onTap: _send)
                    : _MessagesList(
                        scroll: _scroll,
                        messages: provider.messages,
                        typing: provider.sending,
                      ),
          ),

          // ── INPUT BAR ──
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: cs.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      maxLength: _maxLen,
                      minLines: 1,
                      maxLines: 4,
                      textInputAction: TextInputAction.send,
                      decoration: InputDecoration(
                        hintText: 'Ask about import–export…',
                        counterText: '',
                        filled: true,
                        fillColor: cs.surfaceContainerHighest,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onSubmitted: _send,
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Premium circular send button (spinner while sending)
                  InkWell(
                    borderRadius: BorderRadius.circular(26),
                    onTap: provider.sending
                        ? null
                        : () => _send(_controller.text),
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            cs.primary,
                            cs.primary.withValues(alpha: 0.75),
                          ],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: cs.primary.withValues(alpha: 0.35),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: provider.sending
                          ? const Padding(
                              padding: EdgeInsets.all(13),
                              child: CircularProgressIndicator(
                                strokeWidth: 2.2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(
                              Icons.send_rounded,
                              color: Colors.white,
                              size: 22,
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// New-chat view: greeting + starter chips
// ─────────────────────────────────────────────────────────────
class _StartersView extends StatelessWidget {
  final void Function(String) onTap;
  const _StartersView({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final provider = context.watch<AssistantProvider>();

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 16),
          // Gradient robot avatar with glow
          Center(
            child: Container(
              width: 84,
              height: 84,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [cs.primary, cs.primary.withValues(alpha: 0.7)],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: cs.primary.withValues(alpha: 0.3),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(
                Icons.smart_toy_rounded,
                size: 42,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            'How can I help you today?',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: cs.onSurface,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Ask anything about import–export business',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: cs.onSurface.withValues(alpha: 0.55),
              fontSize: 13.5,
            ),
          ),
          const SizedBox(height: 28),
          if (provider.loadingStarters)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: CircularProgressIndicator(color: cs.primary),
              ),
            )
          else
            ...provider.starters.map(
              (s) => _StarterChip(starter: s, onTap: onTap),
            ),
        ],
      ),
    );
  }
}

class _StarterChip extends StatelessWidget {
  final AssistantStarter starter;
  final void Function(String) onTap;
  const _StarterChip({required this.starter, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => onTap(starter.text),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: cs.primary.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: cs.primary.withValues(alpha: 0.2)),
          ),
          child: Row(
            children: [
              Icon(
                Icons.chat_bubble_outline_rounded,
                size: 18,
                color: cs.primary,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  starter.text,
                  style: TextStyle(
                    color: cs.onSurface,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    height: 1.3,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 13,
                color: cs.onSurface.withValues(alpha: 0.35),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Thread view: bubbles + typing indicator
// ─────────────────────────────────────────────────────────────
class _MessagesList extends StatelessWidget {
  final ScrollController scroll;
  final List<AssistantMessage> messages;
  final bool typing;

  const _MessagesList({
    required this.scroll,
    required this.messages,
    required this.typing,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return ListView.builder(
      controller: scroll,
      padding: const EdgeInsets.all(16),
      itemCount: messages.length + (typing ? 1 : 0),
      itemBuilder: (context, index) {
        if (typing && index == messages.length) {
          return Align(
            alignment: Alignment.centerLeft,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 6),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: cs.outline.withValues(alpha: 0.4)),
              ),
              child: Text(
                'Typing…',
                style: TextStyle(
                  fontSize: 13,
                  color: cs.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ),
          );
        }
        return _Bubble(message: messages[index]);
      },
    );
  }
}

class _Bubble extends StatelessWidget {
  final AssistantMessage message;
  const _Bubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isUser = message.isUser;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(14),
        constraints: const BoxConstraints(maxWidth: 320),
        decoration: BoxDecoration(
          color: isUser ? null : Colors.white,
          gradient: isUser
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [cs.primary, cs.primary.withValues(alpha: 0.8)],
                )
              : null,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(isUser ? 18 : 4),
            bottomRight: Radius.circular(isUser ? 4 : 18),
          ),
          border: isUser
              ? null
              : Border.all(color: cs.outline.withValues(alpha: 0.4)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Text(
          message.content,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: isUser ? cs.onPrimary : cs.onSurface,
            height: 1.45,
          ),
        ),
      ),
    );
  }
}
