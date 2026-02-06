import 'package:exim_lab/features/notifications/data/models/notification_model.dart';
import 'package:exim_lab/features/notifications/presentation/providers/notifications_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationsProvider>().fetchNotifications(refresh: true);
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        context.read<NotificationsProvider>().fetchNotifications();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final provider = context.watch<NotificationsProvider>();
    final notifications = provider.notifications;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        title: const Text('Notifications'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              context.read<NotificationsProvider>().markAllAsRead();
            },
            icon: const Icon(Icons.done_all),
            tooltip: 'Mark all as read',
          ),
        ],
      ),
      body: Builder(
        builder: (context) {
          if (provider.isLoading && notifications.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (notifications.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_off_outlined,
                    size: 60,
                    color: cs.onSurface.withValues(alpha: 0.4),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No notifications yet',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: cs.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              await context.read<NotificationsProvider>().fetchNotifications(
                refresh: true,
              );
            },
            child: ListView.separated(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: notifications.length + (provider.hasMore ? 1 : 0),
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                if (index == notifications.length) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                final notification = notifications[index];
                return _NotificationTile(notification: notification);
              },
            ),
          );
        },
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final NotificationModel notification;
  const _NotificationTile({required this.notification});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isRead = notification.read;

    return GestureDetector(
      onTap: () {
        if (!isRead) {
          context.read<NotificationsProvider>().markAsRead(notification.id);
        }
        // Handle navigation if linkUrl exists
        // if (notification.linkUrl != null) ...
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isRead
              ? cs.surface
              : cs.primaryContainer.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isRead
                ? cs.outlineVariant.withValues(alpha: 0.4)
                : cs.primary.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ICON
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isRead
                    ? cs.surfaceContainerHighest
                    : cs.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isRead
                    ? Icons.notifications_outlined
                    : Icons.notifications_active,
                size: 20,
                color: isRead ? cs.onSurface : cs.primary,
              ),
            ),
            const SizedBox(width: 14),

            // CONTENT
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: isRead
                                ? FontWeight.w500
                                : FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        DateFormat(
                          'dd MMM, hh:mm a',
                        ).format(notification.createdAt),
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontSize: 10.sp,
                          color: cs.onSurface.withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    notification.body,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: cs.onSurface.withValues(alpha: 0.7),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),

            // DOT
            if (!isRead)
              Padding(
                padding: const EdgeInsets.only(left: 8, top: 20),
                child: CircleAvatar(radius: 4, backgroundColor: cs.primary),
              ),
          ],
        ),
      ),
    );
  }
}
