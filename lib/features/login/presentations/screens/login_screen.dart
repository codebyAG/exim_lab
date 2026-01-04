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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 BACK
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
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
                  color: Colors.black.withOpacity(0.65),
                ),
              ),

              const SizedBox(height: 40),

              // 🔹 PHONE LABEL
              Text(
                t.translate('phone_hint'),
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 8),

              // 🔹 INPUT
              TextField(
                keyboardType: TextInputType.phone,
                style: const TextStyle(fontSize: 18),
                decoration: InputDecoration(
                  prefixText: '+91 ',
                  hintText: 'XXXXXXXXXX',
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFFF8A00), width: 2),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // 🔹 HELPER TEXT
              Text(
                t.translate('otp_info'),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.black.withOpacity(0.55),
                ),
              ),

              const SizedBox(height: 32),

              // 🔹 CONTINUE
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO → OTP

                    AppNavigator.push(context, OtpScreen());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF8A00),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    t.translate('continue'),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const Spacer(),

              // 🔹 FOOTER
              Center(
                child: Text(
                  'By continuing, you agree to our Terms & Privacy Policy',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.black.withOpacity(0.5),
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
