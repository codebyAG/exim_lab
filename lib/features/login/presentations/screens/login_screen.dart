import 'package:exim_lab/core/navigation/app_navigator.dart';
import 'package:exim_lab/features/otpScreen/presentations/screens/otp_screen.dart';
import 'package:exim_lab/localization/app_localization.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 BACK
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.arrow_back,
                  color: theme.colorScheme.onBackground,
                ),
              ),

              const SizedBox(height: 24),

              // 🔹 HEADER
              Text(
                t.translate('welcome_back'),
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                t.translate('login_subtitle'),
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onBackground.withOpacity(0.65),
                ),
              ),

              const SizedBox(height: 40),

              // 🔹 PHONE LABEL
              Text(
                t.translate('phone_hint'),
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.onBackground,
                ),
              ),

              const SizedBox(height: 8),

              // 🔹 INPUT
              TextField(
                keyboardType: TextInputType.phone,
                style: theme.textTheme.bodyLarge?.copyWith(fontSize: 18),
                decoration: InputDecoration(
                  prefixText: '+91 ',
                  hintText: 'XXXXXXXXXX',
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: theme.dividerColor),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: theme.colorScheme.primary,
                      width: 2,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // 🔹 HELPER TEXT
              Text(
                t.translate('otp_info'),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onBackground.withOpacity(0.55),
                ),
              ),

              const SizedBox(height: 32),

              // 🔹 CONTINUE BUTTON
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    AppNavigator.push(context, const OtpScreen());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    t.translate('continue'),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
                ),
              ),

              const Spacer(),

              // 🔹 FOOTER
              Center(
                child: Text(
                  t.translate('terms_privacy'),
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onBackground.withOpacity(0.5),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
