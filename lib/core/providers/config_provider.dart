import 'package:flutter/material.dart';
import 'package:exim_lab/core/models/social_links_model.dart';
import 'package:exim_lab/core/services/config_service.dart';
import 'dart:developer' as developer;

class ConfigProvider extends ChangeNotifier {
  final ConfigService _service = ConfigService();
  SocialLinks? _links;
  bool _isLoading = false;

  SocialLinks? get links => _links;
  bool get isLoading => _isLoading;

  // Fallback links if API fails
  SocialLinks get effectiveLinks => _links ?? SocialLinks(
    whatsappNumber: "919871769042",
    youtubeUrl: "https://www.youtube.com/@siieadigital",
    instagramUrl: "https://www.instagram.com/siieadigital",
    websiteUrl: "https://www.siiea.in",
    supportEmail: "info@siiea.in",
  );

  Future<void> loadConfig() async {
    _isLoading = true;
    notifyListeners();

    try {
      final fetchedLinks = await _service.fetchSocialLinks();
      if (fetchedLinks != null) {
        _links = fetchedLinks;
        developer.log("✅ Social links loaded successfully", name: "CONFIG");
      }
    } catch (e) {
      developer.log("⚠️ Error loading social links: $e", name: "CONFIG");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
