import 'package:flutter/material.dart';
import 'package:exim_lab/core/models/social_links_model.dart';
import 'package:exim_lab/core/models/live_event_config_model.dart';
import 'package:exim_lab/core/services/config_service.dart';
import 'dart:developer' as developer;

class ConfigProvider extends ChangeNotifier {
  final ConfigService _service = ConfigService();
  SocialLinks? _links;
  LiveEventConfig? _liveEvent;
  bool _isLoading = false;

  SocialLinks? get links => _links;
  LiveEventConfig? get liveEvent => _liveEvent;
  bool get isLoading => _isLoading;

  // Fallback links if API fails
  SocialLinks get effectiveLinks => _links ?? SocialLinks(
    whatsappNumber: "919871769042",
    youtubeUrl: "https://www.youtube.com/@siieadigital",
    instagramUrl: "https://www.instagram.com/siieadigital",
    websiteUrl: "https://www.siiea.in",
    supportEmail: "info@siiea.in",
  );

  LiveEventConfig get effectiveLiveEvent => _liveEvent ?? LiveEventConfig.fallback();

  Future<void> loadConfig() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Fetch concurrently
      final results = await Future.wait([
        _service.fetchSocialLinks(),
        _service.fetchLiveEventConfig(),
      ]);

      if (results[0] != null) {
        _links = results[0] as SocialLinks;
        developer.log("✅ Social links loaded successfully", name: "CONFIG");
      }
      
      if (results[1] != null) {
        _liveEvent = results[1] as LiveEventConfig;
        developer.log("✅ Live events config loaded successfully", name: "CONFIG");
      }
    } catch (e) {
      developer.log("⚠️ Error loading configuration: $e", name: "CONFIG");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
