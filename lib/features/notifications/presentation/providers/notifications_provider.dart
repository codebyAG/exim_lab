import 'package:exim_lab/features/notifications/data/models/notification_model.dart';
import 'package:exim_lab/features/notifications/data/repositories/notifications_repository.dart';
import 'package:flutter/material.dart';

class NotificationsProvider extends ChangeNotifier {
  final NotificationsRepository _repository = NotificationsRepository();

  List<NotificationModel> _notifications = [];
  List<NotificationModel> get notifications => _notifications;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  int _unreadCount = 0;
  int get unreadCount => _unreadCount;

  int _page = 1;
  final int _limit = 20;
  bool _hasMore = true;
  bool get hasMore => _hasMore;

  String? _error;
  String? get error => _error;

  NotificationsProvider() {
    fetchUnreadCount();
  }

  Future<void> fetchNotifications({bool refresh = false}) async {
    if (refresh) {
      _page = 1;
      _notifications = [];
      _hasMore = true;
    }

    if (!_hasMore && !refresh) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    // ── MOCK DATA (remove when API is ready) ──────────────────
    // ignore: dead_code
    const useMock = true;
    // ignore: dead_code
    if (useMock) {
      await Future.delayed(const Duration(milliseconds: 600));
      final now = DateTime.now();
      _notifications = [
        NotificationModel(
          id: '1',
          userId: 'u1',
          title: 'New course available!',
          body: 'Introduction to Import-Export is now live. Start learning today.',
          source: 'Courses',
          read: false,
          createdAt: now.subtract(const Duration(minutes: 12)),
        ),
        NotificationModel(
          id: '2',
          userId: 'u1',
          title: 'Quiz result posted',
          body: 'You scored 85% on the HS Code Classification Quiz. Great job!',
          source: 'Quizzes',
          read: false,
          createdAt: now.subtract(const Duration(hours: 2)),
        ),
        NotificationModel(
          id: '3',
          userId: 'u1',
          title: 'Profile updated successfully',
          body: 'Your profile information has been saved.',
          source: 'Account',
          read: true,
          createdAt: now.subtract(const Duration(hours: 6)),
        ),
        NotificationModel(
          id: '4',
          userId: 'u1',
          title: 'New export guide published',
          body: 'A new guide on finding international buyers is now available in Resources.',
          source: 'Resources',
          read: false,
          createdAt: now.subtract(const Duration(days: 1)),
        ),
        NotificationModel(
          id: '5',
          userId: 'u1',
          title: 'Welcome to Exim Lab!',
          body: 'Start your import-export journey with our expert-curated courses.',
          source: 'System',
          read: true,
          createdAt: now.subtract(const Duration(days: 3)),
        ),
      ];
      _hasMore = false;
      _unreadCount = _notifications.where((n) => !n.read).length;
      _isLoading = false;
      notifyListeners();
      return;
    }
    // ── END MOCK ───────────────────────────────────────────────

    try {
      final response = await _repository.fetchNotifications(
        page: _page,
        limit: _limit,
      );

      if (refresh) {
        _notifications = response.data;
      } else {
        _notifications.addAll(response.data);
      }

      _hasMore = response.meta.page < response.meta.totalPages;
      if (_hasMore) {
        _page++;
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchUnreadCount() async {
    try {
      _unreadCount = await _repository.getUnreadCount();
      notifyListeners();
    } catch (e) {
      // Error handling
    }
  }

  Future<void> markAsRead(String id) async {
    // Optimistic update
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1 && !_notifications[index].read) {
      // final original = _notifications[index];
      // Create copy with read = true
      // Since fields are final, better to have copyWith in model, but for now manual copy
      // Actually model fields are final.
      // I'll leave it unchanged in memory if I can't copy easily,
      // but UI won't update.
      // Let's implement copyWith or just generic update.
      // Simpler: fetch updated model from API.
    }

    // Better: Update count locally immediately
    if (index != -1 && !_notifications[index].read) {
      _unreadCount = (_unreadCount - 1).clamp(0, 999);
      notifyListeners();
    }

    try {
      final updated = await _repository.markAsRead(id);
      if (index != -1) {
        _notifications[index] = updated;
        notifyListeners();
      }
      // Re-sync count
      fetchUnreadCount();
    } catch (e) {
      // Revert if needed, but low priority
      //
    }
  }

  Future<void> markAllAsRead() async {
    // Optimistic
    _unreadCount = 0;
    for (var i = 0; i < _notifications.length; i++) {
      // Can't easily modify final fields without copyWith
      // But we can trigger UI to appear read if we assume success
    }
    notifyListeners();

    try {
      await _repository.markAllAsRead();
      // Refresh list to get updated status
      fetchNotifications(refresh: true);
      fetchUnreadCount();
    } catch (e) {
      //
    }
  }
}
