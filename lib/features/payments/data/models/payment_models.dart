// Models for the Razorpay integration. All amounts are in PAISE.

int _int(dynamic v) => v is num ? v.toInt() : int.tryParse('$v') ?? 0;
String _str(dynamic v) => v == null ? '' : '$v';

class PaymentConfig {
  final bool enabled;
  final String keyId;
  final String currency;
  final String mode;

  const PaymentConfig({
    required this.enabled,
    required this.keyId,
    required this.currency,
    required this.mode,
  });

  /// Safe default: payments off, app falls back to WhatsApp.
  static const disabled = PaymentConfig(
    enabled: false,
    keyId: '',
    currency: 'INR',
    mode: '',
  );

  factory PaymentConfig.fromJson(Map<String, dynamic> j) {
    final keyId = _str(j['keyId']);
    return PaymentConfig(
      // No key → can't open checkout, so treat as disabled regardless.
      enabled: j['enabled'] == true && keyId.isNotEmpty,
      keyId: keyId,
      currency: _str(j['currency']).isEmpty ? 'INR' : _str(j['currency']),
      mode: _str(j['mode']),
    );
  }
}

class PaymentOrder {
  final String orderId;
  final String paymentRef;
  final int amount; // paise
  final String currency;
  final String keyId;
  final String productTitle;
  final int baseAmount; // paise
  final int discountAmount; // paise
  final String couponCode;
  final String prefillName;
  final String prefillContact;
  final String prefillEmail;

  const PaymentOrder({
    required this.orderId,
    required this.paymentRef,
    required this.amount,
    required this.currency,
    required this.keyId,
    required this.productTitle,
    required this.baseAmount,
    required this.discountAmount,
    required this.couponCode,
    required this.prefillName,
    required this.prefillContact,
    required this.prefillEmail,
  });

  factory PaymentOrder.fromJson(Map<String, dynamic> j) {
    final prefill = j['prefill'] is Map
        ? Map<String, dynamic>.from(j['prefill'])
        : <String, dynamic>{};
    return PaymentOrder(
      orderId: _str(j['orderId']),
      paymentRef: _str(j['paymentRef']),
      amount: _int(j['amount']),
      currency: _str(j['currency']).isEmpty ? 'INR' : _str(j['currency']),
      keyId: _str(j['keyId']),
      productTitle: _str(j['productTitle']),
      baseAmount: _int(j['baseAmount']),
      discountAmount: _int(j['discountAmount']),
      couponCode: _str(j['couponCode']),
      prefillName: _str(prefill['name']),
      prefillContact: _str(prefill['contact']),
      prefillEmail: _str(prefill['email']),
    );
  }
}

/// Result of `/payments/verify` or `/payments/status/:orderId`.
class PaymentResult {
  final String status;
  final String orderId;
  final String paymentId;
  final String productType;
  final String productId;
  final String productTitle;
  final bool accessGranted;
  final DateTime? accessEndsAt;
  final String via;

  const PaymentResult({
    required this.status,
    required this.orderId,
    required this.paymentId,
    required this.productType,
    required this.productId,
    required this.productTitle,
    required this.accessGranted,
    required this.accessEndsAt,
    required this.via,
  });

  bool get isPaid => status.toUpperCase() == 'PAID';

  factory PaymentResult.fromJson(Map<String, dynamic> j) => PaymentResult(
    status: _str(j['status']),
    orderId: _str(j['orderId']),
    paymentId: _str(j['paymentId']),
    productType: _str(j['productType']),
    productId: _str(j['productId']),
    productTitle: _str(j['productTitle']),
    accessGranted: j['accessGranted'] == true,
    accessEndsAt: DateTime.tryParse(_str(j['accessEndsAt'])),
    via: _str(j['via']),
  );
}

class CourseEntitlement {
  final String courseId;
  final DateTime? startsAt;
  final DateTime? endsAt;

  const CourseEntitlement({
    required this.courseId,
    required this.startsAt,
    required this.endsAt,
  });

  bool get isActive => endsAt == null || endsAt!.isAfter(DateTime.now());

  factory CourseEntitlement.fromJson(Map<String, dynamic> j) =>
      CourseEntitlement(
        courseId: _str(j['courseId']),
        startsAt: DateTime.tryParse(_str(j['startsAt'])),
        endsAt: DateTime.tryParse(_str(j['endsAt'])),
      );
}

class Entitlements {
  final bool isPremium;
  final DateTime? premiumUntil;
  final List<CourseEntitlement> courses;

  const Entitlements({
    required this.isPremium,
    required this.premiumUntil,
    required this.courses,
  });

  static const none = Entitlements(
    isPremium: false,
    premiumUntil: null,
    courses: [],
  );

  bool ownsCourse(String courseId) =>
      courses.any((c) => c.courseId == courseId && c.isActive);

  factory Entitlements.fromJson(Map<String, dynamic> j) => Entitlements(
    isPremium: j['isPremium'] == true,
    premiumUntil: DateTime.tryParse(_str(j['premiumUntil'])),
    courses: (j['courses'] is List)
        ? (j['courses'] as List)
              .whereType<Map>()
              .map(
                (e) =>
                    CourseEntitlement.fromJson(Map<String, dynamic>.from(e)),
              )
              .toList()
        : const [],
  );
}

/// Locally persisted order awaiting confirmation (survives app kill).
class PendingPayment {
  final String orderId;
  final String productType;
  final String productId;
  final DateTime createdAt;

  const PendingPayment({
    required this.orderId,
    required this.productType,
    required this.productId,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'orderId': orderId,
    'productType': productType,
    'productId': productId,
    'createdAt': createdAt.toIso8601String(),
  };

  factory PendingPayment.fromJson(Map<String, dynamic> j) => PendingPayment(
    orderId: _str(j['orderId']),
    productType: _str(j['productType']),
    productId: _str(j['productId']),
    createdAt: DateTime.tryParse(_str(j['createdAt'])) ?? DateTime.now(),
  );
}
