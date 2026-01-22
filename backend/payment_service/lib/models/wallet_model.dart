class WalletModel {
  final String id;
  final String userId;
  final double balance;
  final double pendingBalance;
  final double totalEarned;
  final double totalWithdrawn;
  final String currency;
  final DateTime updatedAt;

  WalletModel({
    required this.id,
    required this.userId,
    required this.balance,
    required this.pendingBalance,
    required this.totalEarned,
    required this.totalWithdrawn,
    required this.currency,
    required this.updatedAt,
  });

  factory WalletModel.fromMap(Map<String, dynamic> map) {
    return WalletModel(
      id: map['id'].toString(),
      userId: map['user_id'].toString(),
      balance: double.parse(map['balance'].toString()),
      pendingBalance: double.parse(map['pending_balance'].toString()),
      totalEarned: double.parse(map['total_earned'].toString()),
      totalWithdrawn: double.parse(map['total_withdrawn'].toString()),
      currency: map['currency'] as String,
      updatedAt: DateTime.parse(map['updated_at'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'balance': balance,
      'pendingBalance': pendingBalance,
      'totalEarned': totalEarned,
      'totalWithdrawn': totalWithdrawn,
      'currency': currency,
    };
  }
}
