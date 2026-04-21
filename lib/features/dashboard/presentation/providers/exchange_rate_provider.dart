import 'package:flutter/material.dart';
import 'package:exim_lab/features/dashboard/data/models/exchange_rate_model.dart';
import 'package:exim_lab/features/dashboard/data/services/exchange_rate_service.dart';
import 'dart:developer' as developer;

class ExchangeRateProvider extends ChangeNotifier {
  final ExchangeRateService _service = ExchangeRateService();

  ExchangeRateResponse? _data;
  bool _isLoading = false;
  String? _error;

  ExchangeRateResponse? get data => _data;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchRates() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _service.fetchExchangeRates();
      _data = response;
      developer.log("💹 Forex Ticker -> Successfully fetched rich rates.");
    } catch (e) {
      _error = e.toString();
      developer.log("💹 Forex Ticker -> API Error: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
