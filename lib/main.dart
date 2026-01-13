import 'package:exim_lab/core/theme/light_theme.dart';
import 'package:exim_lab/core/theme/dark_theme.dart';
import 'package:exim_lab/core/theme/theme_provider.dart';
import 'package:exim_lab/features/courses/presentation/states/course_details_state.dart';
import 'package:exim_lab/features/courses/presentation/states/course_state.dart';
import 'package:exim_lab/features/welcome/presentation/screens/welcome_screen.dart';
import 'package:exim_lab/localization/app_localization.dart';
import 'package:exim_lab/localization/locale_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // 🔒 LOCK ORIENTATION (PORTRAIT ONLY)
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  final themeProvider = ThemeProvider();
  await themeProvider.loadTheme();

  final localeProvider = LocaleProvider();
  await localeProvider.loadLocale();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => themeProvider),
        ChangeNotifierProvider(create: (_) => localeProvider),
        ChangeNotifierProvider(create: (_) => CoursesState()),
        ChangeNotifierProvider(create: (_) => CourseDetailsState()),
      ],
      child: const EximLabApp(),
    ),
  );
}

class EximLabApp extends StatelessWidget {
  const EximLabApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final localeProvider = context.watch<LocaleProvider>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EximLab',

      // 🌗 THEME
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeProvider.themeMode,

      // 🌍 LOCALIZATION
      locale: localeProvider.locale,
      supportedLocales: const [Locale('en'), Locale('hi')],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      home: const WelcomeScreen(),
    );
  }
}
