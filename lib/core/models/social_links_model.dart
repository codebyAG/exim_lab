class SocialLinks {
  final String whatsappNumber;
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
