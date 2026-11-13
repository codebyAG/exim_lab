import 'package:dio/dio.dart';
import 'package:exim_lab/core/constants/api_constants.dart';
import 'package:exim_lab/features/app_content/data/models/app_content_models.dart';

class ManifestResponse {
  /// 304 — nothing changed, keep rendering from cache.
  final bool notModified;
  final AppContentManifest? manifest;

  /// The raw `data` object, persisted so the next launch can render offline.
  final Map<String, dynamic>? raw;

  /// The ETag response header, verbatim (quotes included).
  final String? etag;

  const ManifestResponse({
    required this.notModified,
    this.manifest,
    this.raw,
    this.etag,
  });
}

class AppContentService {
  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 20),
      // 304 is a normal answer here, not an error.
      validateStatus: (s) => s != null && (s < 300 || s == 304),
    ),
  );

  /// Public endpoint — no token. Sends [etag] as `If-None-Match` when known.
  Future<ManifestResponse> fetchManifest({String? etag}) async {
    final res = await _dio.get(
      ApiConstants.appContentManifest,
      options: Options(
        headers: {if (etag != null && etag.isNotEmpty) 'If-None-Match': etag},
      ),
    );

    if (res.statusCode == 304) {
      return const ManifestResponse(notModified: true);
    }

    final body = res.data;
    final data = body is Map ? body['data'] : null;
    if (data is! Map) throw const FormatException('Malformed manifest');
    final raw = Map<String, dynamic>.from(data);
    return ManifestResponse(
      notModified: false,
      manifest: AppContentManifest.fromJson(raw),
      raw: raw,
      etag: res.headers.value('etag'),
    );
  }
}
