import 'package:exim_lab/core/constants/api_constants.dart';
import 'package:exim_lab/core/functions/api_call.dart';
import 'package:exim_lab/features/shorts/data/models/short_model.dart';

class ShortsService {
  Future<List<ShortModel>> getShorts({int page = 1, int limit = 20}) async {
    try {
      return await callApi<List<ShortModel>>(
        '${ApiConstants.shortVideos}?page=$page&limit=$limit', // Assuming ApiConstants.shortVideos exists or I'll add it
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
    } catch (e) {
      return [];
    }
  }
}
