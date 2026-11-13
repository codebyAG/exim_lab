// Models for GET /app-content/manifest.

String _str(dynamic v) => v == null ? '' : '$v';

/// "16:9" -> 1.777…, tolerant of junk. [fallback] is used when unparseable.
double parseAspectRatio(String raw, {double fallback = 16 / 9}) {
  final parts = raw.split(':');
  if (parts.length == 2) {
    final w = double.tryParse(parts[0].trim());
    final h = double.tryParse(parts[1].trim());
    if (w != null && h != null && w > 0 && h > 0) return w / h;
  }
  final single = double.tryParse(raw.trim());
  if (single != null && single > 0) return single;
  return fallback;
}

class MediaItem {
  final String id;
  final String type; // 'video' | 'image'
  final String url;
  final String thumbnailUrl;
  final String aspectRatioRaw;
  final String title;
  final String caption;
  final String checksum;
  final String status; // 'ready' | 'processing' — both are playable

  const MediaItem({
    required this.id,
    required this.type,
    required this.url,
    required this.thumbnailUrl,
    required this.aspectRatioRaw,
    required this.title,
    required this.caption,
    required this.checksum,
    required this.status,
  });

  bool get isVideo => type == 'video';
  bool get isImage => type == 'image';

  double aspectRatio({double fallback = 16 / 9}) =>
      parseAspectRatio(aspectRatioRaw, fallback: fallback);

  /// File extension taken from the URL path, with a sane per-type default.
  String get extension {
    final path = Uri.tryParse(url)?.path ?? '';
    final dot = path.lastIndexOf('.');
    if (dot != -1 && path.length - dot <= 6) {
      final ext = path.substring(dot + 1).toLowerCase();
      if (RegExp(r'^[a-z0-9]+$').hasMatch(ext)) return ext;
    }
    return isVideo ? 'mp4' : 'jpg';
  }

  /// Returns null when the entry is unusable (no id / no url).
  static MediaItem? tryParse(dynamic j) {
    if (j is! Map) return null;
    final id = _str(j['id']);
    final url = _str(j['url']);
    if (id.isEmpty || url.isEmpty) return null;
    return MediaItem(
      id: id,
      type: _str(j['type']).isEmpty ? 'image' : _str(j['type']).toLowerCase(),
      url: url,
      thumbnailUrl: _str(j['thumbnailUrl']),
      aspectRatioRaw: _str(j['aspectRatio']),
      title: _str(j['title']),
      caption: _str(j['caption']),
      checksum: _str(j['checksum']),
      status: _str(j['status']),
    );
  }
}

class AppContentManifest {
  final String version;
  final MediaItem? hero;
  final List<MediaItem> testimonials;
  final List<MediaItem> successStories;

  const AppContentManifest({
    required this.version,
    required this.hero,
    required this.testimonials,
    required this.successStories,
  });

  /// Every item in the manifest — used to decide which cached files to keep.
  Iterable<MediaItem> get all => [?hero, ...testimonials, ...successStories];

  static List<MediaItem> _list(dynamic v) => v is List
      ? v.map(MediaItem.tryParse).whereType<MediaItem>().toList()
      : const [];

  /// Unknown keys under `sections` are ignored so new sections never crash
  /// an older app build.
  factory AppContentManifest.fromJson(Map<String, dynamic> data) {
    final sections = data['sections'] is Map
        ? Map<String, dynamic>.from(data['sections'])
        : <String, dynamic>{};
    return AppContentManifest(
      version: _str(data['version']),
      hero: MediaItem.tryParse(sections['hero']),
      testimonials: _list(sections['testimonials']),
      successStories: _list(sections['success_stories']),
    );
  }
}
