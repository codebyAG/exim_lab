import 'package:exim_lab/core/constants/api_constants.dart';
import 'package:exim_lab/core/functions/api_call.dart';
import 'package:exim_lab/features/dashboard/data/models/exchange_rate_model.dart';

class ExchangeRateService {
  Future<ExchangeRateResponse> fetchExchangeRates() async {
    return await callApi(
      "${ApiConstants.exchangeRates}?base=INR",
      parser: (json) => ExchangeRateResponse.fromJson(json),
      methodType: MethodType.get,
    );
  }
}
