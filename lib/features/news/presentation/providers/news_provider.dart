import 'package:exim_lab/features/news/data/models/news_model.dart';
import 'package:exim_lab/features/news/data/services/news_service.dart';
import 'package:flutter/material.dart';

class NewsProvider with ChangeNotifier {
  final NewsService _newsService;

  NewsProvider(this._newsService);

  List<NewsModel> _newsList = [];
  bool _isLoading = false;
  String? _error;

  List<NewsModel> get newsList => _newsList;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchNews({bool refresh = false}) async {
    if (_newsList.isNotEmpty && !refresh) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final news = await _newsService.fetchNews();
      _newsList = news;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
