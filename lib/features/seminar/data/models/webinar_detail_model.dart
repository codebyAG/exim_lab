// GET /api/seminars/:seminarId
class WebinarDetail {
  final String title;
  final String description;
  final String bannerImageUrl;
  final String meetingUrl;
  final WebinarSchedule? schedule;

  const WebinarDetail({
    required this.title,
    required this.description,
    required this.bannerImageUrl,
    required this.meetingUrl,
    required this.schedule,
  });

  factory WebinarDetail.fromJson(Map<String, dynamic> json) {
    final schedule = json['schedule'];
    return WebinarDetail(
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      bannerImageUrl: json['bannerImageUrl']?.toString() ?? '',
      meetingUrl: json['meetingUrl']?.toString() ?? '',
      schedule: schedule is Map
          ? WebinarSchedule.fromJson(Map<String, dynamic>.from(schedule))
          : null,
    );
  }
}

class WebinarSchedule {
  final String type; // e.g. "weekly"
  final List<int> daysOfWeek; // 0 = Sunday .. 6 = Saturday
  final String time; // "19:00"
  final String timezone; // "Asia/Kolkata"
  final int durationMinutes;

  const WebinarSchedule({
    required this.type,
    required this.daysOfWeek,
    required this.time,
    required this.timezone,
    required this.durationMinutes,
  });

  factory WebinarSchedule.fromJson(Map<String, dynamic> json) => WebinarSchedule(
    type: json['type']?.toString() ?? '',
    daysOfWeek:
        (json['daysOfWeek'] as List?)?.map((e) => (e as num).toInt()).toList() ??
        const [],
    time: json['time']?.toString() ?? '',
    timezone: json['timezone']?.toString() ?? '',
    durationMinutes: (json['durationMinutes'] as num?)?.toInt() ?? 0,
  );

  static const _dayNames = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

  /// "Mon, Wed, Fri · 7:00 PM IST" — falls back gracefully if any part is
  /// missing rather than showing a broken/partial sentence.
  String get displayLabel {
    final parts = <String>[];
    if (daysOfWeek.isNotEmpty) {
      final names = daysOfWeek
          .where((d) => d >= 0 && d <= 6)
          .map((d) => _dayNames[d])
          .toList();
      if (names.isNotEmpty) parts.add(names.join(', '));
    }
    if (time.isNotEmpty) parts.add(_formatTime(time));
    final label = parts.join(' · ');
    if (label.isEmpty) return '';
    return timezone.isNotEmpty ? '$label $timezone' : label;
  }

  static String _formatTime(String raw) {
    final segments = raw.split(':');
    if (segments.length < 2) return raw;
    final hour24 = int.tryParse(segments[0]);
    final minute = segments[1];
    if (hour24 == null) return raw;
    final period = hour24 >= 12 ? 'PM' : 'AM';
    final hour12 = hour24 % 12 == 0 ? 12 : hour24 % 12;
    return '$hour12:$minute $period';
  }
}
