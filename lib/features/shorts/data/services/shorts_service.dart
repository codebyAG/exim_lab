import 'dart:developer';
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
      log('Error getting shorts: $e');
      return [];
    }
  }

  Future<List<ShortModel>> _enrichWithYouTubeMetadata(
    List<ShortModel> shorts,
  ) async {
    final yt = YoutubeExplode();
    final enrichedShorts = <ShortModel>[];

    for (var short in shorts) {
      try {
        final videoId = VideoId(short.videoUrl); // Extract ID from URL
        final video = await yt.videos.get(videoId);

        enrichedShorts.add(
          short.copyWith(
            title: video.title,
            description: video.description,
            thumbnailUrl: video.thumbnails.highResUrl,
            viewCount: video.engagement.viewCount,
            likeCount: video.engagement.likeCount,
            metadataFetched: true,
          ),
        );
      } catch (e) {
        log('Error fetching YouTube metadata for ${short.videoUrl}: $e');
        enrichedShorts.add(short); // Fallback to original if YT fetch fails
      }
    }

    yt.close();
    return enrichedShorts;
  }
}
