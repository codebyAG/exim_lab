import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:exim_lab/core/theme/theme_provider.dart';
import 'package:exim_lab/localization/locale_provider.dart';
import 'package:sizer/sizer.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final themeProvider = context.watch<ThemeProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Settings'), centerTitle: true),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
        children: [
          // APPEARANCE
          Text(
            'APPEARANCE',
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
            title: const Text('Dark Mode'),
            secondary: const Icon(Icons.dark_mode_outlined),
            contentPadding: EdgeInsets.zero,
          ),

          SizedBox(height: 3.h),

          // LANGUAGE
          Text(
            'LANGUAGE',
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
                title: const Text('Change Language'),
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
            'NOTIFICATIONS',
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
            title: const Text('Push Notifications'),
            secondary: const Icon(Icons.notifications_outlined),
            contentPadding: EdgeInsets.zero,
          ),
          SwitchListTile(
            value: true,
            onChanged: (val) {},
            title: const Text('Email Updates'),
            secondary: const Icon(Icons.email_outlined),
            contentPadding: EdgeInsets.zero,
          ),

          SizedBox(height: 3.h),

          // OTHER
          Text(
            'OTHER',
            style: theme.textTheme.labelMedium?.copyWith(
              color: cs.primary,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          SizedBox(height: 1.h),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About App'),
            subtitle: const Text('Version 1.0.0'),
            contentPadding: EdgeInsets.zero,
            onTap: () {},
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
        return AlertDialog(
          title: const Text('Select Language'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('English'),
                leading: Radio<String>(
                  value: 'en',
                  groupValue: localeProvider.locale.languageCode,
                  onChanged: (val) {
                    localeProvider.setLocale('en');
                    Navigator.pop(context);
                  },
                ),
                onTap: () {
                  localeProvider.setLocale('en');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Hindi'),
                leading: Radio<String>(
                  value: 'hi',
                  groupValue: localeProvider.locale.languageCode,
                  onChanged: (val) {
                    localeProvider.setLocale('hi');
                    Navigator.pop(context);
                  },
                ),
                onTap: () {
                  localeProvider.setLocale('hi');
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
