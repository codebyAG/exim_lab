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
      backgroundColor: cs.surface,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // GRADIENT HEADER
            FadeIn(
              duration: const Duration(milliseconds: 600),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(5.w, topPad + 12, 5.w, 3.h),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [cs.primary, cs.primary.withValues(alpha: 0.82)],
                  ),
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(32),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: cs.primary.withValues(alpha: 0.30),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // BACK + TITLE ROW
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(
                            Icons.arrow_back_rounded,
                            color: Colors.white,
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                        const Spacer(),
                        Text(
                          t.translate('profile_title'),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Spacer(),
                        const SizedBox(width: 40),
                      ],
                    ),

                    SizedBox(height: 2.h),

                    // AVATAR
                    Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.15),
                                blurRadius: 16,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 44,
                            backgroundColor: Colors.white,
                            child: ClipOval(
                              child:
                                  (user?.avatarUrl != null &&
                                      user!.avatarUrl!.isNotEmpty)
                                  ? CachedNetworkImage(
                                      imageUrl: user.avatarUrl!,
                                      fit: BoxFit.cover,
                                      width: 88,
                                      height: 88,
                                      errorWidget: (context, url, error) =>
                                          Icon(
                                        Icons.person,
                                        size: 44,
                                        color: cs.primary,
                                      ),
                                      placeholder: (context, url) =>
                                          const SizedBox(),
                                    )
                                  : Icon(
                                      Icons.person,
                                      size: 44,
                                      color: cs.primary,
                                    ),
                            ),
                          ),
                        ),
                        // EDIT BADGE
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: GestureDetector(
                            onTap: () => AppNavigator.push(
                              context,
                              UpdateProfileScreen(user: user),
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
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
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    SizedBox(height: 4),

                    // EMAIL / PHONE
                    Text(
                      user?.email ?? user?.mobile ?? '',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.75),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
              child: Column(
                children: [
                  // STATS ROW
                  if (user?.stats != null)
                    FadeInUp(
                      duration: const Duration(milliseconds: 500),
                      delay: const Duration(milliseconds: 100),
                      child: Row(
                        children: [
                          _StatsCard(
                            label: t.translate('stats_active'),
                            value: '${user?.stats?.activeCourses ?? 0}',
                            icon: Icons.play_circle_outline_rounded,
                            color: Colors.blue,
                          ),
                          SizedBox(width: 3.w),
                          _StatsCard(
                            label: t.translate('stats_completed'),
                            value: '${user?.stats?.completedCourses ?? 0}',
                            icon: Icons.check_circle_outline_rounded,
                            color: Colors.green,
                          ),
                          SizedBox(width: 3.w),
                          _StatsCard(
                            label: t.translate('stats_quizzes'),
                            value: '${user?.stats?.quizzesTaken ?? 0}',
                            icon: Icons.quiz_outlined,
                            color: Colors.orange,
                          ),
                        ],
                      ),
                    ),

                  SizedBox(height: 3.h),

                  // MENU OPTIONS
                  FadeInUp(
                    duration: const Duration(milliseconds: 500),
                    delay: const Duration(milliseconds: 200),
                    child: Column(
                      children: [
                        _ProfileOption(
                          icon: Icons.person_outline_rounded,
                          title: t.translate('menu_my_details'),
                          onTap: () => AppNavigator.push(
                            context,
                            UpdateProfileScreen(user: user),
                          ),
                        ),
                        _ProfileOption(
                          icon: Icons.settings_outlined,
                          title: t.translate('menu_settings'),
                          onTap: () =>
                              AppNavigator.push(context, const SettingsScreen()),
                        ),
                        _ProfileOption(
                          icon: Icons.help_outline_rounded,
                          title: t.translate('menu_help'),
                          onTap: () => _showHelpSupportDialog(context),
                        ),
                        _ProfileOption(
                          icon: Icons.privacy_tip_outlined,
                          title: t.translate('menu_privacy'),
                          onTap: _launchPrivacyPolicy,
                        ),

                        SizedBox(height: 1.5.h),

                        _ProfileOption(
                          icon: Icons.logout_rounded,
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

class _StatsCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatsCard({
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
        padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 1.w),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.20)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            SizedBox(height: 1.h),
            Text(value,
                style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold, color: color)),
            SizedBox(height: 0.5.h),
            Text(label,
                textAlign: TextAlign.center,
                style: theme.textTheme.labelMedium?.copyWith(
                    color: cs.onSurfaceVariant, fontSize: 10.sp)),
          ],
        ),
      ),
    );
  }
}

class _ProfileOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isDestructive;

  const _ProfileOption({
    required this.icon,
    required this.title,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final color = isDestructive ? cs.error : cs.onSurface;

    return Container(
      margin: EdgeInsets.only(bottom: 1.5.h),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.4)),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDestructive ? cs.errorContainer : cs.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: isDestructive ? cs.error : cs.primary,
            size: 20,
          ),
        ),
        title: Text(title,
            style: theme.textTheme.bodyLarge?.copyWith(
                color: color, fontWeight: FontWeight.w600)),
        trailing: Icon(Icons.arrow_forward_ios_rounded,
            size: 16, color: color.withValues(alpha: 0.5)),
      ),
    );
  }
}
