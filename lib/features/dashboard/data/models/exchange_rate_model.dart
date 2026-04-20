class ExchangeRateResponse {
  final String source;
  final ExchangeRateData data;

  ExchangeRateResponse({required this.source, required this.data});

  factory ExchangeRateResponse.fromJson(Map<String, dynamic> json) {
    return ExchangeRateResponse(
      source: json['source'] ?? 'unknown',
      data: ExchangeRateData.fromJson(json['data'] ?? {}),
    );
  }
}

class ExchangeRateData {
  final String baseCode;
  final String result;
  final Map<String, double> conversionRates;
  final DateTime? updatedAt;

  ExchangeRateData({
    required this.baseCode,
    required this.result,
    required this.conversionRates,
    this.updatedAt,
  });

  factory ExchangeRateData.fromJson(Map<String, dynamic> json) {
    final ratesMap = json['conversion_rates'] as Map<String, dynamic>? ?? {};
    final Map<String, double> parsedRates = {};
    
    ratesMap.forEach((key, value) {
      if (value is num) {
        parsedRates[key] = value.toDouble();
      }
    });

    return ExchangeRateData(
      baseCode: json['base_code'] ?? 'INR',
      result: json['result'] ?? 'error',
      conversionRates: parsedRates,
      updatedAt: json['updatedAt'] != null 
          ? DateTime.tryParse(json['updatedAt']) 
          : null,
    );
  }

  /// Calculates the standard rate relative to 1 Unit of target currency.
  /// Example: 1 USD = X INR.
  /// If input is 1 INR = 0.012 USD, it returns 1 / 0.012 = 83.33.
  double getInvertedRate(String targetCurrency) {
    final rate = conversionRates[targetCurrency];
    if (rate == null || rate == 0) return 0.0;
    return 1 / rate;
  }

  /// Returns a list of formatted display pairs (e.g., ["USD/INR 83.42", "AED/INR 22.71"])
  /// Filters out the base currency itself.
  List<DisplayRate> getDisplayRates() {
    return conversionRates.keys
        .where((key) => key != baseCode)
        .map((key) => DisplayRate(
              symbol: "$key/$baseCode",
              value: getInvertedRate(key),
              currency: key,
            ))
        .toList();
  }
}

class DisplayRate {
  final String symbol;
  final double value;
  final String currency;

  DisplayRate({
    required this.symbol,
    required this.value,
    required this.currency,
  });
}
