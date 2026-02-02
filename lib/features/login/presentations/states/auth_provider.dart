import 'package:flutter/material.dart';
import 'package:exim_lab/features/login/data/data_sources/auth_data_source.dart';
import 'package:exim_lab/features/login/data/models/user_model.dart';
import 'package:exim_lab/core/services/shared_pref_service.dart';
import 'dart:developer';

class AuthProvider extends ChangeNotifier {
  final AuthDataSource _dataSource = AuthDataSource();
  final SharedPrefService _sharedPrefService = SharedPrefService();

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
      final response = await _dataSource.verifyOtp(
        mobile: _currentMobile!,
        otp: otp,
      );
      log("Auth Response: $response");

      if (response['user'] != null) {
        _user = UserModel.fromJson(response['user']);
        await _sharedPrefService.saveUser(_user!);
      }

      if (response['token'] != null) {
        await _sharedPrefService.saveToken(response['token']);
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
    _user = null;
    notifyListeners();
  }
}
