import 'package:skillswapp_shared/skillswapp_shared.dart';

class MessagingRepository {
  /// Create or get direct conversation
  Future<String> getOrCreateConversation(String userId1, String userId2) async {
    // Check if conversation exists
    final existing = await PostgresClient.execute(
      '''
      SELECT c.id FROM conversations c
      JOIN conversation_participants cp1 ON c.id = cp1.conversation_id
      JOIN conversation_participants cp2 ON c.id = cp2.conversation_id
      WHERE c.conversation_type = 'direct'
      AND cp1.user_id = @userId1
      AND cp2.user_id = @userId2
      LIMIT 1
      ''',
      parameters: {'userId1': userId1, 'userId2': userId2},
    );

    if (existing.isNotEmpty) {
      return existing.first.toColumnMap()['id'].toString();
    }

    // Create new conversation
    final convResult = await PostgresClient.execute(
      '''
      INSERT INTO conversations (conversation_type, created_by)
      VALUES ('direct', @userId1)
      RETURNING id
      ''',
      parameters: {'userId1': userId1},
    );

    final conversationId = convResult.first.toColumnMap()['id'].toString();

    // Add participants
    await PostgresClient.execute(
      '''
      INSERT INTO conversation_participants (conversation_id, user_id)
      VALUES (@conversationId, @userId1), (@conversationId, @userId2)
      ''',
      parameters: {
        'conversationId': conversationId,
        'userId1': userId1,
        'userId2': userId2,
      },
    );

    return conversationId;
  }

  /// Get user conversations
  Future<List<Map<String, dynamic>>> getUserConversations(String userId) async {
    final result = await PostgresClient.execute(
      '''
      SELECT c.*, 
        (SELECT COUNT(*) FROM messages m WHERE m.conversation_id = c.id AND m.is_read = false AND m.sender_id != @userId) as unread_count,
        (SELECT content FROM messages m WHERE m.conversation_id = c.id ORDER BY m.created_at DESC LIMIT 1) as last_message
      FROM conversations c
      JOIN conversation_participants cp ON c.id = cp.conversation_id
      WHERE cp.user_id = @userId
      ORDER BY c.updated_at DESC
      ''',
      parameters: {'userId': userId},
    );

    return result.map((row) => row.toColumnMap()).toList();
  }

  /// Send message
  Future<String> sendMessage({
    required String conversationId,
    required String senderId,
    required String messageType,
    String? content,
    String? mediaUrl,
    String? sharedContentId,
  }) async {
    final result = await PostgresClient.execute(
      '''
      INSERT INTO messages (conversation_id, sender_id, message_type, content, media_url, shared_content_id)
      VALUES (@conversationId, @senderId, @messageType, @content, @mediaUrl, @sharedContentId)
      RETURNING id
      ''',
      parameters: {
        'conversationId': conversationId,
        'senderId': senderId,
        'messageType': messageType,
        'content': content,
        'mediaUrl': mediaUrl,
        'sharedContentId': sharedContentId,
      },
    );

    // Update conversation timestamp
    await PostgresClient.execute(
      'UPDATE conversations SET updated_at = CURRENT_TIMESTAMP WHERE id = @conversationId',
      parameters: {'conversationId': conversationId},
    );

    return result.first.toColumnMap()['id'].toString();
  }

  /// Get messages
  Future<List<Map<String, dynamic>>> getMessages(String conversationId, {int limit = 50}) async {
    final result = await PostgresClient.execute(
      '''
      SELECT m.*, u.full_name as sender_name, u.profile_picture_url
      FROM messages m
      JOIN users u ON m.sender_id = u.id
      WHERE m.conversation_id = @conversationId
      ORDER BY m.created_at DESC
      LIMIT @limit
      ''',
      parameters: {'conversationId': conversationId, 'limit': limit},
    );

    return result.map((row) => row.toColumnMap()).toList();
  }

  /// Mark as read
  Future<void> markAsRead(String conversationId, String userId) async {
    await PostgresClient.execute(
      '''
      UPDATE messages
      SET is_read = true
      WHERE conversation_id = @conversationId AND sender_id != @userId
      ''',
      parameters: {'conversationId': conversationId, 'userId': userId},
    );
  }
}
