import 'package:exim_lab/core/navigation/app_navigator.dart';
import 'package:exim_lab/features/login/presentations/states/auth_provider.dart';
import 'package:exim_lab/features/profile/presentation/screens/settings_screen.dart';
import 'package:exim_lab/features/welcome/presentation/screens/welcome_screen.dart';
import 'package:exim_lab/features/profile/presentation/screens/update_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:exim_lab/core/services/analytics_service.dart';
import 'package:sizer/sizer.dart';
import 'package:exim_lab/localization/app_localization.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:animate_do/animate_do.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthProvider>().fetchProfile();
      context.read<AnalyticsService>().logProfileView();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.user;
    final t = AppLocalizations.of(context);
    final topPad = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: cs.surfaceContainerLowest,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ── GRADIENT HEADER ──────────────────────────────────────
            FadeIn(
              duration: const Duration(milliseconds: 500),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Background gradient container
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.fromLTRB(5.w, topPad + 8, 5.w, 5.h),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          cs.primary,
                          cs.primary.withValues(alpha: 0.75),
                        ],
                      ),
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(36),
                      ),
                    ),
                    child: Column(
                      children: [
                        // BACK + SETTINGS ROW
                        Row(
                          children: [
                            _HeaderIconBtn(
                              icon: Icons.arrow_back_rounded,
                              onTap: () => Navigator.pop(context),
                            ),
                            const Spacer(),
                            Text(
                              t.translate('profile_title'),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.2,
                              ),
                            ),
                            const Spacer(),
                            _HeaderIconBtn(
                              icon: Icons.settings_outlined,
                              onTap: () => AppNavigator.push(
                                context,
                                const SettingsScreen(),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 2.5.h),

                        // AVATAR
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            // Glow ring
                            Container(
                              width: 106,
                              height: 106,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.35),
                                  width: 3,
                                ),
                              ),
                            ),
                            // Avatar
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: Colors.white, width: 2.5),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.18),
                                    blurRadius: 18,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: CircleAvatar(
                                radius: 46,
                                backgroundColor: Colors.white,
                                child: ClipOval(
                                  child: (user?.avatarUrl != null &&
                                          user!.avatarUrl!.isNotEmpty)
                                      ? CachedNetworkImage(
                                          imageUrl: user.avatarUrl!,
                                          fit: BoxFit.cover,
                                          width: 92,
                                          height: 92,
                                          errorWidget:
                                              (context, url, error) => Icon(
                                            Icons.person,
                                            size: 46,
                                            color: cs.primary,
                                          ),
                                          placeholder: (context, url) =>
                                              const SizedBox(),
                                        )
                                      : Icon(
                                          Icons.person,
                                          size: 46,
                                          color: cs.primary,
                                        ),
                                ),
                              ),
                            ),
                            // Edit badge
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: GestureDetector(
                                onTap: () => AppNavigator.push(
                                  context,
                                  UpdateProfileScreen(user: user),
                                ),
                                child: Container(
                                  padding: const EdgeInsets.all(7),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            Colors.black.withValues(alpha: 0.12),
                                        blurRadius: 6,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.edit_rounded,
                                    size: 14,
                                    color: cs.primary,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 1.5.h),

                        // NAME
                        Text(
                          user?.name ?? t.translate('guest_user'),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.2,
                          ),
                        ),

                        const SizedBox(height: 5),

                        // EMAIL / PHONE
                        if ((user?.email ?? user?.mobile ?? '').isNotEmpty)
                          Text(
                            user?.email ?? user?.mobile ?? '',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.75),
                              fontSize: 13,
                            ),
                          ),

                        const SizedBox(height: 10),

                        // MEMBER CHIP
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.30),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.verified_rounded,
                                  size: 13,
                                  color: Colors.white.withValues(alpha: 0.90)),
                              const SizedBox(width: 5),
                              Text(
                                t.translate('member_badge'),
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.90),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ── BODY ─────────────────────────────────────────────────
            Padding(
              padding: EdgeInsets.fromLTRB(5.w, 3.h, 5.w, 2.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // STATS ROW — always shown
                  FadeInUp(
                    duration: const Duration(milliseconds: 450),
                    delay: const Duration(milliseconds: 80),
                    child: Row(
                      children: [
                        _StatChip(
                          label: t.translate('stats_active'),
                          value: '${user?.stats?.activeCourses ?? 0}',
                          icon: Icons.play_circle_outline_rounded,
                          color: Colors.blue,
                        ),
                        SizedBox(width: 3.w),
                        _StatChip(
                          label: t.translate('stats_completed'),
                          value: '${user?.stats?.completedCourses ?? 0}',
                          icon: Icons.check_circle_outline_rounded,
                          color: Colors.green,
                        ),
                        SizedBox(width: 3.w),
                        _StatChip(
                          label: t.translate('stats_quizzes'),
                          value: '${user?.stats?.quizzesTaken ?? 0}',
                          icon: Icons.quiz_outlined,
                          color: Colors.orange,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 3.h),

                  // ACCOUNT SECTION
                  FadeInUp(
                    duration: const Duration(milliseconds: 450),
                    delay: const Duration(milliseconds: 140),
                    child: _SectionHeader(t.translate('section_account')),
                  ),
                  FadeInUp(
                    duration: const Duration(milliseconds: 450),
                    delay: const Duration(milliseconds: 180),
                    child: _MenuCard(
                      children: [
                        _ProfileOption(
                          icon: Icons.person_outline_rounded,
                          iconColor: cs.primary,
                          title: t.translate('menu_my_details'),
                          onTap: () => AppNavigator.push(
                            context,
                            UpdateProfileScreen(user: user),
                          ),
                        ),
                        _Divider(),
                        _ProfileOption(
                          icon: Icons.settings_outlined,
                          iconColor: Colors.blueGrey,
                          title: t.translate('menu_settings'),
                          onTap: () => AppNavigator.push(
                              context, const SettingsScreen()),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 2.5.h),

                  // SUPPORT SECTION
                  FadeInUp(
                    duration: const Duration(milliseconds: 450),
                    delay: const Duration(milliseconds: 240),
                    child: _SectionHeader(t.translate('section_support')),
                  ),
                  FadeInUp(
                    duration: const Duration(milliseconds: 450),
                    delay: const Duration(milliseconds: 280),
                    child: _MenuCard(
                      children: [
                        _ProfileOption(
                          icon: Icons.help_outline_rounded,
                          iconColor: Colors.teal,
                          title: t.translate('menu_help'),
                          onTap: () => _showHelpSupportDialog(context),
                        ),
                        _Divider(),
                        _ProfileOption(
                          icon: Icons.privacy_tip_outlined,
                          iconColor: Colors.indigo,
                          title: t.translate('menu_privacy'),
                          onTap: _launchPrivacyPolicy,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 2.5.h),

                  // LOGOUT
                  FadeInUp(
                    duration: const Duration(milliseconds: 450),
                    delay: const Duration(milliseconds: 340),
                    child: _MenuCard(
                      children: [
                        _ProfileOption(
                          icon: Icons.logout_rounded,
                          iconColor: cs.error,
                          title: t.translate('menu_logout'),
                          isDestructive: true,
                          onTap: () => _handleLogout(context),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 2.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showHelpSupportDialog(BuildContext context) {
    final t = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(t.translate('contact_us')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildContactRow(context, Icons.phone, t.translate('phone'),
                '+91 98717 69042'),
            SizedBox(height: 1.5.h),
            _buildContactRow(
                context, Icons.email, t.translate('email'), 'info@siiea.in'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(t.translate('cancel')),
          ),
        ],
      ),
    );
  }

  Widget _buildContactRow(
      BuildContext context, IconData icon, String label, String value) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, color: theme.colorScheme.primary, size: 20),
        SizedBox(width: 3.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: theme.textTheme.labelSmall
                    ?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            Text(value,
                style: theme.textTheme.bodyMedium
                    ?.copyWith(fontWeight: FontWeight.w600)),
          ],
        ),
      ],
    );
  }

  Future<void> _launchPrivacyPolicy() async {
    final Uri url = Uri.parse('https://www.siiea.in/privacy-policy/');
    if (!await launchUrl(url)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not launch privacy policy')),
        );
      }
    }
  }

  void _handleLogout(BuildContext context) {
    final t = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(t.translate('logout_confirm_title')),
        content: Text(t.translate('logout_confirm_msg')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(t.translate('cancel')),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await context.read<AuthProvider>().logout();
              if (context.mounted) {
                AppNavigator.replace(context, const WelcomeScreen());
              }
            },
            child: Text(t.translate('menu_logout'),
                style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

// ── PRIVATE WIDGETS ──────────────────────────────────────────────────────────

class _HeaderIconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _HeaderIconBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.18),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
        ),
        child: Icon(icon, color: Colors.white, size: 18),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String text;
  const _SectionHeader(this.text);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(left: 2, bottom: 10),
      child: Text(
        text.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: cs.onSurfaceVariant,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.1,
            ),
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final List<Widget> children;
  const _MenuCard({required this.children});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.35)),
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(mainAxisSize: MainAxisSize.min, children: children),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Divider(
      height: 1,
      thickness: 1,
      indent: 56,
      color: cs.outlineVariant.withValues(alpha: 0.3),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatChip({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 1.8.h, horizontal: 1.w),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.20)),
          boxShadow: [
            BoxShadow(
              color: cs.shadow.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 18),
            ),
            SizedBox(height: 0.8.h),
            Text(
              value,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
            SizedBox(height: 0.3.h),
            Text(
              label,
              textAlign: TextAlign.center,
              style: theme.textTheme.labelSmall?.copyWith(
                color: cs.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileOption extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final VoidCallback onTap;
  final bool isDestructive;

  const _ProfileOption({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final textColor = isDestructive ? cs.error : cs.onSurface;
    final bgColor = isDestructive
        ? cs.error.withValues(alpha: 0.10)
        : iconColor.withValues(alpha: 0.10);

    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: isDestructive ? cs.error : iconColor,
          size: 19,
        ),
      ),
      title: Text(
        title,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios_rounded,
        size: 14,
        color: textColor.withValues(alpha: 0.35),
      ),
    );
  }
}
