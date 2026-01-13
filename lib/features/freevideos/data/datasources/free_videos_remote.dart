import 'package:exim_lab/core/constants/api_constants.dart';
import 'package:exim_lab/core/functions/api_call.dart';
import 'package:exim_lab/features/freevideos/data/models/free_videos_model.dart';

class FreeVideosRemote {
  Future<List<FreeVideoModel>> fetchFreeVideos({
    int page = 1,
    int limit = 20,
  }) async {
    return callApi<List<FreeVideoModel>>(
      '${ApiConstants.baseUrl}${ApiConstants.freeVideos}',
      methodType: MethodType.get,
      queryParameters: {'page': page, 'limit': limit},
      parser: (json) {
        final List list = json['data'] ?? [];
        return list.map((e) => FreeVideoModel.fromJson(e)).toList();
      },
    );
  }
}
