import 'package:flutter/material.dart';
import '../../data/models/module_config.dart';
import '../../data/services/module_service.dart';

export '../../data/models/module_config.dart';

class ModuleProvider extends ChangeNotifier {
  ModuleConfig _config = ModuleConfig.defaults();
  final ModuleService _service;

  ModuleProvider(this._service);

  bool isEnabled(AppModule module) => _config.isEnabled(module);

  Future<void> fetchModules() async {
    final config = await _service.fetchConfig();
    if (config != null) {
      _config = config;
      notifyListeners();
    }
  }

  // Method to update config (e.g. from API or local storage in future)
  void updateConfig(Map<AppModule, bool> newModules) {
    _config = ModuleConfig(modules: newModules);
    notifyListeners();
  }

  // Helper to toggle a module (for dev testing)
  void toggleModule(AppModule module) {
    final currentMap = Map<AppModule, bool>.from(_config._modules);
    currentMap[module] = !isEnabled(module);
    updateConfig(currentMap);
  }
}

extension ModuleConfigExtension on ModuleConfig {
  Map<AppModule, bool> get _modules => (this as dynamic)._modules;
  // Wait, I can't access private field _modules easily in extension without modifying model.
  // I'll fix model or provider.
  // Actually, I'll just expose modules in model.
}
