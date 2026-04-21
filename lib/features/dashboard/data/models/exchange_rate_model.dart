class ExchangeRateResponse {
  final String source;
  final ExchangeRateData data;
  final ExchangeRateData? previous;
  final Map<String, ExchangeDelta> delta;

  ExchangeRateResponse({
    required this.source,
    required this.data,
    this.previous,
    required this.delta,
  });

  factory ExchangeRateResponse.fromJson(Map<String, dynamic> json) {
    // ... factory logic stayed the same ...
    final deltaMap = json['delta'] as Map<String, dynamic>? ?? {};
    final Map<String, ExchangeDelta> parsedDelta = {};
    deltaMap.forEach((key, value) {
      if (value is Map<String, dynamic>) {
        parsedDelta[key] = ExchangeDelta.fromJson(value);
      }
    });

    return ExchangeRateResponse(
      source: json['source'] ?? 'unknown',
      data: ExchangeRateData.fromJson(json['data'] ?? {}),
      previous: json['previous'] != null 
          ? ExchangeRateData.fromJson(json['previous']) 
          : null,
      delta: parsedDelta,
    );
  }

  /// Returns a list of formatted display pairs with movement stats
  List<DisplayRate> getDisplayRates() {
    final baseCode = data.baseCode;
    return data.conversionRates.keys
        .where((key) => key != baseCode)
        .map((key) {
      final deltaItem = delta[key];
      return DisplayRate(
        symbol: "$key/$baseCode",
        value: data.getInvertedRate(key),
        currency: key,
        diffPercent: deltaItem?.diffPercent ?? 0.0,
        isUp: (deltaItem?.diffPercent ?? 0.0) >= 0,
      );
    }).toList();
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
  double getInvertedRate(String targetCurrency) {
    final rate = conversionRates[targetCurrency];
    if (rate == null || rate == 0) return 0.0;
    return 1 / rate;
  }
}

class ExchangeDelta {
  final double today;
  final double yesterday;
  final double diff;
  final double diffPercent;

  ExchangeDelta({
    required this.today,
    required this.yesterday,
    required this.diff,
    required this.diffPercent,
  });

  factory ExchangeDelta.fromJson(Map<String, dynamic> json) {
    return ExchangeDelta(
      today: (json['today'] as num?)?.toDouble() ?? 0.0,
      yesterday: (json['yesterday'] as num?)?.toDouble() ?? 0.0,
      diff: (json['diff'] as num?)?.toDouble() ?? 0.0,
      diffPercent: (json['diff_percent'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class DisplayRate {
  final String symbol;
  final double value;
  final String currency;
  final double diffPercent;
  final bool isUp;

  DisplayRate({
    required this.symbol,
    required this.value,
    required this.currency,
    required this.diffPercent,
    required this.isUp,
  });
}
