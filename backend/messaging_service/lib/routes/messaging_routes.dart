import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:skillswapp_shared/skillswapp_shared.dart';
import '../repositories/messaging_repository.dart';

class MessagingRoutes {
  final MessagingRepository _repository = MessagingRepository();

  Router get router {
    final router = Router();

    // Get conversations
    router.get('/conversations', (Request request) async {
      final userId = request.context['userId'] as String;
      final conversations = await _repository.getUserConversations(userId);
      return ApiResponse.success(data: {'conversations': conversations}).toResponse();
    });

    // Create/get conversation
    router.post('/conversations', (Request request) async {
      final userId = request.context['userId'] as String;
      final body = jsonDecode(await request.readAsString());
      final recipientId = body['recipientId'] as String;
      
      final conversationId = await _repository.getOrCreateConversation(userId, recipientId);
      return ApiResponse.success(data: {'conversationId': conversationId}).toResponse();
    });

    // Get messages
    router.get('/conversations/<conversationId>/messages', (Request request, String conversationId) async {
      final messages = await _repository.getMessages(conversationId);
      return ApiResponse.success(data: {'messages': messages}).toResponse();
    });

    // Send message
    router.post('/messages', (Request request) async {
      final userId = request.context['userId'] as String;
      final body = jsonDecode(await request.readAsString());
      
      final messageId = await _repository.sendMessage(
        conversationId: body['conversationId'],
        senderId: userId,
        messageType: body['messageType'] ?? 'text',
        content: body['content'],
        mediaUrl: body['mediaUrl'],
        sharedContentId: body['sharedContentId'],
      );

      return ApiResponse.success(data: {'messageId': messageId}).toResponse(statusCode: 201);
    });

    // Mark as read
    router.put('/conversations/<conversationId>/read', (Request request, String conversationId) async {
      final userId = request.context['userId'] as String;
      await _repository.markAsRead(conversationId, userId);
      return ApiResponse.success(message: 'Marked as read').toResponse();
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
