class TransactionModel {
  final String id;
  final String userId;
  final String? courseId;
  final double amount;
  final String currency;
  final String status; // 'pending', 'completed', 'failed', 'refunded'
  final String paymentMethod; // 'orange_money', 'mtn_momo', 'wallet'
  final String? phoneNumber;
  final String? transactionRef;
  final String? operatorTransactionId;
  final String? description;
  final DateTime createdAt;
  final DateTime? completedAt;

  TransactionModel({
    required this.id,
    required this.userId,
    this.courseId,
    required this.amount,
    required this.currency,
    required this.status,
    required this.paymentMethod,
    this.phoneNumber,
    this.transactionRef,
    this.operatorTransactionId,
    this.description,
    required this.createdAt,
    this.completedAt,
  });

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'].toString(),
      userId: map['user_id'].toString(),
      courseId: map['course_id']?.toString(),
      amount: double.parse(map['amount'].toString()),
      currency: map['currency'] as String,
      status: map['status'] as String,
      paymentMethod: map['payment_method'] as String,
      phoneNumber: map['phone_number']?.toString(),
      transactionRef: map['transaction_ref']?.toString(),
      operatorTransactionId: map['operator_transaction_id']?.toString(),
      description: map['description']?.toString(),
      createdAt: DateTime.parse(map['created_at'].toString()),
      completedAt: map['completed_at'] != null
          ? DateTime.parse(map['completed_at'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'courseId': courseId,
      'amount': amount,
      'currency': currency,
      'status': status,
      'paymentMethod': paymentMethod,
      'phoneNumber': phoneNumber,
      'transactionRef': transactionRef,
      'operatorTransactionId': operatorTransactionId,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
    };
  }
}
