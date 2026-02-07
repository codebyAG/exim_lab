enum AppModule { carousel, courses, quizzes, liveSeminar, tools, news, banners }

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
        AppModule.quizzes: true,
        AppModule.liveSeminar: true,
        AppModule.tools: true,
        AppModule.news: true,
        AppModule.banners: true,
      },
    );
  }
}
