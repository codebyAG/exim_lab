import 'package:flutter/material.dart';
import 'package:exim_lab/features/login/data/data_sources/auth_data_source.dart';
import 'package:exim_lab/features/login/data/models/user_model.dart';
import 'package:exim_lab/core/services/shared_pref_service.dart';
import 'package:exim_lab/core/services/analytics_service.dart';
import 'package:exim_lab/core/constants/analytics_constants.dart';

class AuthProvider extends ChangeNotifier {
  final AuthDataSource _dataSource = AuthDataSource();
  final SharedPrefService _sharedPrefService = SharedPrefService();
  final AnalyticsService _analytics = AnalyticsService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  String? _otpMessage;
  String? get otpMessage => _otpMessage;

  String? _currentMobile;
  String? get currentMobile => _currentMobile;

  UserModel? _user;
  UserModel? get user => _user;

  AuthProvider() {
    _loadUser();
  }

  Future<void> _loadUser() async {
    _user = await _sharedPrefService.getUser();
    if (_user != null) {
      await _analytics.setUserId(_user!.id);
      _analytics.setUserMobile(_user!.mobile);
      await _analytics.setUserProperty(name: 'role', value: _user!.role);
      await _analytics.setUserProperty(
        name: AnalyticsConstants.phoneNumber,
        value: _user!.mobile,
      );
    }
    notifyListeners();
  }

  Future<bool> checkLoginStatus() async {
    final token = await _sharedPrefService.getToken();
    if (token != null && token.isNotEmpty) {
      if (_user == null) {
        await _loadUser();
      }
      return true;
    }
    return false;
  }

  Future<bool> sendOtp(String mobile) async {
    _isLoading = true;
    _error = null;
    _currentMobile = mobile;
    notifyListeners();

    try {
      final response = await _dataSource.sendOtp(mobile);
      _otpMessage = response['message'];
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> verifyOtp(String otp) async {
    if (_currentMobile == null) {
      _error = "Mobile number missing. Please try login again.";
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final fcmToken = await _sharedPrefService
          .getFcmToken(); // Get Saved FCM Token

      final response = await _dataSource.verifyOtp(
        mobile: _currentMobile!,
        otp: otp,
        fcmToken: fcmToken,
      );

      if (response['user'] != null) {
        _user = UserModel.fromJson(response['user']);
        await _sharedPrefService.saveUser(_user!);
      }

      if (response['token'] != null) {
        await _sharedPrefService.saveToken(response['token']);
      }

      // 📊 ANALYTICS
      if (_user != null) {
        await _analytics.setUserId(_user!.id);
        _analytics.setUserMobile(_user!.mobile);
        await _analytics.setUserProperty(name: 'role', value: _user!.role);
        await _analytics.setUserProperty(
          name: AnalyticsConstants.phoneNumber,
          value: _user!.mobile,
        );
        await _analytics.logLogin(method: 'otp');
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _sharedPrefService.clearUser();
    await _sharedPrefService.clearToken();
    await _analytics.logLogout();
    _user = null;
    notifyListeners();
  }

  Future<void> fetchProfile() async {
    try {
      final response = await _dataSource.getProfile();
      // Assuming response is UserModel compatible or has 'data'
      // If response is the user object directly:
      if (response['data'] != null) {
        _user = UserModel.fromJson(response['data']);
        await _sharedPrefService.saveUser(_user!);
        notifyListeners();
      } else if (response['_id'] != null) {
        // Direct object
        _user = UserModel.fromJson(response);
        await _sharedPrefService.saveUser(_user!);
        // Update analytics properties on profile fetch too
        _analytics.setUserMobile(_user!.mobile);
        await _analytics.setUserProperty(
          name: AnalyticsConstants.phoneNumber,
          value: _user!.mobile,
        );
        notifyListeners();
      }
    } catch (e) {
      // Fetch Profile Error: $e
    }
  }

  Future<bool> updateProfile(Map<String, dynamic> data) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await _dataSource.updateProfile(data);
      if (response['data'] != null) {
        _user = UserModel.fromJson(response['data']);
        await _sharedPrefService.saveUser(_user!);
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        // Some APIs return "success": true without data, or updated user
        await fetchProfile(); // Refresh to be safe
        _isLoading = false;
        notifyListeners();
        return true;
      }
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
