import 'package:skillswapp_shared/skillswapp_shared.dart';

class ReelsRepository {
  /// Create reel
  Future<String> createReel({
    required String userId,
    required String videoUrl,
    String? thumbnailUrl,
    String? title,
    String? description,
    required int duration,
    String? category,
  }) async {
    final result = await PostgresClient.execute(
      '''
      INSERT INTO reels (
        user_id, video_url, thumbnail_url, title, description, duration, category
      )
      VALUES (@userId, @videoUrl, @thumbnailUrl, @title, @description, @duration, @category)
      RETURNING id
      ''',
      parameters: {
        'userId': userId,
        'videoUrl': videoUrl,
        'thumbnailUrl': thumbnailUrl,
        'title': title,
        'description': description,
        'duration': duration,
        'category': category,
      },
    );

    return result.first.toColumnMap()['id'].toString();
  }

  /// Get reel feed (infinite scroll)
  Future<List<Map<String, dynamic>>> getReelsFeed({int limit = 20, int offset = 0}) async {
    final result = await PostgresClient.execute(
      '''
      SELECT r.*, u.full_name as user_name, u.profile_picture_url
      FROM reels r
      JOIN users u ON r.user_id = u.id
      ORDER BY r.created_at DESC
      LIMIT @limit OFFSET @offset
      ''',
      parameters: {'limit': limit, 'offset': offset},
    );

    return result.map((row) => row.toColumnMap()).toList();
  }

  /// Get reel by ID
  Future<Map<String, dynamic>?> getReel(String reelId) async {
    final result = await PostgresClient.execute(
      '''
      SELECT r.*, u.full_name as user_name, u.profile_picture_url
      FROM reels r
      JOIN users u ON r.user_id = u.id
      WHERE r.id = @reelId
      ''',
      parameters: {'reelId': reelId},
    );

    if (result.isEmpty) return null;
    return result.first.toColumnMap();
  }

  /// Track view
  Future<void> trackView(String reelId, bool completed) async {
    await PostgresClient.execute(
      '''
      UPDATE reels
      SET view_count = view_count + 1,
          completion_rate = CASE
            WHEN @completed THEN (completion_rate * view_count + 100) / (view_count + 1)
            ELSE (completion_rate * view_count) / (view_count + 1)
          END
      WHERE id = @reelId
      ''',
      parameters: {
        'reelId': reelId,
        'completed': completed,
      },
    );
  }

  /// Delete reel
  Future<void> deleteReel(String reelId) async {
    await PostgresClient.execute(
      'DELETE FROM reels WHERE id = @reelId',
      parameters: {'reelId': reelId},
    );
  }

  /// Get user's reels
  Future<List<Map<String, dynamic>>> getUserReels(String userId, {int limit = 20}) async {
    final result = await PostgresClient.execute(
      '''
      SELECT r.*, u.full_name as user_name, u.profile_picture_url
      FROM reels r
      JOIN users u ON r.user_id = u.id
      WHERE r.user_id = @userId
      ORDER BY r.created_at DESC
      LIMIT @limit
      ''',
      parameters: {'userId': userId, 'limit': limit},
    );

    return result.map((row) => row.toColumnMap()).toList();
  }
}
