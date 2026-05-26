import 'dart:ui';
import 'package:animate_do/animate_do.dart';
import 'package:exim_lab/core/navigation/app_navigator.dart';
import 'package:exim_lab/core/providers/config_provider.dart';
import 'package:exim_lab/features/dashboard/presentation/screens/dashboard.dart';
import 'package:exim_lab/features/login/presentations/states/auth_provider.dart';
import 'package:exim_lab/features/welcome/presentation/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MaintenanceScreen extends StatefulWidget {
  const MaintenanceScreen({super.key});

  @override
  State<MaintenanceScreen> createState() => _MaintenanceScreenState();
}

class _MaintenanceScreenState extends State<MaintenanceScreen> {
  bool _isChecking = false;

  String _getText(BuildContext context, String en, String hi) {
    final locale = Localizations.localeOf(context);
    return locale.languageCode == 'hi' ? hi : en;
  }

  Future<void> _checkStatus() async {
    if (_isChecking) return;

    setState(() {
      _isChecking = true;
    });

    // Add a slight delay for better visual feedback
    await Future.delayed(const Duration(milliseconds: 1500));

    if (!mounted) return;

    try {
      final configProvider = context.read<ConfigProvider>();
      final isStillUnderMaintenance = await configProvider
          .checkMaintenanceStatus();

      if (!mounted) return;

      if (isStillUnderMaintenance) {
        AppNavigator.showSnackBar(
          context,
          _getText(
            context,
            "App is still under maintenance.",
            "ऐप अभी बंद है। कृपया बाद में देखें।",
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
        );
      } else {
        AppNavigator.showSnackBar(
          context,
          _getText(context, "App is back online!", "ऐप शुरू हो गया है!"),
          backgroundColor: Colors.green.shade800,
        );

        final authProvider = context.read<AuthProvider>();
        final isLoggedIn = await authProvider.checkLoginStatus();

        if (!mounted) return;

        if (isLoggedIn) {
          AppNavigator.replace(context, DashboardScreen());
        } else {
          AppNavigator.replace(context, const WelcomeScreen());
        }
      }
    } catch (_) {
      if (!mounted) return;
      AppNavigator.showSnackBar(
        context,
        _getText(
          context,
          "Failed to connect. Please check your internet connection.",
          "कनेक्ट करने में विफल। कृपया अपना इंटरनेट कनेक्शन जांचें।",
        ),
        backgroundColor: Theme.of(context).colorScheme.error,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isChecking = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Stack(
          children: [
            // 🌌 1. DEEP SOLID BACKGROUND MATCHING APP
            Positioned.fill(child: Container(color: theme.colorScheme.surface)),

            // 🔮 2. GLOWING AMBIENT LIGHTS (Glassmorphic Backdrop Circles)
            Positioned(
              top: -size.height * 0.15,
              right: -size.width * 0.15,
              child: Container(
                width: size.width * 0.8,
                height: size.width * 0.8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      theme.colorScheme.primary.withValues(
                        alpha: isDark ? 0.18 : 0.12,
                      ),
                      theme.colorScheme.primary.withValues(alpha: 0.0),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: -size.height * 0.1,
              left: -size.width * 0.1,
              child: Container(
                width: size.width * 0.7,
                height: size.width * 0.7,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      theme.colorScheme.secondary.withValues(
                        alpha: isDark ? 0.12 : 0.08,
                      ),
                      theme.colorScheme.secondary.withValues(alpha: 0.0),
                    ],
                  ),
                ),
              ),
            ),

            // 📱 3. FOREGROUND MAIN LAYOUT
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 20.0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // 🌟 GLASSMORPHIC CONTENT CARD
                        ZoomIn(
                          duration: const Duration(milliseconds: 600),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24.0,
                              vertical: 36.0,
                            ),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? theme.colorScheme.primaryContainer
                                        .withValues(alpha: 0.5)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: isDark
                                    ? theme.colorScheme.primary.withValues(
                                        alpha: 0.2,
                                      )
                                    : theme.colorScheme.outline.withValues(
                                        alpha: 0.15,
                                      ),
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(
                                    alpha: isDark ? 0.25 : 0.06,
                                  ),
                                  blurRadius: 24,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Glow Icon Container
                                Center(
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Container(
                                        width: 120,
                                        height: 120,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: theme.colorScheme.secondary
                                              .withValues(
                                                alpha: isDark ? 0.10 : 0.06,
                                              ),
                                        ),
                                      ),
                                      Container(
                                        width: 96,
                                        height: 96,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: theme.colorScheme.secondary
                                              .withValues(
                                                alpha: isDark ? 0.18 : 0.12,
                                              ),
                                        ),
                                      ),
                                      Container(
                                        width: 72,
                                        height: 72,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          gradient: LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: [
                                              theme.colorScheme.secondary,
                                              theme.colorScheme.secondary
                                                  .withValues(alpha: 0.85),
                                            ],
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: theme.colorScheme.secondary
                                                  .withValues(alpha: 0.3),
                                              blurRadius: 12,
                                              offset: const Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        child: const Icon(
                                          Icons.construction_rounded,
                                          size: 36,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 28),

                                // Main Title (English & Hindi)
                                Text(
                                  "App Under Maintenance",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800,
                                    color: theme.colorScheme.onSurface,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "ऐप अभी बंद है (रखरखाव)",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: theme.colorScheme.onSurface
                                        .withValues(alpha: 0.8),
                                  ),
                                ),

                                const SizedBox(height: 20),

                                // Custom Divider
                                Container(
                                  width: 60,
                                  height: 3,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: theme.colorScheme.secondary
                                        .withValues(alpha: 0.4),
                                  ),
                                ),

                                const SizedBox(height: 20),

                                // Subtitle / Description (English & Hindi)
                                Text(
                                  "We are updating the app to make it better. Please try again after some time.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: theme.colorScheme.onSurface
                                        .withValues(alpha: 0.7),
                                    height: 1.4,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  "हम ऐप को बेहतर बनाने के लिए काम कर रहे हैं। कृपया कुछ समय बाद दोबारा प्रयास करें।",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: theme.colorScheme.onSurface
                                        .withValues(alpha: 0.55),
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 32),

                        // ⚡ BUTTON COLUMN
                        FadeInUp(
                          delay: const Duration(milliseconds: 300),
                          duration: const Duration(milliseconds: 600),
                          child: SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: _isChecking ? null : _checkStatus,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: theme.colorScheme.primary,
                                foregroundColor: theme.colorScheme.onPrimary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 0,
                              ),
                              child: _isChecking
                                  ? SizedBox(
                                      height: 24,
                                      width: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              theme.colorScheme.onPrimary,
                                            ),
                                      ),
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Check Again / दोबारा जांचें",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: theme.colorScheme.onPrimary,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        const Icon(
                                          Icons.refresh_rounded,
                                          size: 20,
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
