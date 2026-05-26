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
            // 🌌 1. DEEP GRADIENT BASE
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isDark
                        ? const [
                            Color(0xFF010618), // Ultra Dark Space Navy
                            Color(0xFF081335), // Deep Space Navy
                          ]
                        : const [
                            Color(0xFFF1F5F9), // Slate 100
                            Color(0xFFE2E8F0), // Slate 200
                          ],
                  ),
                ),
              ),
            ),

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
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(28),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(
                                sigmaX: 16.0,
                                sigmaY: 16.0,
                              ),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24.0,
                                  vertical: 36.0,
                                ),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? Colors.white.withValues(alpha: 0.03)
                                      : Colors.black.withValues(alpha: 0.015),
                                  borderRadius: BorderRadius.circular(28),
                                  border: Border.all(
                                    color:
                                        (isDark ? Colors.white : Colors.black)
                                            .withValues(
                                              alpha: isDark ? 0.08 : 0.06,
                                            ),
                                    width: 1.5,
                                  ),
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
                                                  color: theme
                                                      .colorScheme
                                                      .secondary
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
                          ),
                        ),

                        const SizedBox(height: 32),

                        // ⚡ BUTTON COLUMN
                        FadeInUp(
                          delay: const Duration(milliseconds: 300),
                          duration: const Duration(milliseconds: 600),
                          child: InkWell(
                            onTap: _isChecking ? null : _checkStatus,
                            borderRadius: BorderRadius.circular(16),
                            child: Ink(
                              width: double.infinity,
                              height: 56,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                gradient: LinearGradient(
                                  colors: _isChecking
                                      ? [
                                          theme.colorScheme.primary.withValues(
                                            alpha: 0.6,
                                          ),
                                          theme.colorScheme.primary.withValues(
                                            alpha: 0.4,
                                          ),
                                        ]
                                      : [
                                          theme.colorScheme.primary,
                                          theme.colorScheme.primary.withRed(
                                            (theme.colorScheme.primary.red + 30)
                                                .clamp(0, 255),
                                          ),
                                        ],
                                ),
                                boxShadow: [
                                  if (!_isChecking)
                                    BoxShadow(
                                      color: theme.colorScheme.primary
                                          .withValues(
                                            alpha: isDark ? 0.35 : 0.25,
                                          ),
                                      blurRadius: 16,
                                      offset: const Offset(0, 6),
                                    ),
                                ],
                              ),
                              child: Center(
                                child: _isChecking
                                    ? const SizedBox(
                                        height: 24,
                                        width: 24,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.5,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                Colors.white,
                                              ),
                                        ),
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: const [
                                          Text(
                                            "Check Again / दोबारा जांचें",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              letterSpacing: 0.2,
                                            ),
                                          ),
                                          SizedBox(width: 8),
                                          Icon(
                                            Icons.refresh_rounded,
                                            size: 20,
                                            color: Colors.white,
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
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
