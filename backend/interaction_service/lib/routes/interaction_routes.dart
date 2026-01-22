import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:skillswapp_shared/skillswapp_shared.dart';
import '../repositories/interaction_repository.dart';

class InteractionRoutes {
  final InteractionRepository _repository = InteractionRepository();

  Router get router {
    final router = Router();

    // Like/Unlike
    router.post('/like', (Request request) async {
      final userId = request.context['userId'] as String;
      final body = jsonDecode(await request.readAsString());
      await _repository.like(userId, body['targetType'], body['targetId']);
      return ApiResponse.success(message: 'Liked').toResponse();
    });

    router.delete('/unlike', (Request request) async {
      final userId = request.context['userId'] as String;
      final body = jsonDecode(await request.readAsString());
      await _repository.unlike(userId, body['targetType'], body['targetId']);
      return ApiResponse.success(message: 'Unliked').toResponse();
    });

    // Comments
    router.post('/comment', (Request request) async {
      final userId = request.context['userId'] as String;
      final body = jsonDecode(await request.readAsString());
      final commentId = await _repository.addComment(
        userId: userId,
        targetType: body['targetType'],
        targetId: body['targetId'],
        content: body['content'],
        parentCommentId: body['parentCommentId'],
      );
      return ApiResponse.success(data: {'id': commentId}).toResponse(statusCode: 201);
    });

    router.get('/comments/<targetType>/<targetId>', (Request request, String targetType, String targetId) async {
      final comments = await _repository.getComments(targetType, targetId);
      return ApiResponse.success(data: {'comments': comments}).toResponse();
    });

    // Share
    router.post('/share', (Request request) async {
      final userId = request.context['userId'] as String;
      final body = jsonDecode(await request.readAsString());
      await _repository.share(
        userId: userId,
        targetType: body['targetType'],
        targetId: body['targetId'],
        shareType: body['shareType'],
        recipientId: body['recipientId'],
      );
      return ApiResponse.success(message: 'Shared').toResponse();
    });

    // Save/Unsave
    router.post('/save', (Request request) async {
      final userId = request.context['userId'] as String;
      final body = jsonDecode(await request.readAsString());
      await _repository.save(userId, body['targetType'], body['targetId']);
      return ApiResponse.success(message: 'Saved').toResponse();
    });

    router.delete('/unsave', (Request request) async {
      final userId = request.context['userId'] as String;
      final body = jsonDecode(await request.readAsString());
      await _repository.unsave(userId, body['targetType'], body['targetId']);
      return ApiResponse.success(message: 'Unsaved').toResponse();
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
