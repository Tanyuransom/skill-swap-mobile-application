class PayoutModel {
  final String id;
  final String userId;
  final double amount;
  final String status; // 'pending', 'processing', 'completed', 'failed'
  final String paymentMethod; // 'orange_money', 'mtn_momo'
  final String phoneNumber;
  final String? operatorTransactionId;
  final DateTime requestedAt;
  final DateTime? completedAt;
  final String? failureReason;

  PayoutModel({
    required this.id,
    required this.userId,
    required this.amount,
    required this.status,
    required this.paymentMethod,
    required this.phoneNumber,
    this.operatorTransactionId,
    required this.requestedAt,
    this.completedAt,
    this.failureReason,
  });

  factory PayoutModel.fromMap(Map<String, dynamic> map) {
    return PayoutModel(
      id: map['id'].toString(),
      userId: map['user_id'].toString(),
      amount: double.parse(map['amount'].toString()),
      status: map['status'] as String,
      paymentMethod: map['payment_method'] as String,
      phoneNumber: map['phone_number'].toString(),
      operatorTransactionId: map['operator_transaction_id']?.toString(),
      requestedAt: DateTime.parse(map['requested_at'].toString()),
      completedAt: map['completed_at'] != null
          ? DateTime.parse(map['completed_at'].toString())
          : null,
      failureReason: map['failure_reason']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'status': status,
      'paymentMethod': paymentMethod,
      'phoneNumber': phoneNumber,
      'requestedAt': requestedAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'failureReason': failureReason,
    };
  }
}
