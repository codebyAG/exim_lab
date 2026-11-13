import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:exim_lab/features/app_content/data/models/app_content_models.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// On-disk media cache. Keyed by item `id`; staleness is decided ONLY by
/// `checksum` (URLs change on re-upload, sizes/timestamps are not signals).
///
/// Lives in the application-support directory, which the OS does not clear
/// behind the app's back the way a temp/cache directory can be.
class MediaCacheService {
  static const _indexKey = 'app_content_index';

  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(minutes: 5),
    ),
  );

  Directory? _dir;
  // id -> {checksum, file}
  final Map<String, Map<String, String>> _index = {};

  Future<void> init() async {
    if (_dir != null) return;
    final base = await getApplicationSupportDirectory();
    final dir = Directory('${base.path}/app_content');
    if (!await dir.exists()) await dir.create(recursive: true);
    _dir = dir;

    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_indexKey);
      if (raw != null) {
        final decoded = jsonDecode(raw);
        if (decoded is Map) {
          decoded.forEach((k, v) {
            if (v is Map) {
              _index['$k'] = {
                'checksum': '${v['checksum'] ?? ''}',
                'file': '${v['file'] ?? ''}',
              };
            }
          });
        }
      }
    } catch (_) {}
  }

  Future<void> _saveIndex() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_indexKey, jsonEncode(_index));
    } catch (_) {}
  }

  /// The cached file for [id] if it still exists on disk — even when its
  /// checksum is stale. A stale file beats an empty screen.
  File? fileFor(String id) {
    final dir = _dir;
    final entry = _index[id];
    if (dir == null || entry == null) return null;
    final f = File('${dir.path}/${entry['file']}');
    return f.existsSync() ? f : null;
  }

  /// True when a file exists AND its checksum matches the manifest's.
  bool isFresh(MediaItem item) {
    final entry = _index[item.id];
    return entry != null &&
        item.checksum.isNotEmpty &&
        entry['checksum'] == item.checksum &&
        fileFor(item.id) != null;
  }

  /// Downloads [item] to a temp file then swaps it in, so a failed or
  /// interrupted download never destroys the previous good copy.
  /// Throws on failure; callers keep using [fileFor].
  Future<File> download(MediaItem item) async {
    final dir = _dir!;
    final name = '${_safe(item.id)}.${item.extension}';
    final target = File('${dir.path}/$name');
    final part = File('${target.path}.part');

    try {
      await _dio.download(item.url, part.path);
      final oldName = _index[item.id]?['file'];
      if (await target.exists()) await target.delete();
      await part.rename(target.path);
      // Extension changed on re-upload (e.g. .mov -> .mp4): drop the orphan.
      if (oldName != null && oldName.isNotEmpty && oldName != name) {
        final old = File('${dir.path}/$oldName');
        if (await old.exists()) await old.delete();
      }
      _index[item.id] = {'checksum': item.checksum, 'file': name};
      await _saveIndex();
      return target;
    } catch (e) {
      developer.log('Media download failed (${item.id}): $e', name: 'MEDIA');
      try {
        if (await part.exists()) await part.delete();
      } catch (_) {}
      rethrow;
    }
  }

  /// Delete every cached file whose id is no longer in the manifest, plus any
  /// stray `.part` / unindexed files.
  Future<void> prune(Set<String> keepIds) async {
    final dir = _dir;
    if (dir == null) return;
    _index.removeWhere((id, _) => !keepIds.contains(id));
    final keepFiles = _index.values.map((e) => e['file']).toSet();
    try {
      await for (final e in dir.list()) {
        if (e is! File) continue;
        final name = e.uri.pathSegments.last;
        if (!keepFiles.contains(name)) {
          try {
            await e.delete();
          } catch (_) {}
        }
      }
    } catch (_) {}
    await _saveIndex();
  }

  static String _safe(String id) => id.replaceAll(RegExp(r'[^A-Za-z0-9_-]'), '_');
}
