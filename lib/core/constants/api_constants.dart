class ApiConstants {
  ApiConstants._();

  // 🌐 BASE URL
  static const String baseUrl = 'http://52.35.230.229:3006';
  static const String aiChathost = 'http://52.35.230.229:3004';

  // 📌 ENDPOINTS
  static const String courses = '/api/courses';

  static const String aiChat = "$aiChathost/api/chat";

  // 🧠 QUIZ API
  static const String quizTopics = '$baseUrl/api/quizzes/topics';
  static const String getAllQuestions =
      '$baseUrl/api/quizzes/topics/getAllQuestions';
  static const String quizAttempts = '$baseUrl/api/quizzes/attempts';

  // 🔑 AUTH API
  static const String auth = '$baseUrl/api/auth';
  static const String verifyOtp = '$baseUrl/api/auth/verify-otp';
  static const String dashboard = '$baseUrl/api/dashboard';

  // ⏱ TIMEOUTS
  static const int connectTimeout = 15000;
  static const int receiveTimeout = 15000;
}
