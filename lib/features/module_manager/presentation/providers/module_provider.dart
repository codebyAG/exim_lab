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
