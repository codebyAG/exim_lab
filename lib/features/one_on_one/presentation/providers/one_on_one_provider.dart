import 'package:flutter/foundation.dart';
import 'package:exim_lab/features/one_on_one/data/models/one_on_one_config_model.dart';
import 'package:exim_lab/features/one_on_one/data/services/one_on_one_service.dart';

class OneOnOneProvider extends ChangeNotifier {
  final OneOnOneService _service = OneOnOneService();

  OneOnOneConfig? config;
  bool isLoading = false;
  String? error;

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
