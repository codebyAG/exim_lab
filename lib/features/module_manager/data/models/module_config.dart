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
        AppModule.continueLearning: true,
        AppModule.quizzes: true,
        AppModule.freeVideos: true,
        AppModule.tools: true,
        AppModule.news: true,
        AppModule.banners: true,
      },
    );
  }
}
