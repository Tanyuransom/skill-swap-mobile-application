import 'package:skillswapp_shared/skillswapp_shared.dart';
import '../repositories/payment_repository.dart';
import 'orange_money_service.dart';
import 'mtn_momo_service.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PaymentService {
  final PaymentRepository _repository = PaymentRepository();
  late final OrangeMoneyService _orangeMoney;
  late final MtnMomoService _mtnMomo;
  
  final double platformCommission = 0.20; // 20%
  final double minimumPayout = 10000; // 10,000 XAF

  PaymentService() {
    // Initialize mobile money services
    _orangeMoney = OrangeMoneyService(
      clientId: 'mock_client_id',
      clientSecret: 'mock_secret',
      merchantKey: 'mock_merchant',
      isSandbox: true,
    );

    _mtnMomo = MtnMomoService(
      apiKey: 'mock_api_key',
      apiUser: 'mock_user',
      apiSecret: 'mock_secret',
      subscriptionKey: 'mock_subscription',
      isSandbox: true,
    );
  }

  /// Initiate payment for course purchase
  Future<Map<String, dynamic>> initiatePayment({
    required String userId,
    required String courseId,
    required String paymentMethod,
    required String phoneNumber,
  }) async {
    // Get course price
    final coursePrice = await _getCoursePrice(courseId);

    // Create transaction record
    final transactionId = await _repository.createTransaction(
      userId: userId,
      courseId: courseId,
      amount: coursePrice,
      paymentMethod: paymentMethod,
      phoneNumber: phoneNumber,
      description: 'Course purchase',
    );

    // Initiate payment with mobile money provider
    Map<String, dynamic> paymentResponse;
    
    if (paymentMethod == 'orange_money') {
      paymentResponse = await _orangeMoney.initiatePayment(
        orderId: transactionId,
        amount: coursePrice,
        phoneNumber: phoneNumber,
        description: 'SkillSwapp course payment',
      );
    } else if (paymentMethod == 'mtn_momo') {
      paymentResponse = await _mtnMomo.requestToPay(
        referenceId: transactionId,
        amount: coursePrice,
        phoneNumber: phoneNumber,
        message: 'SkillSwapp course payment',
      );
    } else {
      throw BadRequestException('Invalid payment method');
    }

    return {
      'transactionId': transactionId,
      'amount': coursePrice,
      'currency': 'XAF',
      'paymentMethod': paymentMethod,
      'message': paymentResponse['message'],
      'paymentUrl': paymentResponse['payment_url'],
    };
  }

  /// Confirm payment and process enrollment
  Future<Map<String, dynamic>> confirmPayment(String transactionId) async {
    final transaction = await _repository.getTransaction(transactionId);
    if (transaction == null) {
      throw NotFoundException('Transaction not found');
    }

    // Update transaction status
    await _repository.updateTransactionStatus(transactionId, 'completed');

    // Calculate commission and tutor earnings
    final amount = double.parse(transaction['amount'].toString());
    final commission = amount * platformCommission;
    final tutorEarnings = amount - commission;

    // Get course tutor
    final tutorId = await _getCourseTutor(transaction['course_id'].toString());

    // Credit tutor wallet
    await _repository.creditWallet(tutorId, tutorEarnings);

    // Enroll student in course
    final enrollmentId = await _enrollStudent(
      transaction['user_id'].toString(),
      transaction['course_id'].toString(),
    );

    return {
      'transactionId': transactionId,
      'status': 'completed',
      'enrollmentId': enrollmentId,
      'message': 'Payment successful! You are now enrolled.',
    };
  }

  /// Get payment history
  Future<Map<String, dynamic>> getPaymentHistory(
    String userId, {
    String? status,
  }) async {
    final transactions = await _repository.getPaymentHistory(
      userId,
      status: status,
    );

    return {
      'transactions': transactions,
      'total': transactions.length,
    };
  }

  /// Get wallet balance
  Future<Map<String, dynamic>> getWallet(String userId) async {
    final wallet = await _repository.getOrCreateWallet(userId);
    
    return {
      'balance': double.parse(wallet['balance'].toString()),
      'pendingBalance': double.parse(wallet['pending_balance'].toString()),
      'totalEarned': double.parse(wallet['total_earned'].toString()),
      'totalWithdrawn': double.parse(wallet['total_withdrawn'].toString()),
      'currency': wallet['currency'],
    };
  }

  /// Request payout
  Future<Map<String, dynamic>> requestPayout({
    required String userId,
    required double amount,
    required String paymentMethod,
    required String phoneNumber,
  }) async {
    // Get wallet
    final wallet = await _repository.getOrCreateWallet(userId);
    final balance = double.parse(wallet['balance'].toString());

    // Validate amount
    if (amount < minimumPayout) {
      throw BadRequestException('Minimum payout is $minimumPayout XAF');
    }

    if (amount > balance) {
      throw BadRequestException('Insufficient balance');
    }

    // Create payout record
    final payoutId = await _repository.createPayout(
      userId: userId,
      amount: amount,
      paymentMethod: paymentMethod,
      phoneNumber: phoneNumber,
    );

    // Debit wallet
    await _repository.debitWallet(userId, amount);

    // Process payout with mobile money
    Map<String, dynamic> payoutResponse;
    
    if (paymentMethod == 'orange_money') {
      payoutResponse = await _orangeMoney.processPayout(
        payoutId: payoutId,
        amount: amount,
        phoneNumber: phoneNumber,
      );
    } else if (paymentMethod == 'mtn_momo') {
      payoutResponse = await _mtnMomo.transfer(
        referenceId: payoutId,
        amount: amount,
        phoneNumber: phoneNumber,
      );
    } else {
      throw BadRequestException('Invalid payment method');
    }

    // Update payout status
    await _repository.updatePayoutStatus(
      payoutId,
      'processing',
      operatorTransactionId: payoutResponse['transaction_id'],
    );

    return {
      'payoutId': payoutId,
      'amount': amount,
      'status': 'processing',
      'estimatedArrival': DateTime.now().add(Duration(days: 2)).toIso8601String(),
    };
  }

  /// Helper: Get course price
  Future<double> _getCoursePrice(String courseId) async {
    final result = await PostgresClient.execute(
      'SELECT price FROM courses WHERE id = @courseId',
      parameters: {'courseId': courseId},
    );

    if (result.isEmpty) {
      throw NotFoundException('Course not found');
    }

    return double.parse(result.first.toColumnMap()['price'].toString());
  }

  /// Helper: Get course tutor
  Future<String> _getCourseTutor(String courseId) async {
    final result = await PostgresClient.execute(
      'SELECT tutor_id FROM courses WHERE id = @courseId',
      parameters: {'courseId': courseId},
    );

    if (result.isEmpty) {
      throw NotFoundException('Course not found');
    }

    return result.first.toColumnMap()['tutor_id'].toString();
  }

  /// Helper: Enroll student in course
  Future<String> _enrollStudent(String userId, String courseId) async {
    try {
      // Call Learning Service to enroll
      final response = await http.post(
        Uri.parse('http://localhost:8085/enroll/$courseId'),
        headers: {
          'Content-Type': 'application/json',
          'X-User-Id': userId, // Internal service call
        },
        body: jsonEncode({'totalLessons': 10}), // Default, should get from course
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return data['data']['enrollmentId'];
      } else {
        throw Exception('Enrollment failed');
      }
    } catch (e) {
      print('⚠️ Enrollment error: $e');
      return 'enrollment_pending';
    }
  }
}
