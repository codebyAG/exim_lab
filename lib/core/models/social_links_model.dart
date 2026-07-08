class SocialLinks {
  final String whatsappNumber;

  // Per-section WhatsApp numbers (fallback to whatsapp_number / default if API sends nothing)
  final String maintenanceWhatsappNumber;
  final String liveWhatsappNumber;
  final String handholdingWhatsappNumber;
  final String masterclassWhatsappNumber;
  final String interestWhatsappNumber;
  final String promoWhatsappNumber;

  final String youtubeUrl;
  final String instagramUrl;
  final String facebookUrl;
  final String twitterUrl;
  final String linkedinUrl;
  final String telegramUrl;
  final String websiteUrl;
  final String supportEmail;

  SocialLinks({
    required this.whatsappNumber,
    this.maintenanceWhatsappNumber = "919871769042",
    this.liveWhatsappNumber = "919871769042",
    this.handholdingWhatsappNumber = "919871769042",
    this.masterclassWhatsappNumber = "919871769042",
    this.interestWhatsappNumber = "919871769042",
    this.promoWhatsappNumber = "919871769042",
    required this.youtubeUrl,
    required this.instagramUrl,
    this.facebookUrl = "",
    this.twitterUrl = "",
    this.linkedinUrl = "",
    this.telegramUrl = "",
    required this.websiteUrl,
    required this.supportEmail,
  });

  factory SocialLinks.fromJson(Map<String, dynamic> json) {
    return SocialLinks(
      whatsappNumber: json['whatsapp_number'] ?? "919871769042",
      maintenanceWhatsappNumber: json['maintenance_whatsapp_number'] ??
          json['whatsapp_number'] ??
          "919871769042",
      liveWhatsappNumber: json['live_whatsapp_number'] ??
          json['whatsapp_number'] ??
          "919871769042",
      handholdingWhatsappNumber: json['handholding_whatsapp_number'] ??
          json['whatsapp_number'] ??
          "919871769042",
      masterclassWhatsappNumber: json['masterclass_whatsapp_number'] ??
          json['whatsapp_number'] ??
          "919871769042",
      interestWhatsappNumber: json['interest_whatsapp_number'] ??
          json['whatsapp_number'] ??
          "919871769042",
      promoWhatsappNumber: json['promo_whatsapp_number'] ??
          json['whatsapp_number'] ??
          "919871769042",
      youtubeUrl: json['youtube_url'] ?? "https://www.youtube.com/@siieadigital",
      instagramUrl: json['instagram_url'] ?? "https://www.instagram.com/siieadigital",
      facebookUrl: json['facebook_url'] ?? "",
      twitterUrl: json['twitter_url'] ?? "",
      linkedinUrl: json['linkedin_url'] ?? "",
      telegramUrl: json['telegram_url'] ?? "",
      websiteUrl: json['website_url'] ?? "https://www.siiea.in",
      supportEmail: json['support_email'] ?? "info@siiea.in",
    );
  }

  // Helper to get WhatsApp link with custom message
  String getWhatsAppLink(String message) {
    final encodedMsg = Uri.encodeComponent(message);
    return "https://wa.me/$whatsappNumber?text=$encodedMsg";
  }
}
