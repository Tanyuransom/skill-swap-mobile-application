import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:skillswapp_shared/skillswapp_shared.dart';
import '../repositories/reels_repository.dart';

class ReelsController {
  final ReelsRepository _repository = ReelsRepository();

  /// POST /reels
  Future<Response> createReel(Request request) async {
    try {
      final userId = request.context['userId'] as String;
      final body = await request.readAsString();
      final data = jsonDecode(body);

      if (data['videoUrl'] == null) {
        throw BadRequestException('videoUrl is required');
      }

      final duration = data['duration'] as int?;
      if (duration == null || duration < 15 || duration > 60) {
        throw BadRequestException('Duration must be between 15 and 60 seconds');
      }

      final reelId = await _repository.createReel(
        userId: userId,
        videoUrl: data['videoUrl'],
        thumbnailUrl: data['thumbnailUrl'],
        title: data['title'],
        description: data['description'],
        duration: duration,
        category: data['category'],
      );

      return ApiResponse.success(
        message: 'Reel created',
        data: {'id': reelId},
      ).toResponse(statusCode: 201);
    } catch (e) {
      if (e is AppException) rethrow;
      return ApiResponse.error(message: 'Error: $e').toResponse(statusCode: 500);
    }
  }

  /// GET /reels/feed
  Future<Response> getReelsFeed(Request request) async {
    try {
      final params = request.url.queryParameters;
      final page = int.tryParse(params['page'] ?? '1') ?? 1;
      final limit = 20;
      final offset = (page - 1) * limit;

      final reels = await _repository.getReelsFeed(limit: limit, offset: offset);

      return ApiResponse.success(data: {
        'reels': reels,
        'page': page,
        'hasMore': reels.length == limit,
      }).toResponse();
    } catch (e) {
      if (e is AppException) rethrow;
      return ApiResponse.error(message: 'Error: $e').toResponse(statusCode: 500);
    }
  }

  /// POST /reels/:id/view
  Future<Response> trackView(Request request, String reelId) async {
    try {
      final body = await request.readAsString();
      final data = jsonDecode(body);
      final completed = data['completed'] as bool? ?? false;

      await _repository.trackView(reelId, completed);

      return ApiResponse.success(message: 'View tracked').toResponse();
    } catch (e) {
      if (e is AppException) rethrow;
      return ApiResponse.error(message: 'Error: $e').toResponse(statusCode: 500);
    }
  }
}
