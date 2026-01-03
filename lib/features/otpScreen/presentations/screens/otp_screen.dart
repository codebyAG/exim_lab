import 'package:exim_lab/core/navigation/app_navigator.dart';
import 'package:exim_lab/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:exim_lab/localization/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});

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
                'Verify your number',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                t.translate('otp_subtitle'),
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: Colors.black.withOpacity(0.65),
                ),
              ),

              const SizedBox(height: 40),

              // 🔹 OTP FIELD
              PinCodeTextField(
                appContext: context,
                length: 6,
                keyboardType: TextInputType.number,
                autoFocus: true,
                animationType: AnimationType.fade,
                cursorColor: const Color(0xFFFF8A00),
                textStyle: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.underline,
                  fieldHeight: 48,
                  fieldWidth: 42,
                  activeColor: const Color(0xFFFF8A00),
                  selectedColor: const Color(0xFFFF8A00),
                  inactiveColor: Colors.grey.shade300,
                ),
                onChanged: (value) {},
              ),

              const SizedBox(height: 16),

              // 🔹 RESEND
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    t.translate('resend_otp'),
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // 🔹 VERIFY
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO → Dashboard
                    AppNavigator.push(context, OnboardingScreen());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF8A00),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    t.translate('verify'),
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
                  t.translate('otp_footer'),
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
