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

    return Scaffold(
      appBar: AppBar(
        title: Text(t.translate('settings_title')),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
        children: [
          // APPEARANCE
          Text(
            t.translate('appearance_section'),
            style: theme.textTheme.labelMedium?.copyWith(
              color: cs.primary,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          SizedBox(height: 1.h),
          SwitchListTile(
            value: themeProvider.themeMode == ThemeMode.dark,
            onChanged: (val) {
              val ? themeProvider.setDark() : themeProvider.setLight();
            },
            title: Text(t.translate('dark_mode')),
            secondary: const Icon(Icons.dark_mode_outlined),
            contentPadding: EdgeInsets.zero,
          ),

          SizedBox(height: 3.h),

          // LANGUAGE
          Text(
            t.translate('language_section'),
            style: theme.textTheme.labelMedium?.copyWith(
              color: cs.primary,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          SizedBox(height: 1.h),
          Consumer<LocaleProvider>(
            builder: (context, localeProvider, child) {
              final currentLang = localeProvider.locale.languageCode == 'hi'
                  ? 'Hindi'
                  : 'English';
              return ListTile(
                leading: const Icon(Icons.language),
                title: Text(t.translate('change_language')),
                subtitle: Text(currentLang),
                contentPadding: EdgeInsets.zero,
                trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                onTap: () {
                  _showLanguageDialog(context, localeProvider);
                },
              );
            },
          ),

          SizedBox(height: 3.h),

          // NOTIFICATIONS
          Text(
            t.translate('notifications_section'),
            style: theme.textTheme.labelMedium?.copyWith(
              color: cs.primary,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          SizedBox(height: 1.h),
          SwitchListTile(
            value: true,
            onChanged: (val) {},
            title: Text(t.translate('push_notifications')),
            secondary: const Icon(Icons.notifications_outlined),
            contentPadding: EdgeInsets.zero,
          ),
          SwitchListTile(
            value: true,
            onChanged: (val) {},
            title: Text(t.translate('email_updates')),
            secondary: const Icon(Icons.email_outlined),
            contentPadding: EdgeInsets.zero,
          ),

          SizedBox(height: 3.h),

          // OTHER
          Text(
            t.translate('other_section'),
            style: theme.textTheme.labelMedium?.copyWith(
              color: cs.primary,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          SizedBox(height: 1.h),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(t.translate('about_app')),
            subtitle: Text('${t.translate('version')} 1.0.0'),
            contentPadding: EdgeInsets.zero,
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'Exim Lab',
                applicationVersion: '1.0.0',
                applicationIcon: const Icon(Icons.school_rounded, size: 50),
                children: [const Text('Developed by SIIEA')],
              );
            },
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog(
    BuildContext context,
    LocaleProvider localeProvider,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        final t = AppLocalizations.of(context);
        return AlertDialog(
          title: Text(t.translate('select_language')),
          content: RadioGroup<String>(
            groupValue: localeProvider.locale.languageCode,
            onChanged: (val) {
              if (val != null) {
                localeProvider.setLocale(val);
                Navigator.pop(context);
              }
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: const Text('English'),
                  leading: const Radio<String>(value: 'en'),
                  onTap: () {
                    localeProvider.setLocale('en');
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Text('Hindi'),
                  leading: const Radio<String>(value: 'hi'),
                  onTap: () {
                    localeProvider.setLocale('hi');
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
