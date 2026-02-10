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
    final success =
        await authProvider.sendOtp(authProvider.currentMobile ?? '');
    if (success && mounted) {
      _startResendTimer();
    }
  }

  void _handleVerify() async {
    final t = AppLocalizations.of(context);
    if (_otp.length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.translate('enter_valid_otp'))),
      );
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
    final cs = theme.colorScheme;
    final t = AppLocalizations.of(context);
    final phone = context.read<AuthProvider>().currentMobile;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: cs.surface,
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
                      icon: Icon(Icons.arrow_back, color: cs.onSurface),
                      padding: EdgeInsets.zero,
                    ),

                    const SizedBox(height: 20),

                    // BRAND MARK
                    FadeInDown(
                      duration: const Duration(milliseconds: 600),
                      child: Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: cs.primary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          Icons.lock_open_rounded,
                          color: cs.primary,
                          size: 28,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // HEADER
                    FadeInDown(
                      delay: const Duration(milliseconds: 100),
                      duration: const Duration(milliseconds: 600),
                      child: Text(
                        t.translate('verify_number'),
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          height: 1.1,
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // SUBTITLE — with phone number
                    FadeInDown(
                      delay: const Duration(milliseconds: 200),
                      duration: const Duration(milliseconds: 600),
                      child: phone != null
                          ? RichText(
                              text: TextSpan(
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  color: cs.onSurface.withValues(alpha: 0.55),
                                ),
                                children: [
                                  const TextSpan(text: 'Code sent to  '),
                                  TextSpan(
                                    text: '+91 $phone',
                                    style: TextStyle(
                                      color: cs.onSurface,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Text(
                              t.translate('otp_subtitle'),
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: cs.onSurface.withValues(alpha: 0.55),
                              ),
                            ),
                    ),

                    const SizedBox(height: 44),

                    // OTP FIELD — box shape
                    FadeInLeft(
                      delay: const Duration(milliseconds: 350),
                      duration: const Duration(milliseconds: 500),
                      child: PinCodeTextField(
                        appContext: context,
                        length: 4,
                        keyboardType: TextInputType.number,
                        autoFocus: true,
                        animationType: AnimationType.scale,
                        cursorColor: cs.primary,
                        textStyle: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: cs.onSurface,
                        ),
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(14),
                          fieldHeight: 60,
                          fieldWidth: 60,
                          activeFillColor: cs.primary.withValues(alpha: 0.08),
                          selectedFillColor:
                              cs.primary.withValues(alpha: 0.08),
                          inactiveFillColor:
                              cs.onSurface.withValues(alpha: 0.04),
                          activeColor: cs.primary,
                          selectedColor: cs.primary,
                          inactiveColor:
                              cs.outline.withValues(alpha: 0.5),
                          borderWidth: 1.5,
                        ),
                        enableActiveFill: true,
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
                      delay: const Duration(milliseconds: 450),
                      duration: const Duration(milliseconds: 500),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed:
                              _resendSeconds > 0 ? null : _handleResend,
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            _resendSeconds > 0
                                ? '${t.translate('resend_otp')} (${_resendSeconds}s)'
                                : t.translate('resend_otp'),
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: _resendSeconds > 0
                                  ? cs.onSurface.withValues(alpha: 0.35)
                                  : cs.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 36),

                    // VERIFY BUTTON
                    Consumer<AuthProvider>(
                      builder: (context, provider, child) {
                        return FadeInUp(
                          delay: const Duration(milliseconds: 550),
                          duration: const Duration(milliseconds: 500),
                          child: SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: provider.isLoading
                                  ? null
                                  : _handleVerify,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: cs.primary,
                                foregroundColor: cs.onPrimary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 0,
                              ),
                              child: provider.isLoading
                                  ? const SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2.5,
                                      ),
                                    )
                                  : Text(
                                      t.translate('verify'),
                                      style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w700,
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
                          delay: const Duration(milliseconds: 700),
                          duration: const Duration(milliseconds: 500),
                          child: Text(
                            t.translate('otp_footer'),
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: cs.onSurface.withValues(alpha: 0.4),
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
