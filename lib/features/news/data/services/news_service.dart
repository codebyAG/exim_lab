import 'package:exim_lab/core/constants/api_constants.dart';
import 'package:exim_lab/core/functions/api_call.dart';
import 'package:exim_lab/features/news/data/models/news_model.dart';

/// One page of news + server-side pagination info.
class NewsPage {
  final List<NewsModel> items;
  final int page;
  final int totalPages;

  NewsPage({required this.items, required this.page, required this.totalPages});

  bool get hasMore => page < totalPages;
}

class NewsService {
  Future<NewsPage> fetchNews({int page = 1, int limit = 20}) async {
    try {
      return await callApi<NewsPage>(
        ApiConstants.news,
        queryParameters: {'page': page, 'limit': limit},
        methodType: MethodType.get,
        parser: (json) {
          final data = json['data'] as List? ?? [];
          final meta = json['meta'] as Map? ?? {};
          return NewsPage(
            items: data.map((e) => NewsModel.fromJson(e)).toList(),
            page: (meta['page'] as num?)?.toInt() ?? page,
            totalPages: (meta['totalPages'] as num?)?.toInt() ?? 1,
          );
        },
      );
    } catch (e) {
      throw Exception('Failed to fetch news: $e');
    }
  }

  /// Fetch a single news item by id — used when opening news details
  /// from a notification (only the id is available in the payload).
  Future<NewsModel?> fetchNewsById(String id) async {
    try {
      return await callApi<NewsModel?>(
        '${ApiConstants.news}/$id',
        methodType: MethodType.get,
        parser: (json) {
          final data = json is Map ? json['data'] : null;
          if (data != null) return NewsModel.fromJson(data);
          return null;
        },
      );
    } catch (e) {
      return null;
    }
  }
}
