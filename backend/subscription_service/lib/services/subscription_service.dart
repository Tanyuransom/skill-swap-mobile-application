import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:skillswapp_shared/skillswapp_shared.dart';
import '../repositories/subscription_repository.dart';

class SubscriptionService {
  final SubscriptionRepository _repository = SubscriptionRepository();
  final double subscriptionPrice = 2500.0; // XAF per month

  /// Subscribe to premium
  Future<Map<String, dynamic>> subscribe({
    required String userId,
    required String paymentMethod,
    required String phoneNumber,
  }) async {
    // Check if already subscribed
    final existing = await _repository.getSubscriptionByUser(userId);
    if (existing != null && existing['status'] == 'active') {
      final endDate = DateTime.parse(existing['end_date'].toString());
      if (endDate.isAfter(DateTime.now())) {
        throw ConflictException('Already have active subscription');
      }
    }

    // Create payment transaction
    final paymentResponse = await _initiatePayment(
      userId: userId,
      amount: subscriptionPrice,
      paymentMethod: paymentMethod,
      phoneNumber: phoneNumber,
      description: 'Premium Subscription - 1 Month',
    );

    // Create subscription record (pending until payment confirmed)
    final subscriptionId = await _repository.createSubscription(
      userId: userId,
      paymentMethod: paymentMethod,
    );

    return {
      'subscriptionId': subscriptionId,
      'transactionId': paymentResponse['transactionId'],
      'amount': subscriptionPrice,
      'currency': 'XAF',
      'message': 'Check your phone to complete payment',
    };
  }

  /// Confirm subscription payment
  Future<Map<String, dynamic>> confirmSubscription(
    String userId,
    String transactionId,
  ) async {
    // In real implementation, verify payment with Payment Service
    // For now, assume payment is confirmed

    final subscription = await _repository.getSubscriptionByUser(userId);
    if (subscription == null) {
      throw NotFoundException('Subscription not found');
    }

    return {
      'status': 'active',
      'message': 'Premium subscription activated!',
      'endDate': subscription['end_date'].toString(),
    };
  }

  /// Get subscription status
  Future<Map<String, dynamic>> getSubscriptionStatus(String userId) async {
    final subscription = await _repository.getSubscriptionByUser(userId);

    if (subscription == null) {
      return {
        'hasSubscription': false,
        'status': 'none',
        'message': 'No active subscription',
      };
    }

    final isActive = await _repository.hasActiveSubscription(userId);

    return {
      'hasSubscription': true,
      'status': subscription['status'],
      'isActive': isActive,
      'startDate': subscription['start_date'].toString(),
      'endDate': subscription['end_date']?.toString(),
      'autoRenew': subscription['auto_renew'],
      'nextBillingDate': subscription['next_billing_date']?.toString(),
    };
  }

  /// Cancel subscription
  Future<void> cancelSubscription(String userId) async {
    await _repository.cancelSubscription(userId);
  }

  /// Check if user can access premium content
  Future<bool> canAccessPremiumContent(String userId) async {
    return await _repository.hasActiveSubscription(userId);
  }

  /// Helper: Initiate payment via Payment Service
  Future<Map<String, dynamic>> _initiatePayment({
    required String userId,
    required double amount,
    required String paymentMethod,
    required String phoneNumber,
    required String description,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:8086/payment/initiate'),
        headers: {
          'Content-Type': 'application/json',
          'X-User-Id': userId,
        },
        body: jsonEncode({
          'courseId': null, // Subscription, not course
          'paymentMethod': paymentMethod,
          'phoneNumber': phoneNumber,
          'amount': amount,
          'description': description,
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return data['data'];
      } else {
        throw Exception('Payment initiation failed');
      }
    } catch (e) {
      print('⚠️ Payment service error: $e');
      // Mock response for development
      return {
        'transactionId': 'mock-${DateTime.now().millisecondsSinceEpoch}',
        'message': 'Payment initiated (mock)',
      };
    }
  }
}
