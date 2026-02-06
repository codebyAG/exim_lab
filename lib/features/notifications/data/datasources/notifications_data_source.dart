import 'package:exim_lab/core/constants/api_constants.dart';
import 'package:exim_lab/core/functions/api_call.dart';
import 'package:exim_lab/features/notifications/data/models/notification_model.dart';

class NotificationsDataSource {
  Future<NotificationListResponse> fetchNotifications({
    int page = 1,
    int limit = 20,
  }) async {
    return await callApi(
      ApiConstants.notifications,
      queryParameters: {'page': page, 'limit': limit},
      parser: (json) => NotificationListResponse.fromJson(json),
      methodType: MethodType.get,
    );
  }

  Future<int> getUnreadCount() async {
    return await callApi(
      '${ApiConstants.notifications}/unread-count',
      parser: (json) => json['unreadCount'] as int? ?? 0,
      methodType: MethodType.get,
    );
  }

  Future<NotificationModel> markAsRead(String id) async {
    return await callApi(
      '${ApiConstants.notifications}/$id/read',
      parser: (json) => NotificationModel.fromJson(json),
      methodType: MethodType.patch,
      requestData: {}, // Empty body
    );
  }

  Future<void> markAllAsRead() async {
    await callApi(
      '${ApiConstants.notifications}/read-all',
      parser: (json) => json, // We don't need the return value
      methodType: MethodType.patch,
      requestData: {},
    );
  }
}
