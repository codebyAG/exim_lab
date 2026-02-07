enum AppModule {
  carousel,
  courses,
  continueLearning,
  quizzes,
  freeVideos,
  tools,
  news,
  banners,
}

class ModuleConfig {
  final Map<AppModule, bool> _modules;

  ModuleConfig({required Map<AppModule, bool> modules}) : _modules = modules;

  bool isEnabled(AppModule module) =>
      _modules[module] ?? true; // Default to true

  factory ModuleConfig.defaults() {
    return ModuleConfig(
      modules: {
        AppModule.carousel: true,
        AppModule.courses: true,
        AppModule.continueLearning: false,
        AppModule.quizzes: false,
        AppModule.freeVideos: true,
        AppModule.tools: true,
        AppModule.news: false,
        AppModule.banners: true,
      },
    );
  }

  factory ModuleConfig.fromJson(Map<String, dynamic> json) {
    final Map<AppModule, bool> modules = {};
    for (var key in json.keys) {
      // Find matching enum (case-insensitive or exact?)
      // Enum is cameCase, API keys should be too.
      try {
        final module = AppModule.values.firstWhere(
          (e) => e.name == key,
          orElse: () => AppModule.values.first, // Fallback? Or skip
        );
        if (module.name == key) {
          modules[module] = json[key] == true;
        }
      } catch (_) {}
    }

    // Merge with defaults to ensure all keys exist
    final defaults = ModuleConfig.defaults()._modules;
    modules.forEach((key, value) {
      defaults[key] = value;
    });

    return ModuleConfig(modules: defaults);
  }
}
