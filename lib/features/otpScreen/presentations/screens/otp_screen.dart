import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:exim_lab/features/login/presentations/states/auth_provider.dart';
import 'package:exim_lab/localization/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:exim_lab/features/dashboard/presentation/screens/dashboard.dart';
import 'package:provider/provider.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String _otp = "";
  int _resendSeconds = 30;
  Timer? _resendTimer;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    super.dispose();
  }

  void _startResendTimer() {
    _resendSeconds = 30;
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        if (_resendSeconds > 0) {
          _resendSeconds--;
        } else {
          timer.cancel();
        }
      });
    });
  }

  void _handleResend() async {
    if (_resendSeconds > 0) return;
    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.sendOtp(authProvider.currentMobile ?? '');
    if (success && mounted) {
      _startResendTimer();
    }
  }

  void _handleVerify() async {
    final t = AppLocalizations.of(context);
    if (_otp.length != 4) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(t.translate('enter_valid_otp'))));
      return;
    }

    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.verifyOtp(_otp);

    if (success && mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
        (route) => false,
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            authProvider.error ?? t.translate('verification_failed'),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = AppLocalizations.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: CustomScrollView(
          physics: const ClampingScrollPhysics(),
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // BACK
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.arrow_back,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // HEADER
                    FadeInDown(
                      duration: const Duration(milliseconds: 800),
                      child: Text(
                        t.translate('verify_number'),
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontSize: 30,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    FadeInDown(
                      delay: const Duration(milliseconds: 200),
                      duration: const Duration(milliseconds: 800),
                      child: Text(
                        t.translate('otp_subtitle'),
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.65,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // OTP FIELD
                    FadeInLeft(
                      delay: const Duration(milliseconds: 400),
                      child: PinCodeTextField(
                        appContext: context,
                        length: 4,
                        keyboardType: TextInputType.number,
                        autoFocus: true,
                        animationType: AnimationType.fade,
                        cursorColor: theme.colorScheme.primary,
                        textStyle: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.underline,
                          fieldHeight: 48,
                          fieldWidth: 42,
                          activeColor: theme.colorScheme.primary,
                          selectedColor: theme.colorScheme.primary,
                          inactiveColor: theme.colorScheme.onSurface.withValues(
                            alpha: 0.3,
                          ),
                        ),
                        onChanged: (value) {
                          setState(() => _otp = value);
                          if (value.length == 4) {
                            _handleVerify();
                          }
                        },
                      ),
                    ),

                    const SizedBox(height: 16),

                    // RESEND
                    FadeInLeft(
                      delay: const Duration(milliseconds: 600),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: _resendSeconds > 0 ? null : _handleResend,
                          child: Text(
                            _resendSeconds > 0
                                ? '${t.translate('resend_otp')} (${_resendSeconds}s)'
                                : t.translate('resend_otp'),
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: _resendSeconds > 0
                                  ? theme.colorScheme.onSurface.withValues(alpha: 0.4)
                                  : theme.colorScheme.primary,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // VERIFY BUTTON
                    Consumer<AuthProvider>(
                      builder: (context, provider, child) {
                        return FadeInUp(
                          delay: const Duration(milliseconds: 800),
                          child: SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: provider.isLoading
                                  ? null
                                  : _handleVerify,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: theme.colorScheme.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                elevation: 0,
                              ),
                              child: provider.isLoading
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : Text(
                                      t.translate('verify'),
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: theme.colorScheme.onPrimary,
                                      ),
                                    ),
                            ),
                          ),
                        );
                      },
                    ),

                    const Spacer(),

                    // FOOTER
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Center(
                        child: FadeInUp(
                          delay: const Duration(milliseconds: 1000),
                          child: Text(
                            t.translate('otp_footer'),
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface.withValues(
                                alpha: 0.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
