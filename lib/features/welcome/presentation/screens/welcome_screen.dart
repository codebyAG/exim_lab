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
          // 🔹 FULL PAGE BACKGROUND (SKY)
          Positioned.fill(
            child: Image.asset('assets/welcome_bg.png', fit: BoxFit.cover),
          ),

          // 🔹 CONTENT
          SafeArea(
            child: Column(
              children: [
                // 🔹 HERO SECTION (TOP 55%)
                Stack(
                  children: [
                    Image.asset(
                      'assets/trade_hero.png',
                      height: screenHeight * 0.40,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    // 🔹 SOFT BOTTOM SHADOW / BLEND (IMPORTANT)
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.10), // very soft
                            ],
                          ),
                        ),
                      ),
                    ),
                    // 🌐 LANGUAGE SWITCH
                    Positioned(
                      top: 12,
                      right: 12,
                      child: IconButton(
                        icon: const Icon(Icons.language, color: Colors.white),
                        onPressed: () {
                          localeProvider.locale.languageCode == 'en'
                              ? localeProvider.setLocale('hi')
                              : localeProvider.setLocale('en');
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // 🔹 TEXT CONTENT
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      Text(
                        t.translate('welcome_to'),
                        style: theme.textTheme.bodyLarge,
                      ),

                      const SizedBox(height: 6),

                      Text(
                        t.translate('app_name'),
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 12),

                      Text(
                        t.translate('tagline'),
                        style: theme.textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 24),

                      _feature(t.translate('feature_1')),
                      _feature(t.translate('feature_2')),
                      _feature(t.translate('feature_3')),
                    ],
                  ),
                ),

                const Spacer(),

                // 🔹 CTA + LOGIN
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () {},
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
                        onPressed: () {},
                        child: Text(
                          t.translate('already_account'),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),
                    ],
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
              style: const TextStyle(fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
}
