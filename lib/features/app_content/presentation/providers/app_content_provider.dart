import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:exim_lab/features/app_content/data/models/app_content_models.dart';
import 'package:exim_lab/features/app_content/data/services/app_content_service.dart';
import 'package:exim_lab/features/app_content/data/services/media_cache_service.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Home-screen media: hero video, testimonial videos, success-story images.
///
/// Flow on every launch:
///   1. render instantly from the last stored manifest + cached files
///   2. GET manifest with `If-None-Match`
///        304 -> nothing to do
///        200 -> store ETag, diff by checksum, download only what changed
///   3. delete cached files that left the manifest
class AppContentProvider extends ChangeNotifier {
  static const _manifestKey = 'app_content_manifest';
  static const _etagKey = 'app_content_etag';

  final AppContentService _service;
  final MediaCacheService _cache;

  AppContentProvider({AppContentService? service, MediaCacheService? cache})
    : _service = service ?? AppContentService(),
      _cache = cache ?? MediaCacheService();

  AppContentManifest? manifest;
  bool _loading = false;

  // De-duplicates concurrent downloads of the same item.
  final Map<String, Future<File?>> _inFlight = {};

  MediaItem? get hero => manifest?.hero;
  List<MediaItem> get testimonials => manifest?.testimonials ?? const [];
  List<MediaItem> get successStories => manifest?.successStories ?? const [];

  /// Best local copy (possibly stale) or null.
  File? fileFor(MediaItem item) => _cache.fileFor(item.id);

  Future<void> load() async {
    if (_loading) return;
    _loading = true;
    try {
      await _cache.init();
      final prefs = await SharedPreferences.getInstance();

      // 1. Cached manifest first so the UI never waits on the network.
      String? etag;
      final cachedRaw = prefs.getString(_manifestKey);
      if (cachedRaw != null) {
        try {
          manifest = AppContentManifest.fromJson(
            Map<String, dynamic>.from(jsonDecode(cachedRaw)),
          );
          // Only trust the ETag if we actually hold the manifest it describes,
          // otherwise a 304 would leave us with nothing to render.
          etag = prefs.getString(_etagKey);
          notifyListeners();
        } catch (_) {
          manifest = null;
        }
      }

      // 2. Ask the server what changed.
      bool reachedServer = false;
      try {
        final res = await _service.fetchManifest(etag: etag);
        reachedServer = true;
        if (!res.notModified && res.manifest != null) {
          manifest = res.manifest;
          await prefs.setString(_manifestKey, jsonEncode(res.raw));
          if (res.etag != null) {
            await prefs.setString(_etagKey, res.etag!);
          } else {
            await prefs.remove(_etagKey);
          }
          notifyListeners();
        }
      } catch (e) {
        // Offline / server error: keep whatever we have.
        developer.log('Manifest fetch failed: $e', name: 'MEDIA');
      }

      final m = manifest;
      if (m == null) return;

      // 3. Download only what differs. Hero first, then images; testimonial
      //    videos are fetched lazily as the user scrolls to them.
      if (m.hero != null) await ensure(m.hero!);
      for (final img in m.successStories) {
        await ensure(img);
      }

      // 4. Only prune against a manifest we know is current.
      if (reachedServer) {
        await _cache.prune(m.all.map((i) => i.id).toSet());
      }
    } finally {
      _loading = false;
    }
  }

  /// Make sure [item] is cached and up to date. Returns the local file, or the
  /// previous (stale) copy / null if the download failed. Never throws, so one
  /// failed download can't blank a screen.
  Future<File?> ensure(MediaItem item) {
    if (_cache.isFresh(item)) return Future.value(_cache.fileFor(item.id));
    return _inFlight.putIfAbsent(item.id, () async {
      try {
        await _cache.init();
        final f = await _cache.download(item);
        notifyListeners();
        return f;
      } catch (_) {
        return _cache.fileFor(item.id); // keep the old file; retry next launch
      } finally {
        _inFlight.remove(item.id);
      }
    });
  }
}
