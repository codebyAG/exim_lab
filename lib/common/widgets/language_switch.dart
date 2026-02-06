import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:exim_lab/localization/locale_provider.dart';

class LanguageSwitch extends StatelessWidget {
  const LanguageSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = context.watch<LocaleProvider>();
    final isEnglish = localeProvider.locale.languageCode == 'en';

    return GestureDetector(
      onTap: () {
        localeProvider.setLocale(isEnglish ? 'hi' : 'en');
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withValues(alpha: 0.4)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.language, size: 16, color: Colors.white),
            const SizedBox(width: 6),
            Text(
              isEnglish ? 'EN' : 'HI',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
