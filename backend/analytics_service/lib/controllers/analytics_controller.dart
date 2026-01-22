import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:skillswapp_shared/skillswapp_shared.dart';
import '../services/analytics_service.dart';

class AnalyticsController {
  final AnalyticsService _service = AnalyticsService();

  /// POST /analytics/track
  Future<Response> trackView(Request request) async {
    try {
      final userId = request.context['userId'] as String;
      final body = await request.readAsString();
      final data = jsonDecode(body);

      final lessonId = data['lessonId'] as String?;
      final watchDuration = data['watchDuration'] as int?;
      final completed = data['completed'] as bool? ?? false;
      final liked = data['liked'] as bool? ?? false;
      final shared = data['shared'] as bool? ?? false;

      if (lessonId == null || watchDuration == null) {
        throw BadRequestException('lessonId and watchDuration are required');
      }

      await _service.trackView(
        lessonId: lessonId,
        userId: userId,
        watchDuration: watchDuration,
        completed: completed,
        liked: liked,
        shared: shared,
      );

      return ApiResponse.success(
        message: 'View tracked',
      ).toResponse();
    } catch (e) {
      if (e is AppException) rethrow;
      return ApiResponse.error(message: 'Internal Error: $e').toResponse(statusCode: 500);
    }
  }

  /// GET /analytics/tutor/dashboard
  Future<Response> getTutorDashboard(Request request) async {
    try {
      final userId = request.context['userId'] as String;
      
      final result = await _service.getTutorDashboard(userId);

      return ApiResponse.success(
        message: 'Dashboard retrieved',
        data: result,
      ).toResponse();
    } catch (e) {
      if (e is AppException) rethrow;
      return ApiResponse.error(message: 'Internal Error: $e').toResponse(statusCode: 500);
    }
  }

  /// POST /tutors/:tutorId/follow
  Future<Response> followTutor(Request request, String tutorId) async {
    try {
      final userId = request.context['userId'] as String;
      
      await _service.followTutor(tutorId, userId);

      return ApiResponse.success(
        message: 'Followed successfully',
      ).toResponse();
    } catch (e) {
      if (e is AppException) rethrow;
      return ApiResponse.error(message: 'Internal Error: $e').toResponse(statusCode: 500);
    }
  }

  /// DELETE /tutors/:tutorId/follow
  Future<Response> unfollowTutor(Request request, String tutorId) async {
    try {
      final userId = request.context['userId'] as String;
      
      await _service.unfollowTutor(tutorId, userId);

      return ApiResponse.success(
        message: 'Unfollowed successfully',
      ).toResponse();
    } catch (e) {
      if (e is AppException) rethrow;
      return ApiResponse.error(message: 'Internal Error: $e').toResponse(statusCode: 500);
    }
  }
}
