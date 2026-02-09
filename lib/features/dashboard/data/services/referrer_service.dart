import 'dart:io';
import 'package:android_play_install_referrer/android_play_install_referrer.dart';
import 'package:exim_lab/core/services/analytics_service.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReferrerService {
  static const String _prefKey = 'referrer_logged';

  /// Checks if referrer needs to be logged and does so if it's the first time.
  Future<void> checkAndLogReferrer() async {
    // Only for Android
    if (!Platform.isAndroid) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      final isLogged = prefs.getBool(_prefKey) ?? false;

      if (isLogged) {
        debugPrint('ℹ️ Referrer already logged.');
        return;
      }

      debugPrint('🔍 Fetching Install Referrer...');
      final ReferrerDetails referrerDetails =
          await AndroidPlayInstallReferrer.installReferrer;

      final referrerUrl = referrerDetails.installReferrer;
      final clickTimestamp = referrerDetails.referrerClickTimestampSeconds;
      final installTimestamp = referrerDetails.installBeginTimestampSeconds;

      debugPrint('✅ Referrer Fetched: $referrerUrl');

      // Parse UTM parameters manually
      final Map<String, String> utmParams = {};
      if (referrerUrl != null) {
        final pairs = referrerUrl.split('&');
        for (final pair in pairs) {
          final parts = pair.split('=');
          if (parts.length == 2) {
            utmParams[parts[0]] = parts[1];
          }
        }
      }

      // Log to Analytics
      final params = {
        'referrer_url': referrerUrl ?? 'unknown',
        'click_timestamp': clickTimestamp,
        'install_timestamp': installTimestamp,
      };
      params.addAll(utmParams);

      // Set User Properties for Firebase Segmentation
      if (utmParams.containsKey('utm_source')) {
        await AnalyticsService().setUserProperty(
          name: 'install_source',
          value: utmParams['utm_source']!,
        );
      }
      if (utmParams.containsKey('utm_medium')) {
        await AnalyticsService().setUserProperty(
          name: 'install_medium',
          value: utmParams['utm_medium']!,
        );
      }
      if (utmParams.containsKey('utm_campaign')) {
        await AnalyticsService().setUserProperty(
          name: 'install_campaign',
          value: utmParams['utm_campaign']!,
        );
      }

      await AnalyticsService().logEvent('install_referrer', parameters: params);

      // Mark as logged
      await prefs.setBool(_prefKey, true);
    } catch (e) {
      debugPrint('⚠️ Error fetching install referrer: $e');
    }
  }
}
