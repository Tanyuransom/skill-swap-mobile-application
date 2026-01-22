import 'dart:convert';
import 'package:http/http.dart' as http;

/// Orange Money Cameroon API Integration
/// Docs: https://developer.orange.com/apis/orange-money-webpay/
class OrangeMoneyService {
  final String clientId;
  final String clientSecret;
  final String merchantKey;
  final bool isSandbox;

  late final String baseUrl;
  String? _accessToken;

  OrangeMoneyService({
    required this.clientId,
    required this.clientSecret,
    required this.merchantKey,
    this.isSandbox = true,
  }) {
    baseUrl = isSandbox
        ? 'https://api.orange.com/orange-money-webpay/dev/v1'
        : 'https://api.orange.com/orange-money-webpay/cm/v1';
  }

  /// Get OAuth 2.0 access token
  Future<void> _authenticate() async {
    try {
      final response = await http.post(
        Uri.parse('https://api.orange.com/oauth/v3/token'),
        headers: {
          'Authorization': 'Basic ${base64Encode(utf8.encode('$clientId:$clientSecret'))}',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {'grant_type': 'client_credentials'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _accessToken = data['access_token'];
      } else {
        throw Exception('Orange Money auth failed: ${response.body}');
      }
    } catch (e) {
      print('⚠️ Orange Money authentication error: $e');
      // For now, use mock token in development
      _accessToken = 'mock_orange_token';
    }
  }

  /// Initiate payment request
  Future<Map<String, dynamic>> initiatePayment({
    required String orderId,
    required double amount,
    required String phoneNumber,
    String? description,
  }) async {
    if (_accessToken == null) await _authenticate();

    // Mock implementation for development
    print('🍊 Orange Money: Initiating payment');
    print('   Amount: $amount XAF');
    print('   Phone: $phoneNumber');

    // In production, call actual Orange Money API
    // final response = await http.post(
    //   Uri.parse('$baseUrl/webpayment'),
    //   headers: {
    //     'Authorization': 'Bearer $_accessToken',
    //     'Content-Type': 'application/json',
    //   },
    //   body: jsonEncode({
    //     'merchant_key': merchantKey,
    //     'currency': 'XAF',
    //     'order_id': orderId,
    //     'amount': amount.toInt(),
    //     'return_url': 'https://yourapp.com/payment/callback',
    //     'cancel_url': 'https://yourapp.com/payment/cancel',
    //     'notif_url': 'https://yourapp.com/payment/webhook/orange',
    //     'lang': 'fr',
    //     'reference': orderId,
    //   }),
    // );

    // Mock response
    return {
      'status': 'pending',
      'payment_url': 'https://mock-orange-payment.com/$orderId',
      'transaction_id': 'OM${DateTime.now().millisecondsSinceEpoch}',
      'message': 'Payment initiated. Customer will receive USSD prompt.',
    };
  }

  /// Verify payment status
  Future<Map<String, dynamic>> verifyPayment(String transactionId) async {
    // Mock implementation
    print('🍊 Orange Money: Verifying payment $transactionId');
    
    return {
      'status': 'completed',
      'transaction_id': transactionId,
      'amount': 25000,
    };
  }

  /// Process payout (send money to tutor)
  Future<Map<String, dynamic>> processPayout({
    required String payoutId,
    required double amount,
    required String phoneNumber,
  }) async {
    print('🍊 Orange Money: Processing payout');
    print('   Amount: $amount XAF');
    print('   Phone: $phoneNumber');

    // Mock response
    return {
      'status': 'processing',
      'transaction_id': 'OP${DateTime.now().millisecondsSinceEpoch}',
      'estimated_arrival': DateTime.now().add(Duration(days: 2)).toIso8601String(),
    };
  }
}
