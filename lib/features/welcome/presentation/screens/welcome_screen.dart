import 'package:exim_lab/common/widgets/language_switch.dart';
import 'package:exim_lab/common/widgets/theme_switch_button.dart';
import 'package:exim_lab/core/navigation/app_navigator.dart';
import 'package:exim_lab/features/login/presentations/screens/login_screen.dart';
import 'package:exim_lab/localization/app_localization.dart';
import 'package:flutter/material.dart';

import 'package:animate_do/animate_do.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = AppLocalizations.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          // BACKGROUND IMAGE
          Positioned.fill(
            child: FadeIn(
              duration: const Duration(milliseconds: 1000),
              child: Image.asset("assets/welcome_bg.png", fit: BoxFit.cover),
            ),
          ),

          // GRADIENT OVERLAY — strong bottom coverage for readability
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: isDark
                      ? const [0.0, 0.3, 0.65, 1.0]
                      : const [0.0, 0.25, 0.55, 1.0],
                  colors: isDark
                      ? [
                          Colors.black.withValues(alpha: 0.55),
                          Colors.black.withValues(alpha: 0.60),
                          Colors.black.withValues(alpha: 0.80),
                          Colors.black.withValues(alpha: 0.92),
                        ]
                      : [
                          Colors.black.withValues(alpha: 0.20),
                          Colors.black.withValues(alpha: 0.25),
                          Colors.black.withValues(alpha: 0.60),
                          Colors.black.withValues(alpha: 0.85),
                        ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // TOP BAR — theme + language switches
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const ThemeSwitchButton(),
                      const SizedBox(width: 8),
                      const LanguageSwitch(),
                    ],
                  ),
                ),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // LOGO
                        FadeInDown(
                          from: 20,
                          duration: const Duration(milliseconds: 700),
                          child: Image.asset(
                            'assets/app_logo.png',
                            height: 64,
                            width: 64,
                          ),
                        ),

                        const SizedBox(height: 16),

                        // "Welcome to"
                        FadeInDown(
                          from: 20,
                          delay: const Duration(milliseconds: 100),
                          duration: const Duration(milliseconds: 700),
                          child: Text(
                            t.translate('welcome_to'),
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),

                        const SizedBox(height: 4),

                        // APP NAME
                        FadeInDown(
                          from: 20,
                          delay: const Duration(milliseconds: 200),
                          duration: const Duration(milliseconds: 700),
                          child: Text(
                            t.translate('app_name'),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              height: 1.1,
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        // TAGLINE
                        FadeInDown(
                          from: 20,
                          delay: const Duration(milliseconds: 300),
                          duration: const Duration(milliseconds: 700),
                          child: Text(
                            t.translate('tagline'),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white.withValues(alpha: 0.75),
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),

                        const SizedBox(height: 28),

                        // FEATURE CHIPS — glass panel
                        FadeInUp(
                          delay: const Duration(milliseconds: 500),
                          duration: const Duration(milliseconds: 600),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 16,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.10),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.18),
                              ),
                            ),
                            child: Column(
                              children: [
                                _feature(t.translate('feature_1')),
                                const SizedBox(height: 10),
                                _feature(t.translate('feature_2')),
                                const SizedBox(height: 10),
                                _feature(t.translate('feature_3')),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 28),

                        // CTA BUTTON
                        FadeInUp(
                          delay: const Duration(milliseconds: 700),
                          duration: const Duration(milliseconds: 500),
                          child: SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: () {
                                AppNavigator.push(context, const LoginScreen());
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: theme.colorScheme.primary,
                                foregroundColor: theme.colorScheme.onPrimary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 0,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    t.translate('get_started'),
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Icon(
                                    Icons.arrow_forward_rounded,
                                    size: 20,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 14),

                        // ALREADY HAVE ACCOUNT
                        FadeInUp(
                          delay: const Duration(milliseconds: 850),
                          duration: const Duration(milliseconds: 500),
                          child: GestureDetector(
                            onTap: () {
                              AppNavigator.push(context, const LoginScreen());
                            },
                            child: RichText(
                              text: TextSpan(
                                style: const TextStyle(fontSize: 14),
                                children: [
                                  TextSpan(
                                    text: 'Already have an account?  ',
                                    style: TextStyle(
                                      color: Colors.white.withValues(
                                        alpha: 0.70,
                                      ),
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Login',
                                    style: TextStyle(
                                      color: theme.colorScheme.primary,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _feature(String text) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check_rounded, color: Colors.white, size: 14),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.white,
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }
}
