import 'dart:io';

import 'package:exim_lab/core/navigation/app_navigator.dart';
import 'package:exim_lab/core/services/shared_pref_service.dart';
import 'package:exim_lab/features/dashboard/presentation/screens/dashboard.dart';
import 'package:exim_lab/features/welcome/presentation/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkForUpdates(context);
  }

  void checkForUpdates(BuildContext context) {
    if (!Platform.isAndroid) {
      goToLogin();
      return;
    }

    InAppUpdate.checkForUpdate()
        .then((updateInfo) {
          if ((updateInfo.updateAvailability ==
                      UpdateAvailability.updateAvailable ||
                  updateInfo.updateAvailability ==
                      UpdateAvailability.developerTriggeredUpdateInProgress) &&
              updateInfo.immediateUpdateAllowed) {
            showUpdateBottomSheet(context);
          } else {
            goToLogin();
          }
        })
        .catchError((_) {
          goToLogin();
        });
  }

  void goToLogin() async {
    // ⏳ WAIT A BIT FOR SPLASH EFFECT
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    final sharedPref = SharedPrefService();
    final token = await sharedPref.getToken();

    if (token != null && token.isNotEmpty) {
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
        child: Image.asset(
          'assets/app_logo.png', // Ensure you have this logo
          width: 150,
          height: 150,
        ),
      ),
    );
  }
}
