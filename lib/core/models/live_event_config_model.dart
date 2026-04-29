class LiveEventConfig {
  final List<String> achievements;
  final WebinarConfig webinar;

  LiveEventConfig({
    required this.achievements,
    required this.webinar,
  });

  factory LiveEventConfig.fromJson(Map<String, dynamic> json) {
    return LiveEventConfig(
      achievements: List<String>.from(json['achievements'] ?? []),
      webinar: WebinarConfig.fromJson(json['webinar'] ?? {}),
    );
  }

  factory LiveEventConfig.fallback() {
    return LiveEventConfig(
      achievements: [
        "Start your export business",
        "Find international buyers",
        "Calculate profit margins",
        "Handle global shipping"
      ],
      webinar: WebinarConfig.fallback(),
    );
  }
}

class WebinarConfig {
  final bool isLive;
  final String day;
  final String month;
  final String time;
  final String whatsappMessage;

  WebinarConfig({
    required this.isLive,
    required this.day,
    required this.month,
    required this.time,
    required this.whatsappMessage,
  });

  factory WebinarConfig.fromJson(Map<String, dynamic> json) {
    return WebinarConfig(
      isLive: json['is_live'] ?? true,
      day: json['day'] ?? "25",
      month: json['month'] ?? "April",
      time: json['time'] ?? "7:00 PM",
      whatsappMessage: json['whatsapp_message'] ??
          "Hi, I want to register for the upcoming LIVE Import-Export Webinar.",
    );
  }

  factory WebinarConfig.fallback() {
    return WebinarConfig(
      isLive: true,
      day: "25",
      month: "April",
      time: "7:00 PM",
      whatsappMessage:
          "Hi, I want to register for the upcoming LIVE Import-Export Webinar.",
    );
  }
}
