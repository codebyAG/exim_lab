import 'package:flutter/material.dart';
import '../../data/models/module_config.dart';
import '../../data/services/module_service.dart';

export '../../data/models/module_config.dart';

class ModuleProvider extends ChangeNotifier {
  final ModuleService _moduleService;
  ModuleConfig? _config;
  bool _isLoading = true;

  ModuleProvider(this._moduleService);

  bool get isLoading => _isLoading;

  Future<void> fetchModules() async {
    _isLoading = true;
    notifyListeners();

    _config = await _moduleService.fetchConfig();
    _isLoading = false;
    notifyListeners();
  }

  bool isEnabled(String module) {
    if (_config == null) return false;
    return _config!.isEnabled(module);
  }

  // Method to update config (e.g. from API or local storage in future)
  void updateConfig(Map<String, bool> newModules) {
    _config = ModuleConfig(modules: newModules);
    notifyListeners();
  }

  // Helper to toggle a module (for dev testing)
  void toggleModule(String module) {
    if (_config == null) return;
    final currentMap = Map<String, bool>.from(_config!.modules);
    currentMap[module] = !isEnabled(module);
    updateConfig(currentMap);
  }
}
