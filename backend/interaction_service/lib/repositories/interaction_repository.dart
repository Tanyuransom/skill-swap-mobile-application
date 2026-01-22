import 'package:skillswapp_shared/skillswapp_shared.dart';

class InteractionRepository {
  /// Like content
  Future<void> like(String userId, String targetType, String targetId) async {
    await PostgresClient.execute(
      '''
      INSERT INTO likes (user_id, target_type, target_id)
      VALUES (@userId, @targetType, @targetId)
      ON CONFLICT (user_id, target_type, target_id) DO NOTHING
      ''',
      parameters: {'userId': userId, 'targetType': targetType, 'targetId': targetId},
    );

    // Update like count on target
    await _updateLikeCount(targetType, targetId, 1);
  }

  /// Unlike content
  Future<void> unlike(String userId, String targetType, String targetId) async {
    await PostgresClient.execute(
      '''
      DELETE FROM likes
      WHERE user_id = @userId AND target_type = @targetType AND target_id = @targetId
      ''',
      parameters: {'userId': userId, 'targetType': targetType, 'targetId': targetId},
    );

    // Update like count on target
    await _updateLikeCount(targetType, targetId, -1);
  }

  /// Add comment
  Future<String> addComment({
    required String userId,
    required String targetType,
    required String targetId,
    required String content,
    String? parentCommentId,
  }) async {
    final result = await PostgresClient.execute(
      '''
      INSERT INTO comments (user_id, target_type, target_id, content, parent_comment_id)
      VALUES (@userId, @targetType, @targetId, @content, @parentCommentId)
      RETURNING id
      ''',
      parameters: {
        'userId': userId,
        'targetType': targetType,
        'targetId': targetId,
        'content': content,
        'parentCommentId': parentCommentId,
      },
    );

    // Update comment count
    await _updateCommentCount(targetType, targetId, 1);

    return result.first.toColumnMap()['id'].toString();
  }

  /// Get comments
  Future<List<Map<String, dynamic>>> getComments(String targetType, String targetId) async {
    final result = await PostgresClient.execute(
      '''
      SELECT c.*, u.full_name as user_name, u.profile_picture_url
      FROM comments c
      JOIN users u ON c.user_id = u.id
      WHERE c.target_type = @targetType AND c.target_id = @targetId AND c.parent_comment_id IS NULL
      ORDER BY c.created_at DESC
      ''',
      parameters: {'targetType': targetType, 'targetId': targetId},
    );

    return result.map((row) => row.toColumnMap()).toList();
  }

  /// Share content
  Future<void> share({
    required String userId,
    required String targetType,
    required String targetId,
    required String shareType,
    String? recipientId,
  }) async {
    await PostgresClient.execute(
      '''
      INSERT INTO shares (user_id, target_type, target_id, share_type, recipient_id)
      VALUES (@userId, @targetType, @targetId, @shareType, @recipientId)
      ''',
      parameters: {
        'userId': userId,
        'targetType': targetType,
        'targetId': targetId,
        'shareType': shareType,
        'recipientId': recipientId,
      },
    );

    // Update share count
    await _updateShareCount(targetType, targetId, 1);
  }

  /// Save content
  Future<void> save(String userId, String targetType, String targetId) async {
    await PostgresClient.execute(
      '''
      INSERT INTO saves (user_id, target_type, target_id)
      VALUES (@userId, @targetType, @targetId)
      ON CONFLICT (user_id, target_type, target_id) DO NOTHING
      ''',
      parameters: {'userId': userId, 'targetType': targetType, 'targetId': targetId},
    );

    await _updateSaveCount(targetType, targetId, 1);
  }

  /// Unsave content
  Future<void> unsave(String userId, String targetType, String targetId) async {
    await PostgresClient.execute(
      '''
      DELETE FROM saves
      WHERE user_id = @userId AND target_type = @targetType AND target_id = @targetId
      ''',
      parameters: {'userId': userId, 'targetType': targetType, 'targetId': targetId},
    );

    await _updateSaveCount(targetType, targetId, -1);
  }

  /// Helper: Update like count
  Future<void> _updateLikeCount(String targetType, String targetId, int delta) async {
    final table = targetType == 'post' ? 'posts' : targetType == 'reel' ? 'reels' : 'comments';
    await PostgresClient.execute(
      'UPDATE $table SET like_count = like_count + @delta WHERE id = @targetId',
      parameters: {'delta': delta, 'targetId': targetId},
    );
  }

  /// Helper: Update comment count
  Future<void> _updateCommentCount(String targetType, String targetId, int delta) async {
    final table = targetType == 'post' ? 'posts' : 'reels';
    await PostgresClient.execute(
      'UPDATE $table SET comment_count = comment_count + @delta WHERE id = @targetId',
      parameters: {'delta': delta, 'targetId': targetId},
    );
  }

  /// Helper: Update share count
  Future<void> _updateShareCount(String targetType, String targetId, int delta) async {
    final table = targetType == 'post' ? 'posts' : 'reels';
    await PostgresClient.execute(
      'UPDATE $table SET share_count = share_count + @delta WHERE id = @targetId',
      parameters: {'delta': delta, 'targetId': targetId},
    );
  }

  /// Helper: Update save count
  Future<void> _updateSaveCount(String targetType, String targetId, int delta) async {
    final table = targetType == 'post' ? 'posts' : 'reels';
    await PostgresClient.execute(
      'UPDATE $table SET save_count = save_count + @delta WHERE id = @targetId',
      parameters: {'delta': delta, 'targetId': targetId},
    );
  }
}
