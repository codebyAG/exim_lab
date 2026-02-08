import 'package:exim_lab/features/shorts/data/models/short_model.dart';
import 'package:exim_lab/features/shorts/data/services/shorts_service.dart';
import 'package:flutter/material.dart';

class ShortsProvider extends ChangeNotifier {
  final ShortsService _service;

  ShortsProvider(this._service);

  List<ShortModel> _shorts = [];
  bool _isLoading = false;
  int _currentIndex = 0;

  List<ShortModel> get shorts => _shorts;
  bool get isLoading => _isLoading;
  int get currentIndex => _currentIndex;

  Future<void> fetchShorts() async {
    _isLoading = true;
    notifyListeners();

    try {
      _shorts = await _service.getShorts();
    } catch (e) {
      debugPrint('Error fetching shorts: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setCurrentIndex(int index) {
    _currentIndex = index;
    // notifyListeners(); // Usually not needed for simple index tracking unless UI depends on it
  }
}
