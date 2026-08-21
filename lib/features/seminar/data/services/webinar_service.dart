import 'package:exim_lab/core/constants/api_constants.dart';
import 'package:exim_lab/core/functions/api_call.dart';
import 'package:exim_lab/features/seminar/data/models/webinar_detail_model.dart';

class WebinarService {
  Future<WebinarDetail> fetchWebinarDetail(String seminarId) async {
    return await callApi(
      '${ApiConstants.seminarDetail}/$seminarId',
      parser: (json) {
        final data = json is Map && json['data'] != null ? json['data'] : json;
        return WebinarDetail.fromJson(Map<String, dynamic>.from(data));
      },
    );
  }
}
