import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';
import '../providers/chat_provider.dart';
import '../../data/models/chat_room_model.dart';
import '../../data/models/chat_message_model.dart';

class ChatRoomDetailsScreen extends StatefulWidget {
  final ChatRoom room;

  const ChatRoomDetailsScreen({super.key, required this.room});

  @override
  State<ChatRoomDetailsScreen> createState() => _ChatRoomDetailsScreenState();
}

class _ChatRoomDetailsScreenState extends State<ChatRoomDetailsScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<ChatProvider>();
      provider.fetchMessages(widget.room.id);
    });
  }

  void _onScroll() {
    // Trigger load more only when user reaches 95% of the scrollable area
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.95) {
      context.read<ChatProvider>().loadMoreMessages();
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: widget.room.color.withValues(alpha: 0.1),
              child: Icon(widget.room.icon, color: widget.room.color, size: 20),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.room.name,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<ChatProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading && provider.messages.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (provider.messages.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          size: 50.sp,
                          color: Colors.grey[400],
                        ),
                        SizedBox(height: 2.h),
                        const Text('No messages yet. Start the conversation!'),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  controller: _scrollController,
                  reverse: true,
                  padding: EdgeInsets.all(4.w),
                  itemCount:
                      provider.messages.length + (provider.hasMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == provider.messages.length) {
                      if (provider.isFetchingMore) {
                        return SizedBox(
                          height: 8.h, // Constant height to keep scroll intact
                          child: const Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xFF1E5FFF),
                              ),
                            ),
                          ),
                        );
                      } else if (provider.hasMore) {
                        // Match exactly the loader height
                        return SizedBox(height: 8.h);
                      } else if (provider.messages.isNotEmpty) {
                        return Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            vertical: 4.h,
                            horizontal: 10.w,
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.auto_awesome_rounded,
                                color: const Color(
                                  0xFF1E5FFF,
                                ).withValues(alpha: 0.3),
                                size: 35.sp,
                              ),
                              SizedBox(height: 1.5.h),
                              Text(
                                "Community Chat Started Here",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black.withValues(alpha: 0.5),
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              SizedBox(height: 0.5.h),
                              Text(
                                "This is the very beginning of this hub.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.grey.withValues(alpha: 0.5),
                                  fontSize: 9.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Container(
                                width: 40.w,
                                height: 1,
                                color: Colors.grey.withValues(alpha: 0.1),
                              ),
                            ],
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    }

                    final message = provider.messages[index];
                    return _buildMessageBubble(
                      message,
                      key: ValueKey(
                        "msg_${message.id}_${message.createdAt.millisecondsSinceEpoch}",
                      ),
                    );
                  },
                );
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message, {Key? key}) {
    return Padding(
      key: key,
      padding: EdgeInsets.only(bottom: 2.h),
      child: Column(
        crossAxisAlignment: message.isMe
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          if (!message.isMe)
            Padding(
              padding: EdgeInsets.only(left: 2.w, bottom: 0.5.h),
              child: Text(
                message.senderName,
                style: TextStyle(
                  fontSize: 9.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600],
                ),
              ),
            ),
          Row(
            mainAxisAlignment: message.isMe
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!message.isMe)
                CircleAvatar(
                  radius: 12,
                  backgroundImage: message.senderImageUrl.isNotEmpty
                      ? NetworkImage(message.senderImageUrl)
                      : null,
                  child: message.senderImageUrl.isEmpty
                      ? Icon(Icons.person, size: 12)
                      : null,
                ),
              SizedBox(width: 2.w),
              Flexible(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 4.w,
                    vertical: 1.5.h,
                  ),
                  decoration: BoxDecoration(
                    color: message.isMe
                        ? const Color(0xFF1E5FFF)
                        : Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(20),
                      topRight: const Radius.circular(20),
                      bottomLeft: Radius.circular(message.isMe ? 20 : 0),
                      bottomRight: Radius.circular(message.isMe ? 0 : 20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        message.message,
                        style: TextStyle(
                          color: message.isMe ? Colors.white : Colors.black87,
                          fontSize: 13.5.sp,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        DateFormat('hh:mm a').format(message.createdAt),
                        style: TextStyle(
                          color: message.isMe ? Colors.white70 : Colors.black38,
                          fontSize: 9.5.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 2.w),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TextField(
                  controller: _messageController,
                  decoration: const InputDecoration(
                    hintText: 'Type your message...',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            SizedBox(width: 3.w),
            Consumer<ChatProvider>(
              builder: (context, provider, child) {
                return GestureDetector(
                  onTap: provider.isSending
                      ? null
                      : () async {
                          final text = _messageController.text.trim();
                          if (text.isNotEmpty) {
                            // 🚀 Instant UI feedback
                            _messageController.clear();
                            _scrollToBottom();

                            final success = await provider.sendMessage(
                              widget.room.id,
                              text,
                            );
                            if (!success && provider.error != null) {
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(provider.error!),
                                  backgroundColor: const Color(0xFFC8151B),
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              );
                            }
                          }
                        },
                  child: Container(
                    padding: EdgeInsets.all(3.w),
                    decoration: const BoxDecoration(
                      color: Color(0xFF1E5FFF),
                      shape: BoxShape.circle,
                    ),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (child, animation) =>
                          ScaleTransition(scale: animation, child: child),
                      child: provider.isSending
                          ? SizedBox(
                              key: const ValueKey('loader'),
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Icon(
                              Icons.send_rounded,
                              color: Colors.white,
                              key: ValueKey('icon'),
                            ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
