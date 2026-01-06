import 'package:exim_lab/core/navigation/app_navigator.dart';
import 'package:exim_lab/features/login/presentations/screens/login_screen.dart';
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
          // 🔹 HERO IMAGE (TOP PART)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: screenHeight,
            child: Image.asset(
              'assets/welcome_bg.jpg',
              fit: BoxFit.cover,
              alignment: Alignment.bottomCenter,
            ),
          ),
          // 🌙 DARK MODE OVERLAY (ONLY FOR DARK THEME)
          // 🌙 DARK MODE OVERLAY (ONLY IMAGE AREA)
          if (theme.brightness == Brightness.dark)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: screenHeight,
              child: Container(color: Colors.black.withOpacity(0.60)),
            ),

          // 🔹 CONTENT (TEXT ON TOP OF IMAGES)
          SafeArea(
            child: Column(
              children: [
                // 🌐 LANGUAGE SWITCH
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: Icon(
                      Icons.language,
                      color: theme.colorScheme.onSurface,
                    ),
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

                        _feature(t.translate('feature_1'), context),
                        _feature(t.translate('feature_2'), context),
                        _feature(t.translate('feature_3'), context),

                        const SizedBox(height: 32),

                        // 🔹 CTA BUTTON
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: () {
                              // TODO: Navigate to Login
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

                        const SizedBox(height: 16),

                        TextButton(
                          onPressed: () {
                            // TODO: Navigate to Login

                            AppNavigator.push(context, LoginScreen());
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

  Widget _feature(String text, BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle,
            color: theme.colorScheme.secondary,
            size: 20,
          ),

          const SizedBox(width: 12),
          Flexible(
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
