import 'package:exim_lab/features/notifications/data/datasources/notifications_data_source.dart';
import 'package:exim_lab/features/notifications/data/models/notification_model.dart';

class NotificationsRepository {
  final NotificationsDataSource _dataSource = NotificationsDataSource();

  Future<NotificationListResponse> fetchNotifications({
    int page = 1,
    int limit = 20,
  }) async {
    return await _dataSource.fetchNotifications(page: page, limit: limit);
  }

  Future<int> getUnreadCount() async {
    return await _dataSource.getUnreadCount();
  }

  Future<NotificationModel> markAsRead(String id) async {
    return await _dataSource.markAsRead(id);
  }

  Future<void> markAllAsRead() async {
    await _dataSource.markAllAsRead();
  }
}
