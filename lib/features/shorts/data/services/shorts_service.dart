import 'package:exim_lab/features/shorts/data/models/short_model.dart';

class ShortsService {
  Future<List<ShortModel>> getShorts() async {
    // Mock Data
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      ShortModel(
        id: '1',
        title: 'Import Export Tips 1',
        videoUrl: 'https://youtube.com/shorts/dH0GS71UUUg',
        views: '1.2M',
      ),
      ShortModel(
        id: '2',
        title: 'Networking Strategies',
        videoUrl: 'https://youtube.com/shorts/MpRenFR0jJk',
        views: '850K',
      ),
      ShortModel(
        id: '3',
        title: 'Customs Clearance',
        videoUrl: 'https://youtube.com/shorts/qfh02uEBuqQ',
        views: '2.4M',
      ),
      ShortModel(
        id: '4',
        title: 'Logistics Basics',
        videoUrl: 'https://www.youtube.com/shorts/Pd_n4o3o-jQ',
        views: '500K',
      ),
      ShortModel(
        id: '5',
        title: 'Export Documentation',
        videoUrl: 'https://youtube.com/shorts/tkMV0U42Qa4',
        views: '1.5M',
      ),
      ShortModel(
        id: '6',
        title: 'Finding Buyers',
        videoUrl: 'https://youtube.com/shorts/ZPE39TK46-A',
        views: '2.1M',
      ),
      ShortModel(
        id: '7',
        title: 'Shipping Terms',
        videoUrl: 'https://youtube.com/shorts/TvKZ3MLoof4',
        views: '900K',
      ),
    ];
  }
}
