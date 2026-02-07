import 'package:exim_lab/core/constants/api_constants.dart';
import 'package:exim_lab/core/functions/api_call.dart';
import 'package:exim_lab/features/news/data/models/news_model.dart';

class NewsService {
  Future<List<NewsModel>> fetchNews({int page = 1, int limit = 20}) async {
    try {
      return await callApi<List<NewsModel>>(
        ApiConstants.news,
        queryParameters: {'page': page, 'limit': limit},
        methodType: MethodType.get,
        parser: (json) {
          final data = json['data'] as List?;
          if (data != null) {
            return data.map((e) => NewsModel.fromJson(e)).toList();
          }
          return [];
        },
      );
    } catch (e) {
      throw Exception('Failed to fetch news: $e');
    }
  }
}
