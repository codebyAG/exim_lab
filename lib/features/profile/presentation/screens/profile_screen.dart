import 'package:exim_lab/core/navigation/app_navigator.dart';
import 'package:exim_lab/features/login/presentations/states/auth_provider.dart';
import 'package:exim_lab/features/profile/presentation/screens/settings_screen.dart';
import 'package:exim_lab/features/welcome/presentation/screens/welcome_screen.dart';
import 'package:exim_lab/features/profile/presentation/screens/update_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:exim_lab/localization/app_localization.dart';
import 'package:url_launcher/url_launcher.dart';

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
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.user;
    final t = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        title: Text(t.translate('profile_title')),
        centerTitle: true,
        backgroundColor: cs.surface,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
        child: Column(
          children: [
            // USER INFO CARD
            Container(
              padding: EdgeInsets.all(3.h),
              decoration: BoxDecoration(
                color: cs.primaryContainer,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: cs.primary, // Solid background for contrast
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: ClipOval(
                      child:
                          (user?.avatarUrl != null &&
                              user!.avatarUrl!.isNotEmpty)
                          ? Image.network(
                              user!.avatarUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Center(
                                  child: Icon(
                                    Icons.person,
                                    size: 35,
                                    color: Colors.white,
                                  ),
                                );
                              },
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: CircularProgressIndicator(
                                          value:
                                              loadingProgress
                                                      .expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    loadingProgress
                                                        .expectedTotalBytes!
                                              : null,
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      ),
                                    );
                                  },
                            )
                          : const Center(
                              child: Icon(
                                Icons.person,
                                size: 35,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.name ?? t.translate('guest_user'),
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: cs.onPrimaryContainer,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          user?.email ??
                              user?.mobile ??
                              t.translate('no_email'),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: cs.onPrimaryContainer.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      AppNavigator.push(
                        context,
                        UpdateProfileScreen(user: user),
                      );
                    },
                    icon: Icon(Icons.edit, color: cs.onPrimaryContainer),
                  ),
                ],
              ),
            ),
            SizedBox(height: 3.h),

            // STATS ROW
            if (user?.stats != null)
              Row(
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
            SizedBox(height: 4.h),

            // MENU OPTIONS
            _ProfileOption(
              icon: Icons.person_outline_rounded,
              title: t.translate('menu_my_details'),
              onTap: () {},
            ),
            _ProfileOption(
              icon: Icons.settings_outlined,
              title: t.translate('menu_settings'),
              onTap: () {
                AppNavigator.push(context, const SettingsScreen());
              },
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

            SizedBox(height: 2.h),

            // LOGOUT
            _ProfileOption(
              icon: Icons.logout_rounded,
              title: t.translate('menu_logout'),
              isDestructive: true,
              onTap: () => _handleLogout(context),
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
            _buildContactRow(
              context,
              Icons.phone,
              t.translate('phone'),
              '+91 98717 69042',
            ),
            SizedBox(height: 1.5.h),
            _buildContactRow(
              context,
              Icons.email,
              t.translate('email'),
              'info@siiea.in',
            ),
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
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, color: theme.colorScheme.primary, size: 20),
        SizedBox(width: 3.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
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
        title: Text(
          t.translate('logout_confirm_title') ?? 'Logout',
        ), // Default fallback if key missing
        content: Text(t.translate('logout_confirm_msg')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(t.translate('cancel')),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx); // Close dialog

              // Clear session
              await context.read<AuthProvider>().logout();

              // Navigate to Welcome Screen (Clear stack)
              if (context.mounted) {
                AppNavigator.replace(context, const WelcomeScreen());
              }
            },
            child: Text(
              t.translate('menu_logout'),
              style: const TextStyle(color: Colors.red),
            ),
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
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            SizedBox(height: 1.h),
            Text(
              value,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            SizedBox(height: 0.5.h),
            Text(
              label,
              textAlign: TextAlign.center,
              style: theme.textTheme.labelMedium?.copyWith(
                color: cs.onSurfaceVariant,
                fontSize: 10.sp,
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
            color: isDestructive
                ? cs.errorContainer
                : cs.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: isDestructive ? cs.error : cs.primary,
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          size: 16,
          color: color.withValues(alpha: 0.5),
        ),
      ),
    );
  }
}
