import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:skillswapp_shared/skillswapp_shared.dart';
import '../services/verification_service.dart';

class VerificationController {
  final VerificationService _service = VerificationService();

  /// POST /request
  Future<Response> requestVerification(Request request) async {
    try {
      final userId = request.context['userId'] as String;
      final body = await request.readAsString();
      final data = jsonDecode(body);
      
      final topic = data['topic'];
      if (topic == null || topic.toString().isEmpty) {
        throw BadRequestException('Topic is required');
      }

      final result = await _service.requestVerification(userId, topic);
      return ApiResponse.success(
        message: 'Verification requested successfully',
        data: result,
      ).toResponse();
    } catch (e) {
      if (e is AppException) rethrow; // Let middleware handle it
      return ApiResponse.error(message: 'Internal Error: $e').toResponse(statusCode: 500);
    }
  }

  /// GET /exam/:requestId
  Future<Response> getExam(Request request, String requestId) async {
    try {
      final userId = request.context['userId'] as String;
      final result = await _service.getExamQuestions(userId, requestId);
      
      return ApiResponse.success(
        message: 'Exam retrieved successfully',
        data: result,
      ).toResponse();
    } catch (e) {
      if (e is AppException) rethrow;
      return ApiResponse.error(message: 'Internal Error: $e').toResponse(statusCode: 500);
    }
  }

  /// POST /exam/:requestId/submit
  Future<Response> submitExam(Request request, String requestId) async {
    try {
      final userId = request.context['userId'] as String;
      final body = await request.readAsString();
      final data = jsonDecode(body);
      
      final answers = (data['answers'] as List).cast<int>();
      
      final result = await _service.submitExam(userId, requestId, answers);
      
      return ApiResponse.success(
        message: 'Exam submitted successfully',
        data: result,
      ).toResponse();
    } catch (e) {
      if (e is AppException) rethrow; // e.g. BadRequestException
      return ApiResponse.error(message: 'Internal Error: $e').toResponse(statusCode: 500);
    }
  }
  
  /// GET /badges/:userId
  Future<Response> getBadges(Request request, String userId) async {
    try {
       // Allow getting own badges or others? Public?
       // For now, let's assume public read.
       final badges = await _service.getBadges(userId);
       
       return ApiResponse.success(
        message: 'Badges retrieved successfully',
        data: {'badges': badges},
      ).toResponse();
    } catch (e) {
       return ApiResponse.error(message: 'Internal Error: $e').toResponse(statusCode: 500);
    }
  }
}
