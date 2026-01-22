import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:skillswapp_shared/skillswapp_shared.dart';
import '../repositories/notification_repository.dart';

class NotificationRoutes {
  final NotificationRepository _repository = NotificationRepository();

  Router get router {
    final router = Router();

    // Get notifications
    router.get('/notifications', (Request request) async {
      final userId = request.context['userId'] as String;
      final notifications = await _repository.getNotifications(userId);
      return ApiResponse.success(data: {'notifications': notifications}).toResponse();
    });

    // Get unread count
    router.get('/notifications/unread-count', (Request request) async {
      final userId = request.context['userId'] as String;
      final count = await _repository.getUnreadCount(userId);
      return ApiResponse.success(data: {'count': count}).toResponse();
    });

    // Mark as read
    router.put('/notifications/<notificationId>/read', (Request request, String notificationId) async {
      await _repository.markAsRead(notificationId);
      return ApiResponse.success(message: 'Marked as read').toResponse();
    });

    // Mark all as read
    router.put('/notifications/read-all', (Request request) async {
      final userId = request.context['userId'] as String;
      await _repository.markAllAsRead(userId);
      return ApiResponse.success(message: 'All marked as read').toResponse();
    });

    // Delete notification
    router.delete('/notifications/<notificationId>', (Request request, String notificationId) async {
      await _repository.deleteNotification(notificationId);
      return ApiResponse.success(message: 'Notification deleted').toResponse();
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
