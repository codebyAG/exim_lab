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
    return Scaffold(
      body: Stack(
        children: [
          // 🔹 BACKGROUND IMAGE
          Positioned.fill(
            child: FadeIn(
              duration: const Duration(milliseconds: 1000),
              child: Image.asset("assets/welcome_bg.png", fit: BoxFit.cover),
            ),
          ),

          // 🔹 UNIVERSAL GRADIENT OVERLAY (FIXES BOTH MODES)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: theme.brightness == Brightness.dark
                      ? [
                          Colors.black.withValues(alpha: 0.65),
                          Colors.black.withValues(alpha: 0.65),
                          Colors.black.withValues(alpha: 0.65),
                        ]
                      : [
                          Colors.black.withValues(alpha: 0.35),
                          Colors.black.withValues(alpha: 0.25),
                          Colors.black.withValues(alpha: 0.15),
                          Colors.transparent,
                        ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // 🌐 LANGUAGE SWITCH
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const ThemeSwitchButton(),
                    const SizedBox(width: 8),
                    LanguageSwitch(),
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        FadeInDown(
                          from: 20,
                          duration: const Duration(milliseconds: 800),
                          child: Text(
                            t.translate('welcome_to'),
                            style: const TextStyle(
                              fontSize: 17,
                              color: Colors.white,
                            ),
                          ),
                        ),

                        const SizedBox(height: 6),

                        FadeInDown(
                          from: 20,
                          delay: const Duration(milliseconds: 200),
                          duration: const Duration(milliseconds: 800),
                          child: Text(
                            t.translate('app_name'),
                            style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        FadeInDown(
                          from: 20,
                          delay: const Duration(milliseconds: 400),
                          duration: const Duration(milliseconds: 800),
                          child: Text(
                            t.translate('tagline'),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 17,
                              color: Colors.white,
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        FadeInLeft(
                          delay: const Duration(milliseconds: 600),
                          child: _feature(t.translate('feature_1')),
                        ),
                        FadeInLeft(
                          delay: const Duration(milliseconds: 800),
                          child: _feature(t.translate('feature_2')),
                        ),
                        FadeInLeft(
                          delay: const Duration(milliseconds: 1000),
                          child: _feature(t.translate('feature_3')),
                        ),

                        const SizedBox(height: 32),

                        // 🔹 CTA BUTTON
                        FadeInUp(
                          delay: const Duration(milliseconds: 1200),
                          child: SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: () {
                                AppNavigator.push(context, LoginScreen());
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: theme.colorScheme.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                elevation: 4,
                              ),
                              child: Text(
                                t.translate('get_started'),
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.onPrimary,
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        FadeInUp(
                          delay: const Duration(milliseconds: 1400),
                          child: TextButton(
                            onPressed: () {
                              AppNavigator.push(context, LoginScreen());
                            },
                            child: Text(
                              t.translate('already_account'),
                              style: const TextStyle(
                                color: Colors.white,
                                decoration: TextDecoration.underline,
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.check_circle, color: Colors.white, size: 20),
          SizedBox(width: 12),
          Expanded(child: Text('', textAlign: TextAlign.center)),
        ],
      ),
    ).copyWithText(text);
  }
}

// 🔹 CLEAN EXTENSION FOR FEATURE TEXT
extension _FeatureText on Widget {
  Widget copyWithText(String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.check_circle, color: Colors.white, size: 20),
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
