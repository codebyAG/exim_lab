// features/cto_banner/data/remote/cto_banner_remote.dart
import 'package:exim_lab/core/constants/api_constants.dart';
import 'package:exim_lab/core/functions/api_call.dart';
import 'package:exim_lab/features/cto_banners/data/models/cto_banner_model.dart';

class CtoBannerRemote {
  Future<List<CtoBannerModel>> fetchBanners() async {
    return callApi<List<CtoBannerModel>>(
      ApiConstants.ctoBanners,
      methodType: MethodType.get,
      parser: (json) {
        final List list = json['data'] ?? [];
        return list.map((e) => CtoBannerModel.fromJson(e)).toList();
      },
    );
  }
}
