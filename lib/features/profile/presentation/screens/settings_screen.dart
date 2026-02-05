import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

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
            value: false, // TODO: Link to ThemeProvider
            onChanged: (val) {},
            title: const Text('Dark Mode'),
            secondary: const Icon(Icons.dark_mode_outlined),
            contentPadding: EdgeInsets.zero,
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
}
