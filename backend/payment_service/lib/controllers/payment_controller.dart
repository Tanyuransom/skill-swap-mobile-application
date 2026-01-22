import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:skillswapp_shared/skillswapp_shared.dart';
import '../services/payment_service.dart';

class PaymentController {
  final PaymentService _service = PaymentService();

  /// POST /payment/initiate
  Future<Response> initiatePayment(Request request) async {
    try {
      final userId = request.context['userId'] as String;
      final body = await request.readAsString();
      final data = jsonDecode(body);

      final courseId = data['courseId'] as String?;
      final paymentMethod = data['paymentMethod'] as String?;
      final phoneNumber = data['phoneNumber'] as String?;

      if (courseId == null || paymentMethod == null || phoneNumber == null) {
        throw BadRequestException('courseId, paymentMethod, and phoneNumber are required');
      }

      final result = await _service.initiatePayment(
        userId: userId,
        courseId: courseId,
        paymentMethod: paymentMethod,
        phoneNumber: phoneNumber,
      );

      return ApiResponse.success(
        message: 'Payment initiated',
        data: result,
      ).toResponse(statusCode: 201);
    } catch (e) {
      if (e is AppException) rethrow;
      return ApiResponse.error(message: 'Internal Error: $e').toResponse(statusCode: 500);
    }
  }

  /// POST /payment/confirm/:transactionId
  Future<Response> confirmPayment(Request request, String transactionId) async {
    try {
      final result = await _service.confirmPayment(transactionId);

      return ApiResponse.success(
        message: 'Payment confirmed',
        data: result,
      ).toResponse();
    } catch (e) {
      if (e is AppException) rethrow;
      return ApiResponse.error(message: 'Internal Error: $e').toResponse(statusCode: 500);
    }
  }

  /// GET /payment/history
  Future<Response> getPaymentHistory(Request request) async {
    try {
      final userId = request.context['userId'] as String;
      final params = request.url.queryParameters;
      final status = params['status'];

      final result = await _service.getPaymentHistory(userId, status: status);

      return ApiResponse.success(
        message: 'Payment history retrieved',
        data: result,
      ).toResponse();
    } catch (e) {
      if (e is AppException) rethrow;
      return ApiResponse.error(message: 'Internal Error: $e').toResponse(statusCode: 500);
    }
  }

  /// GET /wallet
  Future<Response> getWallet(Request request) async {
    try {
      final userId = request.context['userId'] as String;
      
      final result = await _service.getWallet(userId);

      return ApiResponse.success(
        message: 'Wallet retrieved',
        data: result,
      ).toResponse();
    } catch (e) {
      if (e is AppException) rethrow;
      return ApiResponse.error(message: 'Internal Error: $e').toResponse(statusCode: 500);
    }
  }

  /// POST /payout
  Future<Response> requestPayout(Request request) async {
    try {
      final userId = request.context['userId'] as String;
      final body = await request.readAsString();
      final data = jsonDecode(body);

      final amount = (data['amount'] as num?)?.toDouble();
      final paymentMethod = data['paymentMethod'] as String?;
      final phoneNumber = data['phoneNumber'] as String?;

      if (amount == null || paymentMethod == null || phoneNumber == null) {
        throw BadRequestException('amount, paymentMethod, and phoneNumber are required');
      }

      final result = await _service.requestPayout(
        userId: userId,
        amount: amount,
        paymentMethod: paymentMethod,
        phoneNumber: phoneNumber,
      );

      return ApiResponse.success(
        message: 'Payout requested',
        data: result,
      ).toResponse(statusCode: 201);
    } catch (e) {
      if (e is AppException) rethrow;
      return ApiResponse.error(message: 'Internal Error: $e').toResponse(statusCode: 500);
    }
  }
}
