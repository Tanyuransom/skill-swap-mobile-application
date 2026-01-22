class SubscriptionModel {
  final String id;
  final String userId;
  final String status; // 'active', 'expired', 'cancelled', 'pending'
  final DateTime startDate;
  final DateTime? endDate;
  final bool autoRenew;
  final String? paymentMethod;
  final DateTime? lastPaymentDate;
  final DateTime? nextBillingDate;

  SubscriptionModel({
    required this.id,
    required this.userId,
    required this.status,
    required this.startDate,
    this.endDate,
    required this.autoRenew,
    this.paymentMethod,
    this.lastPaymentDate,
    this.nextBillingDate,
  });

  factory SubscriptionModel.fromMap(Map<String, dynamic> map) {
    return SubscriptionModel(
      id: map['id'].toString(),
      userId: map['user_id'].toString(),
      status: map['status'] as String,
      startDate: DateTime.parse(map['start_date'].toString()),
      endDate: map['end_date'] != null ? DateTime.parse(map['end_date'].toString()) : null,
      autoRenew: map['auto_renew'] as bool,
      paymentMethod: map['payment_method']?.toString(),
      lastPaymentDate: map['last_payment_date'] != null 
          ? DateTime.parse(map['last_payment_date'].toString()) 
          : null,
      nextBillingDate: map['next_billing_date'] != null 
          ? DateTime.parse(map['next_billing_date'].toString()) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'autoRenew': autoRenew,
      'paymentMethod': paymentMethod,
      'lastPaymentDate': lastPaymentDate?.toIso8601String(),
      'nextBillingDate': nextBillingDate?.toIso8601String(),
    };
  }

  bool get isActive => status == 'active' && (endDate == null || endDate!.isAfter(DateTime.now()));
}
