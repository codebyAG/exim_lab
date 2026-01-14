class ApiConstants {
  ApiConstants._();

  // 🌐 BASE URL
  static const String baseUrl = 'http://52.35.230.229:3002';
  static const String aiChathost = 'http://52.35.230.229:3004';

  // 📌 ENDPOINTS
  static const String courses = '/api/courses';

  static const String aiChat = "$aiChathost/api/chat";

  static const String freeVideos = '/api/free-videos';

  // ⏱ TIMEOUTS
  static const int connectTimeout = 15000;
  static const int receiveTimeout = 15000;
}
