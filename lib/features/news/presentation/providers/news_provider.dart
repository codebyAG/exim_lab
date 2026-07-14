import 'package:exim_lab/features/news/data/models/news_model.dart';
import 'package:exim_lab/features/news/data/services/news_service.dart';
import 'package:flutter/material.dart';

class NewsProvider with ChangeNotifier {
  final NewsService _newsService;

  NewsProvider(this._newsService);

  static const int _pageSize = 20;

  List<NewsModel> _newsList = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  String? _error;
  int _page = 1;
  int _totalPages = 1;

  List<NewsModel> get newsList => _newsList;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasMore => _page < _totalPages;
  String? get error => _error;

  /// First page (or pull-to-refresh).
  Future<void> fetchNews({bool refresh = false}) async {
    if (_newsList.isNotEmpty && !refresh) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _newsService.fetchNews(page: 1, limit: _pageSize);
      _newsList = result.items;
      _page = result.page;
      _totalPages = result.totalPages;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Next page for infinite scroll — guarded against duplicate calls.
  Future<void> loadMore() async {
    if (_isLoading || _isLoadingMore || !hasMore) return;

    _isLoadingMore = true;
    notifyListeners();

    try {
      final result =
          await _newsService.fetchNews(page: _page + 1, limit: _pageSize);
      _newsList = [..._newsList, ...result.items];
      _page = result.page;
      _totalPages = result.totalPages;
    } catch (_) {
      // Silent fail — user can scroll again to retry.
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }
}
