import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:exim_lab/features/chatai/data/models/assistant_models.dart';
import 'package:exim_lab/features/chatai/presentation/providers/assistant_provider.dart';

/// WhatsApp-style list of past assistant conversations.
/// Expects an [AssistantProvider] above it (passed via Provider.value).
class AssistantHistoryScreen extends StatefulWidget {
  const AssistantHistoryScreen({super.key});

  @override
  State<AssistantHistoryScreen> createState() => _AssistantHistoryScreenState();
}

class _AssistantHistoryScreenState extends State<AssistantHistoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AssistantProvider>().loadConversations();
    });
  }

  String _formatTime(DateTime? dt) {
    if (dt == null) return '';
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 1) return 'now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    if (diff.inDays < 7) return '${diff.inDays}d';
    return DateFormat('dd MMM').format(dt);
  }

  Future<void> _open(AssistantConversation c) async {
    final provider = context.read<AssistantProvider>();
    Navigator.pop(context); // back to the thread view
    final ok = await provider.openConversation(c.id);
    if (!ok) {
      // Thread failed to load — fall back to a clean new chat.
      provider.startNewChat();
    }
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
        title: Text(
          'Old chats',
          style: TextStyle(
            color: cs.onSurface,
            fontWeight: FontWeight.w800,
            fontSize: 17,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: cs.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: provider.loadingConversations
          ? Center(child: CircularProgressIndicator(color: cs.primary))
          : provider.conversations.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.forum_outlined,
                        size: 52,
                        color: cs.onSurfaceVariant.withValues(alpha: 0.4),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'No chats yet',
                        style: TextStyle(
                          color: cs.onSurfaceVariant,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  color: cs.primary,
                  onRefresh: () => provider.loadConversations(),
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    itemCount: provider.conversations.length,
                    separatorBuilder: (context, i) =>
                        const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final c = provider.conversations[index];
                      return InkWell(
                        borderRadius: BorderRadius.circular(14),
                        onTap: () => _open(c),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: cs.surface,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: cs.outlineVariant.withValues(alpha: 0.4),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.04),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: cs.primary.withValues(alpha: 0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.smart_toy_rounded,
                                  color: cs.primary,
                                  size: 22,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      c.title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: cs.onSurface,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14.5,
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      c.lastMessagePreview,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: cs.onSurface
                                            .withValues(alpha: 0.55),
                                        fontSize: 12.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _formatTime(c.lastMessageAt),
                                style: TextStyle(
                                  color:
                                      cs.onSurface.withValues(alpha: 0.45),
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
