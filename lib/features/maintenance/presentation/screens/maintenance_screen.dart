import 'package:animate_do/animate_do.dart';
import 'package:exim_lab/core/navigation/app_navigator.dart';
import 'package:exim_lab/core/providers/config_provider.dart';
import 'package:exim_lab/core/functions/whatsapp_utils.dart';
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
    await Future.delayed(const Duration(milliseconds: 1200));

    if (!mounted) return;

    try {
      final configProvider = context.read<ConfigProvider>();
      final isStillUnderMaintenance = await configProvider.checkMaintenanceStatus();

      if (!mounted) return;

      if (isStillUnderMaintenance) {
        AppNavigator.showSnackBar(
          context,
          _getText(
            context,
            "Maintenance is still active. Please try again later.",
            "रखरखाव अभी भी सक्रिय है। कृपया बाद में पुनः प्रयास करें।",
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
        );
      } else {
        AppNavigator.showSnackBar(
          context,
          _getText(
            context,
            "App is back online!",
            "ऐप वापस ऑनलाइन है!",
          ),
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

  void _contactSupport() {
    WhatsAppUtils.launch(
      message: _getText(
        context,
        "Hello Exim Lab Support, I noticed the app is under maintenance. Is there an ETA for when it will be back online?",
        "नमस्ते एक्जिम लैब सपोर्ट, मैंने देखा कि ऐप रखरखाव के अधीन है। यह कब तक वापस ऑनलाइन होगा?",
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? const [
                      Color(0xFF020C28), // Deep Space Navy
                      Color(0xFF0A2066), // Dark Navy
                    ]
                  : const [
                      Color(0xFFF8FAFC), // Off-White
                      Color(0xFFE2E8F0), // Subtle blue-gray
                    ],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Spacer(),

                  // Glow effect and animated icon
                  FadeInDown(
                    duration: const Duration(milliseconds: 1000),
                    child: Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Glow background
                          Container(
                            width: 140,
                            height: 140,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: theme.colorScheme.secondary.withValues(
                                alpha: isDark ? 0.12 : 0.08,
                              ),
                            ),
                          ),
                          Container(
                            width: 110,
                            height: 110,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: theme.colorScheme.secondary.withValues(
                                alpha: isDark ? 0.20 : 0.15,
                              ),
                            ),
                          ),
                          // Premium Card with Icon
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isDark ? const Color(0xFF0A2066) : Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.construction_rounded,
                              size: 40,
                              color: theme.colorScheme.secondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 36),

                  // Main Title
                  FadeInUp(
                    delay: const Duration(milliseconds: 200),
                    duration: const Duration(milliseconds: 800),
                    child: Text(
                      _getText(
                        context,
                        "System Upgrades In Progress",
                        "सिस्टम अपग्रेड प्रगति पर है",
                      ),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: theme.colorScheme.onSurface,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Subtitle / Description
                  FadeInUp(
                    delay: const Duration(milliseconds: 350),
                    duration: const Duration(milliseconds: 800),
                    child: Text(
                      _getText(
                        context,
                        "We are currently updating our systems to serve you better. The app will be back online shortly. Thank you for your patience!",
                        "हम वर्तमान में आपकी बेहतर सेवा करने के लिए अपने सिस्टम को अपडेट कर रहे हैं। ऐप जल्द ही ऑनलाइन वापस आ जाएगा। आपके धैर्य के लिए धन्यवाद!",
                      ),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                        height: 1.5,
                      ),
                    ),
                  ),

                  const Spacer(),

                  // Actions Column
                  FadeInUp(
                    delay: const Duration(milliseconds: 500),
                    duration: const Duration(milliseconds: 800),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Try Again Button
                        SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: ElevatedButton(
                            onPressed: _isChecking ? null : _checkStatus,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.colorScheme.primary,
                              foregroundColor: theme.colorScheme.onPrimary,
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: _isChecking
                                ? const SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        _getText(
                                          context,
                                          "Check Again",
                                          "पुनः जांचें",
                                        ),
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      const Icon(Icons.refresh_rounded, size: 20),
                                    ],
                                  ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Contact Support Button
                        SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: OutlinedButton(
                            onPressed: _contactSupport,
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                color: theme.colorScheme.outline.withValues(alpha: 0.5),
                                width: 1.5,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              foregroundColor: theme.colorScheme.onSurface,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.support_agent_rounded, size: 22),
                                const SizedBox(width: 10),
                                Text(
                                  _getText(
                                    context,
                                    "Contact Support",
                                    "सहायता से संपर्क करें",
                                  ),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
