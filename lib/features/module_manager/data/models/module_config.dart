class ModuleConfig {
  final Map<String, bool> _modules;

  ModuleConfig({required Map<String, bool> modules}) : _modules = modules;

  Map<String, bool> get modules => Map.unmodifiable(_modules);

  bool isEnabled(String key) => _modules[key] ?? false;

  factory ModuleConfig.defaults() {
    return ModuleConfig(
      modules: {
        'carousel': false,
        'courses': false,
        'continueLearning': false,
        'quizzes': false,
        'freeVideos': false,
        'tools': false,
        'news': false,
        'banners': false,
        'shortVideos': false,
      },
    );
  }

  factory ModuleConfig.fromJson(Map<String, dynamic> json) {
    final Map<String, bool> modules = {};

    for (var rawKey in json.keys) {
      final key = rawKey.trim();
      final rawValue = json[rawKey];

      bool value = false;
      if (rawValue is bool) {
        value = rawValue;
      } else if (rawValue is String) {
        value = rawValue.toLowerCase() == 'true';
      } else if (rawValue is int) {
        value = rawValue == 1;
      }

      modules[key] = value;
    }

    // Merge with defaults
    final defaults = ModuleConfig.defaults()._modules;
    modules.forEach((key, value) {
      defaults[key] = value;
    });

    return ModuleConfig(modules: defaults);
  }
}
