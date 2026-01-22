import 'dart:convert';
import 'package:http/http.dart' as http;

/// MTN Mobile Money Cameroon API Integration
/// Docs: https://momodeveloper.mtn.com/
class MtnMomoService {
  final String apiKey;
  final String apiUser;
  final String apiSecret;
  final String subscriptionKey;
  final bool isSandbox;

  late final String baseUrl;

  MtnMomoService({
    required this.apiKey,
    required this.apiUser,
    required this.apiSecret,
    required this.subscriptionKey,
    this.isSandbox = true,
  }) {
    baseUrl = isSandbox
        ? 'https://sandbox.momodeveloper.mtn.com'
        : 'https://momodeveloper.mtn.com';
  }

  /// Get API token
  Future<String> _getToken() async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/collection/token/'),
        headers: {
          'Authorization': 'Basic ${base64Encode(utf8.encode('$apiUser:$apiSecret'))}',
          'Ocp-Apim-Subscription-Key': subscriptionKey,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['access_token'];
      } else {
        throw Exception('MTN MoMo auth failed: ${response.body}');
      }
    } catch (e) {
      print('⚠️ MTN MoMo authentication error: $e');
      return 'mock_mtn_token';
    }
  }

  /// Request to pay (collect payment from customer)
  Future<Map<String, dynamic>> requestToPay({
    required String referenceId,
    required double amount,
    required String phoneNumber,
    String? message,
  }) async {
    final token = await _getToken();

    // Mock implementation for development
    print('📱 MTN MoMo: Requesting payment');
    print('   Amount: $amount XAF');
    print('   Phone: $phoneNumber');

    // In production, call actual MTN API
    // final response = await http.post(
    //   Uri.parse('$baseUrl/collection/v1_0/requesttopay'),
    //   headers: {
    //     'Authorization': 'Bearer $token',
    //     'X-Reference-Id': referenceId,
    //     'X-Target-Environment': isSandbox ? 'sandbox' : 'production',
    //     'Ocp-Apim-Subscription-Key': subscriptionKey,
    //     'Content-Type': 'application/json',
    //   },
    //   body: jsonEncode({
    //     'amount': amount.toString(),
    //     'currency': 'XAF',
    //     'externalId': referenceId,
    //     'payer': {
    //       'partyIdType': 'MSISDN',
    //       'partyId': phoneNumber,
    //     },
    //     'payerMessage': message ?? 'Payment for course',
    //     'payeeNote': 'SkillSwapp course payment',
    //   }),
    // );

    // Mock response
    return {
      'status': 'pending',
      'reference_id': referenceId,
      'transaction_id': 'MTN${DateTime.now().millisecondsSinceEpoch}',
      'message': 'Payment request sent to customer',
    };
  }

  /// Check payment status
  Future<Map<String, dynamic>> getTransactionStatus(String referenceId) async {
    final token = await _getToken();

    print('📱 MTN MoMo: Checking transaction $referenceId');

    // Mock response
    return {
      'status': 'SUCCESSFUL',
      'amount': 25000,
      'currency': 'XAF',
      'financialTransactionId': referenceId,
    };
  }

  /// Transfer money (payout to tutor)
  Future<Map<String, dynamic>> transfer({
    required String referenceId,
    required double amount,
    required String phoneNumber,
  }) async {
    print('📱 MTN MoMo: Processing transfer');
    print('   Amount: $amount XAF');
    print('   Phone: $phoneNumber');

    // Mock response
    return {
      'status': 'processing',
      'reference_id': referenceId,
      'transaction_id': 'MTNT${DateTime.now().millisecondsSinceEpoch}',
    };
  }
}
