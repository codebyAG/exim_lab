import 'package:exim_lab/common/widgets/language_switch.dart';
import 'package:exim_lab/common/widgets/theme_switch_button.dart';
import 'package:exim_lab/core/navigation/app_navigator.dart';
import 'package:exim_lab/features/login/presentations/screens/login_screen.dart';
import 'package:exim_lab/localization/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:exim_lab/localization/locale_provider.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  late final ImageProvider _bgImage;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bgImage = const AssetImage('assets/welcome_bg.png');
    precacheImage(_bgImage, context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = AppLocalizations.of(context);
    final localeProvider = context.watch<LocaleProvider>();

    return Scaffold(
      body: Stack(
        children: [
          // 🔹 BACKGROUND IMAGE
          Positioned.fill(
            child: Image(image: _bgImage, fit: BoxFit.cover),
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
                          Colors.black.withOpacity(0.65),
                          Colors.black.withOpacity(0.65),
                          Colors.black.withOpacity(0.65),
                        ]
                      : [
                          Colors.black.withOpacity(0.35),
                          Colors.black.withOpacity(0.25),
                          Colors.black.withOpacity(0.15),
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
                Spacer(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        Text(
                          t.translate('welcome_to'),
                          style: const TextStyle(
                            fontSize: 17,
                            color: Colors.white,
                          ),
                        ),

                        const SizedBox(height: 6),

                        Text(
                          t.translate('app_name'),
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),

                        const SizedBox(height: 12),

                        Text(
                          t.translate('tagline'),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 17,
                            color: Colors.white,
                          ),
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
