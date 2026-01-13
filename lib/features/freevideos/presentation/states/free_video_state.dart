import 'package:exim_lab/features/freevideos/data/datasources/free_videos_remote.dart';
import 'package:exim_lab/features/freevideos/data/models/free_videos_model.dart';
import 'package:flutter/material.dart';

class FreeVideosState extends ChangeNotifier {
  final _remote = FreeVideosRemote();

  bool isLoading = false;
  String? error;
  List<FreeVideoModel> videos = [];

  Future<void> load() async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      videos = await _remote.fetchFreeVideos();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
