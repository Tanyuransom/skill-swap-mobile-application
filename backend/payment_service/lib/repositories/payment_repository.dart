import 'package:skillswapp_shared/skillswapp_shared.dart';

class PaymentRepository {
  /// Create a new transaction
  Future<String> createTransaction({
    required String userId,
    String? courseId,
    required double amount,
    required String paymentMethod,
    String? phoneNumber,
    String? description,
  }) async {
    final result = await PostgresClient.execute(
      '''
      INSERT INTO transactions (user_id, course_id, amount, payment_method, phone_number, description)
      VALUES (@userId, @courseId, @amount, @paymentMethod, @phoneNumber, @description)
      RETURNING id
      ''',
      parameters: {
        'userId': userId,
        'courseId': courseId,
        'amount': amount,
        'paymentMethod': paymentMethod,
        'phoneNumber': phoneNumber,
        'description': description,
      },
    );
    
    return result.first.toColumnMap()['id'].toString();
  }

  /// Update transaction status
  Future<void> updateTransactionStatus(
    String transactionId,
    String status, {
    String? operatorTransactionId,
  }) async {
    await PostgresClient.execute(
      '''
      UPDATE transactions
      SET status = @status,
          operator_transaction_id = COALESCE(@operatorTransactionId, operator_transaction_id),
          completed_at = CASE WHEN @status IN ('completed', 'failed', 'refunded') THEN CURRENT_TIMESTAMP ELSE completed_at END
      WHERE id = @transactionId
      ''',
      parameters: {
        'transactionId': transactionId,
        'status': status,
        'operatorTransactionId': operatorTransactionId,
      },
    );
  }

  /// Get transaction by ID
  Future<Map<String, dynamic>?> getTransaction(String transactionId) async {
    final result = await PostgresClient.execute(
      'SELECT * FROM transactions WHERE id = @transactionId',
      parameters: {'transactionId': transactionId},
    );
    
    if (result.isEmpty) return null;
    return result.first.toColumnMap();
  }

  /// Get user's payment history
  Future<List<Map<String, dynamic>>> getPaymentHistory(
    String userId, {
    String? status,
    int limit = 20,
  }) async {
    String query = '''
      SELECT t.*, c.title as course_title
      FROM transactions t
      LEFT JOIN courses c ON t.course_id = c.id
      WHERE t.user_id = @userId
    ''';
    
    if (status != null) {
      query += ' AND t.status = @status';
    }
    
    query += ' ORDER BY t.created_at DESC LIMIT @limit';
    
    final result = await PostgresClient.execute(
      query,
      parameters: {
        'userId': userId,
        if (status != null) 'status': status,
        'limit': limit,
      },
    );
    
    return result.map((row) => row.toColumnMap()).toList();
  }

  /// Get or create wallet for user
  Future<Map<String, dynamic>> getOrCreateWallet(String userId) async {
    // Try to get existing wallet
    var result = await PostgresClient.execute(
      'SELECT * FROM wallets WHERE user_id = @userId',
      parameters: {'userId': userId},
    );
    
    if (result.isNotEmpty) {
      return result.first.toColumnMap();
    }
    
    // Create new wallet
    result = await PostgresClient.execute(
      '''
      INSERT INTO wallets (user_id)
      VALUES (@userId)
      RETURNING *
      ''',
      parameters: {'userId': userId},
    );
    
    return result.first.toColumnMap();
  }

  /// Credit wallet (add earnings)
  Future<void> creditWallet(String userId, double amount) async {
    await PostgresClient.execute(
      '''
      UPDATE wallets
      SET balance = balance + @amount,
          total_earned = total_earned + @amount,
          updated_at = CURRENT_TIMESTAMP
      WHERE user_id = @userId
      ''',
      parameters: {
        'userId': userId,
        'amount': amount,
      },
    );
  }

  /// Debit wallet (for payouts)
  Future<void> debitWallet(String userId, double amount) async {
    await PostgresClient.execute(
      '''
      UPDATE wallets
      SET balance = balance - @amount,
          total_withdrawn = total_withdrawn + @amount,
          updated_at = CURRENT_TIMESTAMP
      WHERE user_id = @userId
      ''',
      parameters: {
        'userId': userId,
        'amount': amount,
      },
    );
  }

  /// Create payout request
  Future<String> createPayout({
    required String userId,
    required double amount,
    required String paymentMethod,
    required String phoneNumber,
  }) async {
    final result = await PostgresClient.execute(
      '''
      INSERT INTO payouts (user_id, amount, payment_method, phone_number)
      VALUES (@userId, @amount, @paymentMethod, @phoneNumber)
      RETURNING id
      ''',
      parameters: {
        'userId': userId,
        'amount': amount,
        'paymentMethod': paymentMethod,
        'phoneNumber': phoneNumber,
      },
    );
    
    return result.first.toColumnMap()['id'].toString();
  }

  /// Update payout status
  Future<void> updatePayoutStatus(
    String payoutId,
    String status, {
    String? operatorTransactionId,
    String? failureReason,
  }) async {
    await PostgresClient.execute(
      '''
      UPDATE payouts
      SET status = @status,
          operator_transaction_id = COALESCE(@operatorTransactionId, operator_transaction_id),
          failure_reason = COALESCE(@failureReason, failure_reason),
          completed_at = CASE WHEN @status IN ('completed', 'failed') THEN CURRENT_TIMESTAMP ELSE completed_at END
      WHERE id = @payoutId
      ''',
      parameters: {
        'payoutId': payoutId,
        'status': status,
        'operatorTransactionId': operatorTransactionId,
        'failureReason': failureReason,
      },
    );
  }

  /// Get payout by ID
  Future<Map<String, dynamic>?> getPayout(String payoutId) async {
    final result = await PostgresClient.execute(
      'SELECT * FROM payouts WHERE id = @payoutId',
      parameters: {'payoutId': payoutId},
    );
    
    if (result.isEmpty) return null;
    return result.first.toColumnMap();
  }
}
