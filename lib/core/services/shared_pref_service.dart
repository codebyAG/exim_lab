import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:exim_lab/features/login/data/models/user_model.dart';
import 'dart:developer';

class SharedPrefService {
  static const String _userKey = 'user_data';

  Future<void> saveUser(UserModel user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = jsonEncode(user.toJson());
      await prefs.setString(_userKey, userJson);
      log("✅ User data saved to SharedPreferences");
    } catch (e) {
      log("❌ Error saving user data: $e");
    }
  }

  Future<UserModel?> getUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userString = prefs.getString(_userKey);
      if (userString != null) {
        log("✅ User data found in SharedPreferences");
        return UserModel.fromJson(jsonDecode(userString));
      }
    } catch (e) {
      log("❌ Error getting user data: $e");
    }
    return null;
  }

  Future<void> clearUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_userKey);
      log("✅ User data cleared from SharedPreferences");
    } catch (e) {
      log("❌ Error clearing user data: $e");
    }
  }
}
