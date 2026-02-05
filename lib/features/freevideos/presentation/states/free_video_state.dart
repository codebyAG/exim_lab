import 'package:exim_lab/features/freevideos/data/models/free_videos_model.dart';
import 'package:flutter/material.dart';

class FreeVideosState extends ChangeNotifier {
  bool isLoading = false;
  String? error;
  List<FreeVideoModel> videos = [];

  Future<void> load() async {
    // API Removed. Data should come from Dashboard or other source.
  }
}
