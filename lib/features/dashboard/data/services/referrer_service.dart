import 'dart:io';
import 'package:android_play_install_referrer/android_play_install_referrer.dart';
import 'package:exim_lab/core/services/analytics_service.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:package_info_plus/package_info_plus.dart';

class ReferrerService {
  static const String _prefReferrerLogged = 'referrer_logged_public';

  /// 1. TRACK INSTALL (Called in main.dart)
  /// Fetches referrer details and sends to PUBLIC API immediately.
  Future<void> trackInstallSource() async {
    if (!Platform.isAndroid) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      final isLogged = prefs.getBool(_prefReferrerLogged) ?? false;

      if (isLogged) return; // Already logged

      debugPrint('🔍 Fetching Install Data...');

      // 1. Get Play Store Referrer
      ReferrerDetails? referrerDetails;
      try {
        referrerDetails = await AndroidPlayInstallReferrer.installReferrer;
      } catch (e) {
        debugPrint('⚠️ Play Referrer not available: $e');
      }

      // 2. Get App & Installer Info
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String? installerStore = packageInfo.installerStore;

      final referrerUrl = referrerDetails?.installReferrer;
      final clickTimestamp = referrerDetails?.referrerClickTimestampSeconds;
      final installTimestamp = referrerDetails?.installBeginTimestampSeconds;

      debugPrint('✅ Install Data: Store=$installerStore, Ref=$referrerUrl');

      // Prepare Data
      final Map<String, dynamic> data = {
        'referrer_url': referrerUrl ?? 'unknown',
        'click_timestamp': clickTimestamp ?? 0,
        'install_timestamp': installTimestamp ?? 0,
        'app_version': packageInfo.version,
        'build_number': packageInfo.buildNumber,
        'installer_store': installerStore ?? 'manual_apk', // Detect Sideload
      };

      // logic to identify source if referrer is missing
      if (referrerUrl == null &&
          (installerStore == null || installerStore.isEmpty)) {
        data['utm_source'] = 'manual_sideload';
        data['utm_medium'] = 'apk_sharing';
      }

      // Parse UTM manually
      if (referrerUrl != null) {
        final pairs = referrerUrl.split('&');
        for (final pair in pairs) {
          final parts = pair.split('=');
          if (parts.length == 2) {
            data[parts[0]] = parts[1];
          }
        }
      }

      // 🚀 Log to PUBLIC API (No Token needed)
      await AnalyticsService().logInstallSource(data);

      // Also set user property for Firebase (it caches it until next event)
      if (data.containsKey('utm_source')) {
        await AnalyticsService().setUserProperty(
          name: 'install_source',
          value: data['utm_source'] as String,
        );
      } else if (data['installer_store'] == 'manual_apk') {
        await AnalyticsService().setUserProperty(
          name: 'install_source',
          value: 'manual_apk',
        );
      }

      // Mark as logged
      await prefs.setBool(_prefReferrerLogged, true);
    } catch (e) {
      debugPrint('⚠️ Error tracking install source: $e');
    }
  }
}
