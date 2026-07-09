import 'package:flutter/services.dart';
import 'package:exim_lab/core/navigation/app_navigator.dart';
import 'package:exim_lab/features/login/presentations/states/auth_provider.dart';
import 'package:exim_lab/features/otpScreen/presentations/screens/otp_screen.dart';
import 'package:exim_lab/localization/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _handleContinue() async {
    final phone = _phoneController.text.trim();
    final phoneRegex = RegExp(r'^[0-9]{10}$');

    if (!phoneRegex.hasMatch(phone)) {
      final t = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(t.translate('invalid_phone')),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.sendOtp(phone);

    if (success && mounted) {
      AppNavigator.push(context, const OtpScreen());
    } else if (mounted) {
      final t = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProvider.error ?? t.translate('generic_error')),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final t = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: CustomScrollView(
          physics: const ClampingScrollPhysics(),
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                // Single subtle page fade — no per-widget animations
                child: FadeIn(
                  duration: const Duration(milliseconds: 400),
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
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: cs.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        Icons.public_rounded,
                        color: cs.primary,
                        size: 28,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // HEADER — "Welcome to" + brand name
                    Text(
                      t.translate('welcome_to'),
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: cs.onSurface.withValues(alpha: 0.65),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      t.translate('app_name'),
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                        height: 1.1,
                        color: cs.primary,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      t.translate('login_subtitle'),
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: cs.onSurface.withValues(alpha: 0.55),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // PHONE LABEL
                    Text(
                      t.translate('phone_hint'),
                      style: theme.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: cs.onSurface,
                      ),
                    ),

                    const SizedBox(height: 10),

                    // PHONE INPUT — filled rounded
                    Container(
                      decoration: BoxDecoration(
                        color: cs.onSurface.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: cs.outline.withValues(alpha: 0.6),
                        ),
                      ),
                      child: Row(
                        children: [
                          // Country code pill
                          Container(
                            margin: const EdgeInsets.all(6),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: cs.primary.withValues(alpha: 0.10),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '🇮🇳  +91',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: cs.onSurface,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          // Text field
                          Expanded(
                            child: TextField(
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.5,
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(10),
                              ],
                              decoration: InputDecoration(
                                hintText: '00000 00000',
                                hintStyle: theme.textTheme.bodyLarge?.copyWith(
                                  color: cs.onSurface.withValues(alpha: 0.3),
                                  fontSize: 17,
                                  letterSpacing: 1.5,
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                  horizontal: 4,
                                ),
                              ),
                              onSubmitted: (_) => _handleContinue(),
                            ),
                          ),
                          const SizedBox(width: 12),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),

                    // SEND OTP BUTTON
                    Consumer<AuthProvider>(
                      builder: (context, provider, child) {
                        return SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed:
                                provider.isLoading ? null : _handleContinue,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: cs.primary,
                              foregroundColor: cs.onPrimary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 0,
                            ),
                            child: provider.isLoading
                                ? SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                      color: cs.onPrimary,
                                      strokeWidth: 2.5,
                                    ),
                                  )
                                : Text(
                                    t.translate('send_otp'),
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 14),

                    // OTP HELPER (centered under button)
                    Center(
                      child: Text(
                        t.translate('otp_helper'),
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: cs.onSurface.withValues(alpha: 0.5),
                          height: 1.4,
                        ),
                      ),
                    ),

                    const Spacer(),

                    // TRUST BADGES
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: cs.primary.withValues(alpha: 0.04),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: cs.outline.withValues(alpha: 0.4),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _TrustBadge(
                            icon: Icons.verified_user_rounded,
                            label: t.translate('trusted_learners'),
                            color: cs.primary,
                          ),
                          _TrustDivider(color: cs.outline),
                          _TrustBadge(
                            icon: Icons.school_rounded,
                            label: t.translate('trusted_mentors'),
                            color: cs.primary,
                          ),
                          _TrustDivider(color: cs.outline),
                          _TrustBadge(
                            icon: Icons.menu_book_rounded,
                            label: t.translate('trusted_courses'),
                            color: cs.primary,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // FOOTER
                    Center(
                      child: Text(
                        t.translate('terms_privacy'),
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: cs.onSurface.withValues(alpha: 0.4),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Trust badge (icon + label) used in the login footer
// ─────────────────────────────────────────────────────────────
class _TrustBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _TrustBadge({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              color: color,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _TrustDivider extends StatelessWidget {
  final Color color;
  const _TrustDivider({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 34,
      color: color.withValues(alpha: 0.35),
    );
  }
}
