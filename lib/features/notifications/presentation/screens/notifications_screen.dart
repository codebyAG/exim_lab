import 'package:animate_do/animate_do.dart';
import 'package:exim_lab/features/notifications/data/models/notification_model.dart';
import 'package:exim_lab/features/notifications/presentation/providers/notifications_provider.dart';
import 'package:exim_lab/localization/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:exim_lab/core/services/analytics_service.dart';
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
      context.read<AnalyticsService>().logEvent('notifications_view');
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
    final t = AppLocalizations.of(context);
    final provider = context.watch<NotificationsProvider>();
    final notifications = provider.notifications;

    return Scaffold(
      backgroundColor: cs.surfaceContainerLowest,
      appBar: AppBar(
        title: Text(t.translate('notifications')),
        centerTitle: true,
        backgroundColor: cs.surfaceContainerLowest,
        elevation: 0,
        scrolledUnderElevation: 0,
        actions: [
          if (notifications.isNotEmpty)
            TextButton(
              onPressed: () =>
                  context.read<NotificationsProvider>().markAllAsRead(),
              child: Text(
                t.translate('mark_all_read'),
                style: TextStyle(
                  color: cs.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
      body: Builder(
        builder: (context) {
          // LOADING
          if (provider.isLoading && notifications.isEmpty) {
            return Center(
              child: CircularProgressIndicator(color: cs.primary),
            );
          }

          // EMPTY STATE
          if (notifications.isEmpty) {
            return FadeIn(
              duration: const Duration(milliseconds: 500),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(28),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: cs.primary.withValues(alpha: 0.08),
                      ),
                      child: Icon(
                        Icons.notifications_off_outlined,
                        size: 52,
                        color: cs.primary.withValues(alpha: 0.6),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      t.translate('no_notifications'),
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 0.6.h),
                    Text(
                      t.translate('no_notifications_hint'),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          // LIST
          return RefreshIndicator(
            color: cs.primary,
            onRefresh: () async {
              await context
                  .read<NotificationsProvider>()
                  .fetchNotifications(refresh: true);
            },
            child: ListView.separated(
              controller: _scrollController,
              padding: EdgeInsets.fromLTRB(5.w, 1.5.h, 5.w, 2.h),
              itemCount: notifications.length + (provider.hasMore ? 1 : 0),
              separatorBuilder: (context, index) => SizedBox(height: 1.2.h),
              itemBuilder: (context, index) {
                if (index == notifications.length) {
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Center(
                      child: CircularProgressIndicator(color: cs.primary),
                    ),
                  );
                }

                final notification = notifications[index];
                return FadeInUp(
                  duration: const Duration(milliseconds: 400),
                  delay: Duration(
                      milliseconds: (index < 6 ? index : 5) * 60),
                  child: _NotificationTile(notification: notification),
                );
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

  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return DateFormat('dd MMM').format(dt);
  }

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
      },
      child: Container(
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border(
            left: BorderSide(
              color: isRead
                  ? Colors.transparent
                  : cs.primary,
              width: 3,
            ),
            top: BorderSide(
                color: cs.outlineVariant.withValues(alpha: 0.35)),
            right: BorderSide(
                color: cs.outlineVariant.withValues(alpha: 0.35)),
            bottom: BorderSide(
                color: cs.outlineVariant.withValues(alpha: 0.35)),
          ),
          boxShadow: [
            BoxShadow(
              color: cs.shadow.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ICON with unread dot overlay
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isRead
                          ? cs.surfaceContainerHighest
                          : cs.primary.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      isRead
                          ? Icons.notifications_outlined
                          : Icons.notifications_active_rounded,
                      size: 20,
                      color: isRead ? cs.onSurfaceVariant : cs.primary,
                    ),
                  ),
                  if (!isRead)
                    Positioned(
                      top: -2,
                      right: -2,
                      child: Container(
                        width: 9,
                        height: 9,
                        decoration: BoxDecoration(
                          color: cs.primary,
                          shape: BoxShape.circle,
                          border: Border.all(color: cs.surface, width: 1.5),
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(width: 12),

              // CONTENT
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // TITLE + TIME
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight:
                                  isRead ? FontWeight.w500 : FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _formatTime(notification.createdAt),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: cs.onSurface.withValues(alpha: 0.45),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 5),

                    // BODY
                    Text(
                      notification.body,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: cs.onSurface.withValues(alpha: 0.65),
                        height: 1.4,
                      ),
                    ),

                    // SOURCE CHIP
                    if (notification.source.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: cs.primary.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          notification.source,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: cs.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
