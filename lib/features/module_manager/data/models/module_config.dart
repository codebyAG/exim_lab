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

    for (var rawKey in json.keys) {
      final key = rawKey.trim();
      try {
        final module = AppModule.values.firstWhere(
          (e) => e.name == key,
          orElse: () => AppModule.values.first,
        );
        log("Key: '$rawKey' (trimmed: '$key') -> Enum: ${module.name}");
        if (module.name == key) {
          modules[module] = json[rawKey] == true;
        } else {
          // Try partial match or case insensitive?
          // For now, let's just log failure to match exactly if nomes differ
          log(
            "Warning: Key '$key' matched default or mismatch '${module.name}'",
          );
        }
      } catch (e) {
        log("Error parsing key '$key': $e");
      }
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
