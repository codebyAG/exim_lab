class ApiConstants {
  ApiConstants._();

  // 🌐 BASE URL
  static const String baseUrl = 'http://52.35.230.229:3006';
  static const String aiChathost = 'http://52.35.230.229:3004';

  // 📌 ENDPOINTS
  static const String courses = '/api/courses';
  static const String myCourses = '/api/courses/my';

  static const String aiChat = "$aiChathost/api/chat";

  // 🧠 QUIZ API
  static const String quizTopics = '$baseUrl/api/quizzes/topics';
  static const String getAllQuestions =
      '$baseUrl/api/quizzes/topics/getAllQuestions';
  static const String quizAttempts = '$baseUrl/api/quizzes/attempts';

  // 🔑 AUTH API
  static const String auth = '$baseUrl/api/auth';
  static const String verifyOtp = '$baseUrl/api/auth/verify-otp';
  static const String userProfile = '$baseUrl/api/user/profile';
  static const String dashboard = '$baseUrl/api/dashboard';
  static const String dashboardSections = '$baseUrl/api/dashboard/sections';
  static const String dashboardBanners = '$baseUrl/api/dashboard/banners';
  static const String dashboardPopular =
      '$baseUrl/api/dashboard/courses/popular';
  static const String dashboardRecommended =
      '$baseUrl/api/dashboard/courses/recommended';
  static const String dashboardContinue = '$baseUrl/api/dashboard/continue';
  static const String dashboardFreeVideos = '$baseUrl/api/dashboard/free-videos';
  static const String dashboardShorts = '$baseUrl/api/dashboard/shorts';
  static const String exchangeRates = '$baseUrl/api/dashboard/exchange-rates';
  static const String news = '$baseUrl/api/news';
  static const String notifications = '$baseUrl/api/notifications';
  static const String appModules = '$baseUrl/api/app-modules';
  static const String shortVideos = '$baseUrl/api/short-videos';
  static const String logAnalytics = '$baseUrl/api/analytics/track';
  static const String logInstall = '$baseUrl/api/analytics/log-install';
  static const String checkMembership = '$baseUrl/api/subscriptions/me/status';

  // 👤 FOUNDER API
  static const String founder = '$baseUrl/api/founder';

  // 🗺️ JOURNEY API
  static const String journeyConfig = '$baseUrl/api/journey/config';
  static const String journeyProgress = '$baseUrl/api/journey/progress';

  // 💬 COMMUNITY CHAT API
  static const String chatRooms = '$baseUrl/api/chat/rooms';
  static String chatMessages(dynamic roomId, {String? cursor, int limit = 50}) {
    String url = '$baseUrl/api/chat/rooms/$roomId/messages?limit=$limit';
    if (cursor != null) url += '&cursor=$cursor';
    return url;
  }
  static String chatSendMessage(dynamic roomId) => '$baseUrl/api/chat/rooms/$roomId/messages';

  // ⏱ TIMEOUTS
  static const int connectTimeout = 15000;
  static const int receiveTimeout = 15000;
}
