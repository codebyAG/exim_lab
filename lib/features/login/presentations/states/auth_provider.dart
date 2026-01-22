import 'package:flutter/material.dart';
import 'package:exim_lab/features/login/data/data_sources/auth_data_source.dart';

class AuthProvider extends ChangeNotifier {
  final AuthDataSource _dataSource = AuthDataSource();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  String? _otpMessage;
  String? get otpMessage => _otpMessage;

  String? _currentMobile;
  String? get currentMobile => _currentMobile;

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
      await _dataSource.verifyOtp(mobile: _currentMobile!, otp: otp);
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
}
