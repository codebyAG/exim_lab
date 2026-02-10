import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:exim_lab/core/theme/theme_provider.dart';
import 'package:exim_lab/localization/locale_provider.dart';
import 'package:exim_lab/localization/app_localization.dart';
import 'package:sizer/sizer.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final themeProvider = context.watch<ThemeProvider>();
    final t = AppLocalizations.of(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;

    return Scaffold(
      backgroundColor: cs.surfaceContainerLowest,
      appBar: AppBar(
        title: Text(t.translate('settings_title')),
        centerTitle: true,
        backgroundColor: cs.surfaceContainerLowest,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(5.w, 1.h, 5.w, 2.h),
              children: [
                // APPEARANCE
                FadeInUp(
                  duration: const Duration(milliseconds: 400),
                  child: _SectionLabel(t.translate('appearance_section')),
                ),
                FadeInUp(
                  duration: const Duration(milliseconds: 400),
                  delay: const Duration(milliseconds: 60),
                  child: _SettingsCard(
                    children: [
                      _SettingsTile(
                        icon: isDark
                            ? Icons.dark_mode_rounded
                            : Icons.light_mode_rounded,
                        iconColor:
                            isDark ? Colors.indigo : Colors.amber.shade700,
                        title: t.translate('dark_mode'),
                        trailing: Switch(
                          value: isDark,
                          onChanged: (val) => val
                              ? themeProvider.setDark()
                              : themeProvider.setLight(),
                          activeTrackColor: cs.primary,
                          activeThumbColor: cs.onPrimary,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 2.h),

                // LANGUAGE
                FadeInUp(
                  duration: const Duration(milliseconds: 400),
                  delay: const Duration(milliseconds: 120),
                  child: _SectionLabel(t.translate('language_section')),
                ),
                FadeInUp(
                  duration: const Duration(milliseconds: 400),
                  delay: const Duration(milliseconds: 180),
                  child: Consumer<LocaleProvider>(
                    builder: (context, localeProvider, _) {
                      final isHindi =
                          localeProvider.locale.languageCode == 'hi';
                      return _SettingsCard(
                        children: [
                          _SettingsTile(
                            icon: Icons.language_rounded,
                            iconColor: Colors.teal,
                            title: t.translate('change_language'),
                            subtitle: isHindi ? 'हिन्दी' : 'English',
                            trailing: Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 14,
                              color: cs.onSurfaceVariant,
                            ),
                            onTap: () =>
                                _showLanguageDialog(context, localeProvider),
                          ),
                        ],
                      );
                    },
                  ),
                ),

                SizedBox(height: 2.h),

                // NOTIFICATIONS
                FadeInUp(
                  duration: const Duration(milliseconds: 400),
                  delay: const Duration(milliseconds: 240),
                  child: _SectionLabel(t.translate('notifications_section')),
                ),
                FadeInUp(
                  duration: const Duration(milliseconds: 400),
                  delay: const Duration(milliseconds: 300),
                  child: _SettingsCard(
                    children: [
                      _SettingsTile(
                        icon: Icons.notifications_outlined,
                        iconColor: Colors.deepOrange,
                        title: t.translate('push_notifications'),
                        trailing: Switch(
                          value: true,
                          onChanged: (_) {},
                          activeTrackColor: cs.primary,
                          activeThumbColor: cs.onPrimary,
                        ),
                      ),
                      Divider(
                        height: 1,
                        thickness: 1,
                        indent: 56,
                        color: cs.outlineVariant.withValues(alpha: 0.3),
                      ),
                      _SettingsTile(
                        icon: Icons.email_outlined,
                        iconColor: Colors.blue,
                        title: t.translate('email_updates'),
                        trailing: Switch(
                          value: true,
                          onChanged: (_) {},
                          activeTrackColor: cs.primary,
                          activeThumbColor: cs.onPrimary,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 2.h),

                // OTHER
                FadeInUp(
                  duration: const Duration(milliseconds: 400),
                  delay: const Duration(milliseconds: 360),
                  child: _SectionLabel(t.translate('other_section')),
                ),
                FadeInUp(
                  duration: const Duration(milliseconds: 400),
                  delay: const Duration(milliseconds: 420),
                  child: _SettingsCard(
                    children: [
                      _SettingsTile(
                        icon: Icons.info_outline_rounded,
                        iconColor: Colors.blueGrey,
                        title: t.translate('about_app'),
                        subtitle: '${t.translate('version')} 1.0.0',
                        trailing: Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 14,
                          color: cs.onSurfaceVariant,
                        ),
                        onTap: () => showAboutDialog(
                          context: context,
                          applicationName: 'Exim Lab',
                          applicationVersion: '1.0.0',
                          applicationIcon:
                              const Icon(Icons.school_rounded, size: 50),
                          children: [const Text('Developed by SIIEA')],
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 2.h),
              ],
            ),
          );
  }

  void _showLanguageDialog(
      BuildContext context, LocaleProvider localeProvider) {
    final t = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(t.translate('select_language')),
          content: RadioGroup<String>(
            groupValue: localeProvider.locale.languageCode,
            onChanged: (val) {
              if (val != null) {
                localeProvider.setLocale(val);
                Navigator.pop(ctx);
              }
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                RadioListTile<String>(
                  title: Text('English'),
                  value: 'en',
                ),
                RadioListTile<String>(
                  title: Text('हिन्दी'),
                  value: 'hi',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ── PRIVATE WIDGETS ──────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

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

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;
  const _SettingsCard({required this.children});

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

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final Widget trailing;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    this.subtitle,
    required this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
      title: Text(
        title,
        style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style:
                  theme.textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant),
            )
          : null,
      trailing: trailing,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }
}
