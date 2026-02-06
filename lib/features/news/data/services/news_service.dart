import 'package:dio/dio.dart';
import 'package:exim_lab/core/constants/api_constants.dart';
import 'package:exim_lab/features/news/data/models/news_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewsService {
  final Dio _dio = Dio();
  final SharedPreferences _prefs;

  NewsService(this._prefs) {
    _dio.options.connectTimeout = const Duration(
      milliseconds: ApiConstants.connectTimeout,
    );
    _dio.options.receiveTimeout = const Duration(
      milliseconds: ApiConstants.receiveTimeout,
    );
  }

  Future<List<NewsModel>> fetchNews({int page = 1, int limit = 20}) async {
    try {
      final token = _prefs.getString('auth_token');
      final response = await _dio.get(
        ApiConstants.news,
        queryParameters: {'page': page, 'limit': limit},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        final data = response.data['data'] as List?;
        if (data != null) {
          return data.map((e) => NewsModel.fromJson(e)).toList();
        }
      }
      return [];
    } catch (e) {
      throw Exception('Failed to fetch news: $e');
    }
  }
}
