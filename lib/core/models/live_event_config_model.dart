class LiveEventConfig {
  final List<String> achievements;
  final WebinarConfig webinar;

  LiveEventConfig({
    required this.achievements,
    required this.webinar,
  });

  factory LiveEventConfig.fromJson(Map<String, dynamic> json) {
    final achievements = List<String>.from(json['achievements'] ?? []);
    return LiveEventConfig(
      achievements: achievements.isNotEmpty
          ? achievements
          : [
              "Start your export business",
              "Find international buyers",
              "Calculate profit margins",
              "Handle global shipping"
            ],
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
  final String? title;
  final String? meetingUrl;
  final String? seminarId;

  /// `none` · `upcoming` · `today` · `starting_soon` · `live` — the floating
  /// strip should render nothing for `none`. See SEMINARS_AND_WEBINAR_ALERTS.md §3-4.
  final String status;
  final String headline;
  final String ctaLabel;
  final String meetingPasscode;

  WebinarConfig({
    required this.isLive,
    required this.day,
    required this.month,
    required this.time,
    required this.whatsappMessage,
    this.title,
    this.meetingUrl,
    this.seminarId,
    this.status = 'none',
    this.headline = '',
    this.ctaLabel = '',
    this.meetingPasscode = '',
  });

  factory WebinarConfig.fromJson(Map<String, dynamic> json) {
    return WebinarConfig(
      isLive: json['is_live'] ?? true,
      day: json['day'] ?? "25",
      month: json['month'] ?? "April",
      time: json['time'] ?? "7:00 PM",
      whatsappMessage: json['whatsapp_message'] ??
          "Hi, I want to register for the upcoming LIVE Import-Export Webinar.",
      title: json['title'],
      meetingUrl: json['meetingUrl'],
      seminarId: json['seminarId'],
      status: json['status']?.toString() ?? 'none',
      headline: json['headline']?.toString() ?? '',
      ctaLabel: json['ctaLabel']?.toString() ?? '',
      meetingPasscode: json['meetingPasscode']?.toString() ?? '',
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
      title: "Weekly Import/Export Seminar",
      status: 'none',
    );
  }
}
