import 'package:shared_preferences/shared_preferences.dart';

class CourseProgressHelper {
  static const String _keyPrefix = 'course_progress_';

  /// Save completed lessons count
  static Future<void> saveProgress(
    String courseId,
    int completed,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('$_keyPrefix$courseId', completed);
  }

  /// Get completed lessons count
  static Future<int> getProgress(String courseId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('$_keyPrefix$courseId') ?? 0;
  }
}
