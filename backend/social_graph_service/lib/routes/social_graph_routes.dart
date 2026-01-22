import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:skillswapp_shared/skillswapp_shared.dart';
import '../repositories/social_graph_repository.dart';

class SocialGraphRoutes {
  final SocialGraphRepository _repository = SocialGraphRepository();

  Router get router {
    final router = Router();

    // Send friend request
    router.post('/friends/request', (Request request) async {
      final userId = request.context['userId'] as String;
      final body = jsonDecode(await request.readAsString());
      final friendId = body['friendId'] as String;
      
      final requestId = await _repository.sendFriendRequest(userId, friendId);
      return ApiResponse.success(data: {'requestId': requestId}).toResponse(statusCode: 201);
    });

    // Accept friend request
    router.post('/friends/accept/<requestId>', (Request request, String requestId) async {
      await _repository.acceptFriendRequest(requestId);
      return ApiResponse.success(message: 'Friend request accepted').toResponse();
    });

    // Reject friend request
    router.post('/friends/reject/<requestId>', (Request request, String requestId) async {
      await _repository.rejectFriendRequest(requestId);
      return ApiResponse.success(message: 'Friend request rejected').toResponse();
    });

    // Get friend requests
    router.get('/friends/requests', (Request request) async {
      final userId = request.context['userId'] as String;
      final requests = await _repository.getFriendRequests(userId);
      return ApiResponse.success(data: {'requests': requests}).toResponse();
    });

    // Get friends
    router.get('/friends', (Request request) async {
      final userId = request.context['userId'] as String;
      final friends = await _repository.getFriends(userId);
      return ApiResponse.success(data: {'friends': friends}).toResponse();
    });

    // Unfriend
    router.delete('/friends/<friendId>', (Request request, String friendId) async {
      final userId = request.context['userId'] as String;
      await _repository.unfriend(userId, friendId);
      return ApiResponse.success(message: 'Unfriended').toResponse();
    });

    return router;
  }

  Handler get handler {
    final router = this.router;
    final pipeline = Pipeline()
        .addMiddleware(corsMiddleware())
        .addMiddleware(loggingMiddleware())
        .addMiddleware(authMiddleware())
        .addHandler(router.call);
    return pipeline;
  }
}
