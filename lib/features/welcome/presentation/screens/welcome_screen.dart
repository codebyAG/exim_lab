import 'package:exim_lab/localization/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:exim_lab/localization/locale_provider.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = AppLocalizations.of(context);
    final localeProvider = context.watch<LocaleProvider>();
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // 🔹 FULL PAGE SKY BACKGROUND
          Positioned.fill(
            child: Image.asset('assets/welcome_bg.png', fit: BoxFit.cover),
          ),

          // 🔹 HERO IMAGE (TOP PART)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: screenHeight * 0.72,
            child: Image.asset(
              'assets/trade_hero.png',
              fit: BoxFit.cover,
              alignment: Alignment.bottomCenter,
            ),
          ),

          // 🔹 WHITE SOFT BLEND (SKY STYLE)
          Positioned(
            top: screenHeight * 0.55,
            left: 0,
            right: 0,
            height: 160,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Color(0x33FFFFFF),
                    Color(0x66FFFFFF),
                    Color(0x99FFFFFF),
                  ],
                  stops: [0.0, 0.35, 0.7, 1.0],
                ),
              ),
            ),
          ),

          // 🔹 CONTENT (TEXT ON TOP OF IMAGES)
          SafeArea(
            child: Column(
              children: [
                // 🌐 LANGUAGE SWITCH
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: const Icon(Icons.language, color: Colors.black),
                    onPressed: () {
                      localeProvider.locale.languageCode == 'en'
                          ? localeProvider.setLocale('hi')
                          : localeProvider.setLocale('en');
                    },
                  ),
                ),

                const Spacer(),

                // 🔹 SCROLLABLE TEXT BLOCK (ON IMAGE)
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        Text(
                          t.translate('welcome_to'),
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontSize: 17,
                          ),
                        ),

                        const SizedBox(height: 6),

                        Text(
                          t.translate('app_name'),
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontSize: 30,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: 12),

                        Text(
                          t.translate('tagline'),
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontSize: 17,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 24),

                        _feature(t.translate('feature_1')),
                        _feature(t.translate('feature_2')),
                        _feature(t.translate('feature_3')),

                        const SizedBox(height: 32),

                        // 🔹 CTA BUTTON
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: () {
                              // TODO: Navigate to Login
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFF8A00),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              elevation: 4,
                            ),
                            child: Text(
                              t.translate('get_started'),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        TextButton(
                          onPressed: () {
                            // TODO: Navigate to Login
                          },
                          child: Text(
                            t.translate('already_account'),
                            style: theme.textTheme.bodyMedium?.copyWith(
                              decoration: TextDecoration.underline,
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
        children: [
          const Icon(Icons.check_circle, color: Color(0xFF22C55E), size: 20),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
