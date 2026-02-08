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
      AppModule? module;

      // Explicit mapping to handle obfuscation/minification
      switch (key) {
        case 'carousel':
          module = AppModule.carousel;
          break;
        case 'courses':
          module = AppModule.courses;
          break;
        case 'continueLearning':
          module = AppModule.continueLearning;
          break;
        case 'quizzes':
          module = AppModule.quizzes;
          break;
        case 'freeVideos':
          module = AppModule.freeVideos;
          break;
        case 'tools':
          module = AppModule.tools;
          break;
        case 'news':
          module = AppModule.news;
          break;
        case 'banners':
          module = AppModule.banners;
          break;
        case 'shortVideos':
          module = AppModule.shortVideos;
          break;
        default:
          log("Values: Unknown key '$key'");
      }

      if (module != null) {
        final rawValue = json[rawKey];
        log("Raw Value for $key: $rawValue (Type: ${rawValue.runtimeType})");

        bool value = false;
        if (rawValue is bool) {
          value = rawValue;
        } else if (rawValue is String) {
          value = rawValue.toLowerCase() == 'true';
        } else if (rawValue is int) {
          value = rawValue == 1;
        }

        modules[module] = value;
        log("Assigned $key -> $value");
      }
    }

    log("Parsed Modules Map: $modules");

    // Merge with defaults
    final defaults = ModuleConfig.defaults()._modules;
    modules.forEach((key, value) {
      defaults[key] = value;
    });

    log("Final Modules: $defaults");

    return ModuleConfig(modules: defaults);
  }
}
