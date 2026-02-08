import 'dart:developer';

enum AppModule {
  carousel,
  courses,
  continueLearning,
  quizzes,
  freeVideos,
  tools,
  news,
  banners,
  shortVideos,
}

class ModuleConfig {
  final Map<AppModule, bool> _modules;

  ModuleConfig({required Map<AppModule, bool> modules}) : _modules = modules;

  bool isEnabled(AppModule module) =>
      _modules[module] ?? false; // Default to false loops api unused

  factory ModuleConfig.defaults() {
    return ModuleConfig(
      modules: {
        AppModule.carousel: false,
        AppModule.courses: false,
        AppModule.continueLearning: false,
        AppModule.quizzes: false,
        AppModule.freeVideos: false,
        AppModule.tools: false,
        AppModule.news: false,
        AppModule.banners: false,
        AppModule.shortVideos: false,
      },
    );
  }

  factory ModuleConfig.fromJson(Map<String, dynamic> json) {
    final Map<AppModule, bool> modules = {};
    log("Parsing ModuleConfig: $json");

    for (var key in json.keys) {
      try {
        final module = AppModule.values.firstWhere(
          (e) => e.name == key,
          orElse: () => AppModule.values.first,
        );
        log("Key: $key -> Enum: ${module.name}");
        if (module.name == key) {
          modules[module] = json[key] == true;
        }
      } catch (_) {}
    }

    // Merge with defaults
    final defaults = ModuleConfig.defaults()._modules;
    modules.forEach((key, value) {
      defaults[key] = value;
    });

    log("Final Modules: $defaults");

    return ModuleConfig(modules: defaults);
  }
}
