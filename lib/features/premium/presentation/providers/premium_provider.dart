import 'package:flutter/foundation.dart';
import 'package:exim_lab/features/premium/data/models/premium_config_model.dart';
import 'package:exim_lab/features/premium/data/services/premium_service.dart';

class PremiumProvider extends ChangeNotifier {
  final PremiumService _service = PremiumService();

  PremiumConfig? config;
  bool isLoading = false;
  String? error;

  bool get hasData => config != null;

  Future<void> load({bool force = false}) async {
    if (isLoading) return;
    if (config != null && !force) return;

    isLoading = true;
    error = null;
    notifyListeners();

    try {
      config = await _service.fetchConfig();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
