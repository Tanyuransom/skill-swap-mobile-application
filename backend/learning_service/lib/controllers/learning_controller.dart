import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:skillswapp_shared/skillswapp_shared.dart';
import '../services/learning_service.dart';

class LearningController {
  final LearningService _service = LearningService();

  /// POST /enroll/:courseId
  Future<Response> enrollInCourse(Request request, String courseId) async {
    try {
      final userId = request.context['userId'] as String;
      
      // Parse request body for total lessons count
      final body = await request.readAsString();
      final data = jsonDecode(body);
      final totalLessons = data['totalLessons'] as int? ?? 0;

      if (totalLessons <= 0) {
        throw BadRequestException('totalLessons must be greater than 0');
      }

      final result = await _service.enrollInCourse(userId, courseId, totalLessons);
      
      return ApiResponse.success(
        message: 'Enrolled successfully',
        data: result,
      ).toResponse(statusCode: 201);
    } catch (e) {
      if (e is AppException) rethrow;
      return ApiResponse.error(message: 'Internal Error: $e').toResponse(statusCode: 500);
    }
  }

  /// GET /enrollments
  Future<Response> getEnrollments(Request request) async {
    try {
      final userId = request.context['userId'] as String;
      final params = request.url.queryParameters;
      
      final status = params['status'];
      final sort = params['sort'] ?? 'enrolled_at';

      final result = await _service.getEnrollments(
        userId,
        status: status,
        sort: sort,
      );

      return ApiResponse.success(
        message: 'Enrollments retrieved successfully',
        data: result,
      ).toResponse();
    } catch (e) {
      if (e is AppException) rethrow;
      return ApiResponse.error(message: 'Internal Error: $e').toResponse(statusCode: 500);
    }
  }

  /// GET /progress/:courseId
  Future<Response> getCourseProgress(Request request, String courseId) async {
    try {
      final userId = request.context['userId'] as String;
      
      final result = await _service.getCourseProgress(userId, courseId);

      return ApiResponse.success(
        message: 'Progress retrieved successfully',
        data: result,
      ).toResponse();
    } catch (e) {
      if (e is AppException) rethrow;
      return ApiResponse.error(message: 'Internal Error: $e').toResponse(statusCode: 500);
    }
  }

  /// POST /progress
  Future<Response> updateProgress(Request request) async {
    try {
      final userId = request.context['userId'] as String;
      final body = await request.readAsString();
      final data = jsonDecode(body);

      final enrollmentId = data['enrollmentId'] as String?;
      final lessonId = data['lessonId'] as String?;
      final watchDuration = data['watchDuration'] as int?;

      if (enrollmentId == null || lessonId == null) {
        throw BadRequestException('enrollmentId and lessonId are required');
      }

      await _service.updateProgress(
        userId,
        enrollmentId,
        lessonId,
        watchDuration: watchDuration,
      );

      return ApiResponse.success(
        message: 'Progress updated',
      ).toResponse();
    } catch (e) {
      if (e is AppException) rethrow;
      return ApiResponse.error(message: 'Internal Error: $e').toResponse(statusCode: 500);
    }
  }

  /// POST /complete/:lessonId
  Future<Response> markLessonComplete(Request request, String lessonId) async {
    try {
      final userId = request.context['userId'] as String;
      final body = await request.readAsString();
      final data = jsonDecode(body);

      final courseId = data['courseId'] as String?;
      if (courseId == null) {
        throw BadRequestException('courseId is required');
      }

      final result = await _service.markLessonComplete(userId, lessonId, courseId);

      return ApiResponse.success(
        message: 'Lesson marked complete',
        data: result,
      ).toResponse();
    } catch (e) {
      if (e is AppException) rethrow;
      return ApiResponse.error(message: 'Internal Error: $e').toResponse(statusCode: 500);
    }
  }

  /// DELETE /enroll/:enrollmentId
  Future<Response> dropEnrollment(Request request, String enrollmentId) async {
    try {
      final userId = request.context['userId'] as String;

      await _service.dropEnrollment(userId, enrollmentId);

      return ApiResponse.success(
        message: 'Successfully unenrolled from course',
      ).toResponse();
    } catch (e) {
      if (e is AppException) rethrow;
      return ApiResponse.error(message: 'Internal Error: $e').toResponse(statusCode: 500);
    }
  }
}
