import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:skillswapp_shared/skillswapp_shared.dart';
import '../services/social_feed_service.dart';

class SocialFeedController {
  final SocialFeedService _service = SocialFeedService();

  /// POST /posts
  Future<Response> createPost(Request request) async {
    try {
      final userId = request.context['userId'] as String;
      final body = await request.readAsString();
      final data = jsonDecode(body);

      final result = await _service.createPost(
        userId: userId,
        postType: data['postType'] as String,
        title: data['title'],
        description: data['description'],
        mediaUrl: data['mediaUrl'],
        thumbnailUrl: data['thumbnailUrl'],
        duration: data['duration'] as int?,
        category: data['category'],
        isPremium: data['isPremium'] as bool? ?? false,
      );

      return ApiResponse.success(
        message: 'Post created',
        data: result,
      ).toResponse(statusCode: 201);
    } catch (e) {
      if (e is AppException) rethrow;
      return ApiResponse.error(message: 'Error: $e').toResponse(statusCode: 500);
    }
  }

  /// GET /posts/:id
  Future<Response> getPost(Request request, String postId) async {
    try {
      final userId = request.context['userId'] as String?;
      final post = await _service.getPost(postId, userId);

      return ApiResponse.success(data: post).toResponse();
    } catch (e) {
      if (e is AppException) rethrow;
      return ApiResponse.error(message: 'Error: $e').toResponse(statusCode: 500);
    }
  }

  /// GET /posts/user/:userId
  Future<Response> getUserPosts(Request request, String userId) async {
    try {
      final posts = await _service.getUserPosts(userId);

      return ApiResponse.success(data: {'posts': posts}).toResponse();
    } catch (e) {
      if (e is AppException) rethrow;
      return ApiResponse.error(message: 'Error: $e').toResponse(statusCode: 500);
    }
  }

  /// GET /feed/for-you
  Future<Response> getForYouFeed(Request request) async {
    try {
      final userId = request.context['userId'] as String;
      final params = request.url.queryParameters;
      final page = int.tryParse(params['page'] ?? '1') ?? 1;

      final result = await _service.getForYouFeed(userId, page: page);

      return ApiResponse.success(data: result).toResponse();
    } catch (e) {
      if (e is AppException) rethrow;
      return ApiResponse.error(message: 'Error: $e').toResponse(statusCode: 500);
    }
  }

  /// GET /feed/following
  Future<Response> getFollowingFeed(Request request) async {
    try {
      final userId = request.context['userId'] as String;
      final params = request.url.queryParameters;
      final page = int.tryParse(params['page'] ?? '1') ?? 1;

      final result = await _service.getFollowingFeed(userId, page: page);

      return ApiResponse.success(data: result).toResponse();
    } catch (e) {
      if (e is AppException) rethrow;
      return ApiResponse.error(message: 'Error: $e').toResponse(statusCode: 500);
    }
  }

  /// DELETE /posts/:id
  Future<Response> deletePost(Request request, String postId) async {
    try {
      final userId = request.context['userId'] as String;
      await _service.deletePost(postId, userId);

      return ApiResponse.success(message: 'Post deleted').toResponse();
    } catch (e) {
      if (e is AppException) rethrow;
      return ApiResponse.error(message: 'Error: $e').toResponse(statusCode: 500);
    }
  }

  /// POST /follow/:userId
  Future<Response> followUser(Request request, String targetUserId) async {
    try {
      final userId = request.context['userId'] as String;
      await _service.followUser(userId, targetUserId);

      return ApiResponse.success(message: 'Followed successfully').toResponse();
    } catch (e) {
      if (e is AppException) rethrow;
      return ApiResponse.error(message: 'Error: $e').toResponse(statusCode: 500);
    }
  }

  /// DELETE /unfollow/:userId
  Future<Response> unfollowUser(Request request, String targetUserId) async {
    try {
      final userId = request.context['userId'] as String;
      await _service.unfollowUser(userId, targetUserId);

      return ApiResponse.success(message: 'Unfollowed successfully').toResponse();
    } catch (e) {
      if (e is AppException) rethrow;
      return ApiResponse.error(message: 'Error: $e').toResponse(statusCode: 500);
    }
  }

  /// GET /users/:userId/stats
  Future<Response> getUserStats(Request request, String targetUserId) async {
    try {
      final userId = request.context['userId'] as String?;
      final stats = await _service.getUserStats(targetUserId, userId);

      return ApiResponse.success(data: stats).toResponse();
    } catch (e) {
      if (e is AppException) rethrow;
      return ApiResponse.error(message: 'Error: $e').toResponse(statusCode: 500);
    }
  }
}
