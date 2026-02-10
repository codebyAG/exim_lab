import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:exim_lab/core/services/firebase_messaging_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_in_app_messaging/firebase_in_app_messaging.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:exim_lab/core/services/analytics_service.dart';
import 'package:exim_lab/firebase_options.dart'; // User needs to generate this
import 'package:exim_lab/core/theme/light_theme.dart';
import 'package:exim_lab/core/theme/dark_theme.dart';
import 'package:exim_lab/core/theme/theme_provider.dart';
import 'package:exim_lab/features/courses/presentation/states/course_details_state.dart';
import 'package:exim_lab/features/courses/presentation/states/course_state.dart';
import 'package:exim_lab/features/freevideos/presentation/states/free_video_state.dart';

import 'package:exim_lab/localization/app_localization.dart';
import 'package:exim_lab/localization/locale_provider.dart';
import 'package:flutter/material.dart';
import 'package:exim_lab/features/splash/presentation/screens/splash_screen.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:exim_lab/features/login/presentations/states/auth_provider.dart';
import 'package:exim_lab/features/quiz/presentation/states/quiz_provider.dart';
import 'package:exim_lab/features/dashboard/presentation/providers/dashboard_provider.dart';
import 'package:provider/provider.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:sizer/sizer.dart';
import 'dart:developer';

import 'package:exim_lab/features/news/data/services/news_service.dart';
import 'package:exim_lab/features/news/presentation/providers/news_provider.dart';
import 'package:exim_lab/features/notifications/presentation/providers/notifications_provider.dart';
import 'package:exim_lab/features/module_manager/presentation/providers/module_provider.dart';
import 'package:exim_lab/features/shorts/data/services/shorts_service.dart';
import 'package:exim_lab/features/shorts/presentation/providers/shorts_provider.dart';
import 'package:exim_lab/features/module_manager/data/services/module_service.dart';
import 'package:exim_lab/features/dashboard/data/services/referrer_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final newsService = NewsService();
  // Moved AnalyticsService creation after Firebase.initializeApp to avoid early instance access

  // 🔥 Firebase Init
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FirebaseAnalytics.instance;
    FirebaseInAppMessaging.instance.setAutomaticDataCollectionEnabled(true);
  } catch (e) {
    log(
      "⚠️ Firebase initialization failed (Missing firebase_options.dart?): $e",
    );
  }

  final analyticsService = AnalyticsService();

  // 🔔 Awesome Notifications Init
  AwesomeNotifications().initialize(
    null, // icon: null uses default app icon
    [
      NotificationChannel(
        channelGroupKey: 'basic_test',
        channelKey: 'basic',
        channelName: 'Basic notifications',
        channelDescription: 'Notification channel for basic tests',
        channelShowBadge: true,
        importance: NotificationImportance.High,
      ),
    ],
  );

  // 📨 Firebase Messaging Setup
  FirebaseMessagingService firebaseMessagingService =
      FirebaseMessagingService();
  await firebaseMessagingService.setupFirebase();
  await firebaseMessagingService.setupTokenSync(); // Listen for refresh

  FirebaseMessaging.onBackgroundMessage(
    FirebaseMessagingService.firebaseBackgroundMessage,
  );

  await firebaseMessagingService.getFirebaseToken();
  // if (fcmToken != null) { ... }  <-- Removed sync logic, now just saves locally

  await firebaseMessagingService.subsScribetoAlltopic();

  // 🔒 LOCK ORIENTATION (PORTRAIT ONLY)
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  final themeProvider = ThemeProvider();
  await themeProvider.loadTheme();

  final localeProvider = LocaleProvider();
  await localeProvider.loadLocale();

  final moduleService = ModuleService();

  final moduleProvider = ModuleProvider(moduleService);
  await moduleProvider.fetchModules();

  final shortsProvider = ShortsProvider(ShortsService());
  // await shortsProvider.fetchShorts(); // Maybe await this too if critical, or let it load in background

  // 📊 Check Install Referrer (Public API - No Token)
  ReferrerService().trackInstallSource();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => themeProvider),
        ChangeNotifierProvider(create: (_) => localeProvider),
        ChangeNotifierProvider(create: (_) => CoursesState()),
        ChangeNotifierProvider(create: (_) => CourseDetailsState()),
        ChangeNotifierProvider(create: (_) => FreeVideosState()..load()),
        ChangeNotifierProvider(create: (_) => QuizProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        // Shorts Provider
        ChangeNotifierProvider.value(value: shortsProvider),
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
        ChangeNotifierProvider(create: (_) => NewsProvider(newsService)),
        ChangeNotifierProvider(create: (_) => NotificationsProvider()),
        ChangeNotifierProvider.value(value: moduleProvider),
        Provider.value(value: analyticsService),
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

    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Import Export',
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
          navigatorObservers: [
            context.read<AnalyticsService>().getAnalyticsObserver(),
            context.read<AnalyticsService>().getCustomObserver(),
          ],

          home: const SplashScreen(),
        );
      },
    );
  }
}
