import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:exim_lab/core/constants/api_constants.dart';
import 'package:exim_lab/core/functions/api_call.dart';
import 'package:exim_lab/features/shorts/data/models/short_model.dart';

class ShortsService {
  Future<List<ShortModel>> getShorts({int page = 1, int limit = 20}) async {
    try {
      final shorts = await callApi<List<ShortModel>>(
        '${ApiConstants.shortVideos}?page=$page&limit=$limit',
        methodType: MethodType.get,
        parser: (json) {
          if (json is Map<String, dynamic> && json['data'] is List) {
            return (json['data'] as List)
                .map((e) => ShortModel.fromJson(e))
                .toList();
          }
          return [];
        },
      );

      return await _enrichWithYouTubeMetadata(shorts);
    } catch (e) {
      // log('Error getting shorts: $e');
      return [];
    }
  }

  Future<List<ShortModel>> _enrichWithYouTubeMetadata(
    List<ShortModel> shorts,
  ) async {
    final yt = YoutubeExplode();

    try {
      final futures = shorts.map((short) async {
        try {
          final videoId = VideoId(short.videoUrl);

          // Add a timeout to prevent one bad request from blocking everything
          final video = await yt.videos
              .get(videoId)
              .timeout(
                const Duration(seconds: 5),
                onTimeout: () => throw Exception('Timeout'),
              );

          return short.copyWith(
            title: video.title,
            description: video.description,
            thumbnailUrl: video.thumbnails.highResUrl,
            viewCount: video.engagement.viewCount,
            likeCount: video.engagement.likeCount,
            metadataFetched: true,
          );
        } catch (e) {
          // Log error if needed, but return original short to keep things moving
          return short;
        }
      });

      return await Future.wait(futures);
    } finally {
      yt.close();
    }
  }
}
