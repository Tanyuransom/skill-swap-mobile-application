import 'package:skillswapp_shared/skillswapp_shared.dart';

class SubscriptionRepository {
  /// Create subscription
  Future<String> createSubscription({
    required String userId,
    required String paymentMethod,
  }) async {
    final endDate = DateTime.now().add(Duration(days: 30));
    final nextBilling = endDate;

    final result = await PostgresClient.execute(
      '''
      INSERT INTO subscriptions (
        user_id, status, end_date, payment_method, 
        last_payment_date, next_billing_date
      )
      VALUES (@userId, 'active', @endDate, @paymentMethod, CURRENT_TIMESTAMP, @nextBilling)
      ON CONFLICT (user_id) 
      DO UPDATE SET 
        status = 'active',
        end_date = @endDate,
        payment_method = @paymentMethod,
        last_payment_date = CURRENT_TIMESTAMP,
        next_billing_date = @nextBilling,
        auto_renew = true
      RETURNING id
      ''',
      parameters: {
        'userId': userId,
        'endDate': endDate.toIso8601String(),
        'paymentMethod': paymentMethod,
        'nextBilling': nextBilling.toIso8601String(),
      },
    );

    return result.first.toColumnMap()['id'].toString();
  }

  /// Get subscription by user ID
  Future<Map<String, dynamic>?> getSubscriptionByUser(String userId) async {
    final result = await PostgresClient.execute(
      'SELECT * FROM subscriptions WHERE user_id = @userId',
      parameters: {'userId': userId},
    );

    if (result.isEmpty) return null;
    return result.first.toColumnMap();
  }

  /// Check if user has active subscription
  Future<bool> hasActiveSubscription(String userId) async {
    final result = await PostgresClient.execute(
      '''
      SELECT COUNT(*) as count FROM subscriptions
      WHERE user_id = @userId 
      AND status = 'active'
      AND (end_date IS NULL OR end_date > CURRENT_TIMESTAMP)
      ''',
      parameters: {'userId': userId},
    );

    final count = result.first.toColumnMap()['count'] as int;
    return count > 0;
  }

  /// Cancel subscription
  Future<void> cancelSubscription(String userId) async {
    await PostgresClient.execute(
      '''
      UPDATE subscriptions
      SET auto_renew = false, status = 'cancelled'
      WHERE user_id = @userId
      ''',
      parameters: {'userId': userId},
    );
  }

  /// Get subscriptions expiring soon (for auto-renewal)
  Future<List<Map<String, dynamic>>> getSubscriptionsForRenewal() async {
    final result = await PostgresClient.execute(
      '''
      SELECT * FROM subscriptions
      WHERE status = 'active'
      AND auto_renew = true
      AND next_billing_date <= CURRENT_TIMESTAMP + INTERVAL '1 day'
      AND next_billing_date > CURRENT_TIMESTAMP
      ''',
    );

    return result.map((row) => row.toColumnMap()).toList();
  }

  /// Renew subscription
  Future<void> renewSubscription(String subscriptionId) async {
    final newEndDate = DateTime.now().add(Duration(days: 30));
    final nextBilling = newEndDate;

    await PostgresClient.execute(
      '''
      UPDATE subscriptions
      SET end_date = @endDate,
          last_payment_date = CURRENT_TIMESTAMP,
          next_billing_date = @nextBilling
      WHERE id = @subscriptionId
      ''',
      parameters: {
        'subscriptionId': subscriptionId,
        'endDate': newEndDate.toIso8601String(),
        'nextBilling': nextBilling.toIso8601String(),
      },
    );
  }

  /// Mark subscription as expired
  Future<void> expireSubscription(String subscriptionId) async {
    await PostgresClient.execute(
      '''
      UPDATE subscriptions
      SET status = 'expired'
      WHERE id = @subscriptionId
      ''',
      parameters: {'subscriptionId': subscriptionId},
    );
  }
}
