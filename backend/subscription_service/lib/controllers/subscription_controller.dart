import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:skillswapp_shared/skillswapp_shared.dart';
import '../services/subscription_service.dart';

class SubscriptionController {
  final SubscriptionService _service = SubscriptionService();

  /// POST /subscribe
  Future<Response> subscribe(Request request) async {
    try {
      final userId = request.context['userId'] as String;
      final body = await request.readAsString();
      final data = jsonDecode(body);

      final paymentMethod = data['paymentMethod'] as String?;
      final phoneNumber = data['phoneNumber'] as String?;

      if (paymentMethod == null || phoneNumber == null) {
        throw BadRequestException('paymentMethod and phoneNumber are required');
      }

      final result = await _service.subscribe(
        userId: userId,
        paymentMethod: paymentMethod,
        phoneNumber: phoneNumber,
      );

      return ApiResponse.success(
        message: 'Subscription initiated - Complete payment on your phone',
        data: result,
      ).toResponse(statusCode: 201);
    } catch (e) {
      if (e is AppException) rethrow;
      return ApiResponse.error(message: 'Internal Error: $e').toResponse(statusCode: 500);
    }
  }

  /// GET /subscription/status
  Future<Response> getStatus(Request request) async {
    try {
      final userId = request.context['userId'] as String;
      
      final result = await _service.getSubscriptionStatus(userId);

      return ApiResponse.success(
        message: 'Subscription status retrieved',
        data: result,
      ).toResponse();
    } catch (e) {
      if (e is AppException) rethrow;
      return ApiResponse.error(message: 'Internal Error: $e').toResponse(statusCode: 500);
    }
  }

  /// POST /subscription/cancel
  Future<Response> cancelSubscription(Request request) async {
    try {
      final userId = request.context['userId'] as String;
      
      await _service.cancelSubscription(userId);

      return ApiResponse.success(
        message: 'Subscription cancelled - Access until end of billing period',
      ).toResponse();
    } catch (e) {
      if (e is AppException) rethrow;
      return ApiResponse.error(message: 'Internal Error: $e').toResponse(statusCode: 500);
    }
  }

  /// GET /content/:lessonId/access
  Future<Response> checkContentAccess(Request request, String lessonId) async {
    try {
      final userId = request.context['userId'] as String;
      
      // Check if lesson is premium
      final lessonResult = await PostgresClient.execute(
        'SELECT is_free, is_premium FROM lessons WHERE id = @lessonId',
        parameters: {'lessonId': lessonId},
      );

      if (lessonResult.isEmpty) {
        throw NotFoundException('Lesson not found');
      }

      final lesson = lessonResult.first.toColumnMap();
      final isFree = lesson['is_free'] as bool;
      final isPremium = lesson['is_premium'] as bool;

      if (isFree) {
        return ApiResponse.success(
          message: 'Access granted',
          data: {'canAccess': true, 'reason': 'free_content'},
        ).toResponse();
      }

      if (isPremium) {
        final hasSubscription = await _service.canAccessPremiumContent(userId);
        
        if (hasSubscription) {
          return ApiResponse.success(
            message: 'Access granted',
            data: {'canAccess': true, 'reason': 'active_subscription'},
          ).toResponse();
        } else {
          return ApiResponse.success(
            message: 'Premium subscription required',
            data: {
              'canAccess': false,
              'reason': 'no_subscription',
              'subscriptionPrice': 2500,
              'currency': 'XAF',
            },
          ).toResponse();
        }
      }

      return ApiResponse.success(
        message: 'Access granted',
        data: {'canAccess': true, 'reason': 'default'},
      ).toResponse();
    } catch (e) {
      if (e is AppException) rethrow;
      return ApiResponse.error(message: 'Internal Error: $e').toResponse(statusCode: 500);
    }
  }
}
