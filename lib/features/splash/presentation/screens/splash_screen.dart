import 'dart:io';

import 'package:exim_lab/core/navigation/app_navigator.dart';
import 'package:exim_lab/features/dashboard/presentation/screens/dashboard.dart';
import 'package:exim_lab/features/login/presentations/states/auth_provider.dart';
import 'package:exim_lab/features/welcome/presentation/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:provider/provider.dart';
import 'package:exim_lab/features/module_manager/presentation/providers/module_provider.dart';
import 'package:animate_do/animate_do.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkForUpdates();
  }

  Future<void> checkForUpdates() async {
    if (!Platform.isAndroid) {
      initializeAndNavigate();
      return;
    }

    try {
      final updateInfo = await InAppUpdate.checkForUpdate();
      if (!mounted) return;

      if ((updateInfo.updateAvailability ==
                  UpdateAvailability.updateAvailable ||
              updateInfo.updateAvailability ==
                  UpdateAvailability.developerTriggeredUpdateInProgress) &&
          updateInfo.immediateUpdateAllowed) {
        // ignore: use_build_context_synchronously
        showUpdateBottomSheet(context);
      } else {
        initializeAndNavigate();
      }
    } catch (_) {
      if (!mounted) return;
      initializeAndNavigate();
    }
  }

  Future<void> initializeAndNavigate() async {
    // ⏳ MINIMUM SPLASH DELAY (Visual Experience)
    // Run the delay in parallel with initialization
    final minDelayFuture = Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // 1. 🚀 FETCH MODULES FIRST (No Auth Required)
    // This ensures we have the latest config (maintenance mode, feature flags)
    // before we even decide where to navigate.
    try {
      final moduleProvider = context.read<ModuleProvider>();
      await moduleProvider.fetchModules();
    } catch (e) {
      // Log error but allow navigation to proceed (will use defaults/cache)
      // log("Error fetching modules on splash: $e");
    }

    // Wait for the minimum splash delay to finish
    await minDelayFuture;

    if (!mounted) return;

    // 2. CHECK LOGIN STATUS
    final authProvider = context.read<AuthProvider>();
    final isLoggedIn = await authProvider.checkLoginStatus();

    if (!mounted) return;

    // 3. NAVIGATE
    if (isLoggedIn) {
      AppNavigator.replace(context, const DashboardScreen());
    } else {
      AppNavigator.replace(context, const WelcomeScreen());
    }
  }

  void showUpdateBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔔 Icon + Title
              Center(
                child: Column(
                  children: const [
                    Icon(
                      Icons.system_update_alt,
                      size: 50,
                      color: Colors.orange,
                    ),
                    SizedBox(height: 12),
                    Text(
                      "Update Required",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // 📝 Description
              const Text(
                "A new version of the app is available. "
                "This update is required to continue using the application.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.black87),
              ),

              const SizedBox(height: 20),

              // ✅ Benefits list
              _updatePoint("Improved app performance and stability"),
              _updatePoint("Latest market features and updates"),
              _updatePoint("Important security and bug fixes"),
              _updatePoint("Better and smoother user experience"),

              const SizedBox(height: 24),

              // 🔥 Update button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange.shade800,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    Navigator.pop(context);
                    await InAppUpdate.performImmediateUpdate();
                  },
                  child: const Text(
                    "Update Now",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // ℹ️ Footer note
              const Center(
                child: Text(
                  "Updating ensures you get the best experience.",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _updatePoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Icon(Icons.check_circle, size: 18, color: Colors.green),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: FadeInDown(
          // Wrap with FadeInDown
          duration: const Duration(milliseconds: 1200),
          child: Image.asset(
            'assets/app_logo.png', // Ensure you have this logo
            width: 150,
            height: 150,
          ),
        ),
      ),
    );
  }
}
