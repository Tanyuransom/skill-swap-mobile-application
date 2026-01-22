import 'package:skillswapp_shared/skillswapp_shared.dart';

class NotificationRepository {
  /// Create notification
  Future<String> createNotification({
    required String userId,
    required String notificationType,
    required String title,
    required String message,
    String? actionUrl,
    String? actorId,
  }) async {
    final result = await PostgresClient.execute(
      '''
      INSERT INTO notifications (user_id, notification_type, title, message, action_url, actor_id)
      VALUES (@userId, @notificationType, @title, @message, @actionUrl, @actorId)
      RETURNING id
      ''',
      parameters: {
        'userId': userId,
        'notificationType': notificationType,
        'title': title,
        'message': message,
        'actionUrl': actionUrl,
        'actorId': actorId,
      },
    );

    return result.first.toColumnMap()['id'].toString();
  }

  /// Get notifications
  Future<List<Map<String, dynamic>>> getNotifications(String userId, {int limit = 50}) async {
    final result = await PostgresClient.execute(
      '''
      SELECT n.*, u.full_name as actor_name, u.profile_picture_url as actor_picture
      FROM notifications n
      LEFT JOIN users u ON n.actor_id = u.id
      WHERE n.user_id = @userId
      ORDER BY n.created_at DESC
      LIMIT @limit
      ''',
      parameters: {'userId': userId, 'limit': limit},
    );

    return result.map((row) => row.toColumnMap()).toList();
  }

  /// Mark as read
  Future<void> markAsRead(String notificationId) async {
    await PostgresClient.execute(
      'UPDATE notifications SET is_read = true WHERE id = @notificationId',
      parameters: {'notificationId': notificationId},
    );
  }

  /// Mark all as read
  Future<void> markAllAsRead(String userId) async {
    await PostgresClient.execute(
      'UPDATE notifications SET is_read = true WHERE user_id = @userId',
      parameters: {'userId': userId},
    );
  }

  /// Get unread count
  Future<int> getUnreadCount(String userId) async {
    final result = await PostgresClient.execute(
      'SELECT COUNT(*) as count FROM notifications WHERE user_id = @userId AND is_read = false',
      parameters: {'userId': userId},
    );

    return result.first.toColumnMap()['count'] as int;
  }

  /// Delete notification
  Future<void> deleteNotification(String notificationId) async {
    await PostgresClient.execute(
      'DELETE FROM notifications WHERE id = @notificationId',
      parameters: {'notificationId': notificationId},
    );
  }
}
