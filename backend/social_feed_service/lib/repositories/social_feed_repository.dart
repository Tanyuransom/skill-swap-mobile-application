import 'package:skillswapp_shared/skillswapp_shared.dart';

class SocialFeedRepository {
  /// Create post
  Future<String> createPost({
    required String userId,
    required String postType,
    String? title,
    String? description,
    String? mediaUrl,
    String? thumbnailUrl,
    int? duration,
    String? category,
    bool isPremium = false,
  }) async {
    final result = await PostgresClient.execute(
      '''
      INSERT INTO posts (
        user_id, post_type, title, description, media_url, 
        thumbnail_url, duration, category, is_premium
      )
      VALUES (@userId, @postType, @title, @description, @mediaUrl, 
              @thumbnailUrl, @duration, @category, @isPremium)
      RETURNING id
      ''',
      parameters: {
        'userId': userId,
        'postType': postType,
        'title': title,
        'description': description,
        'mediaUrl': mediaUrl,
        'thumbnailUrl': thumbnailUrl,
        'duration': duration,
        'category': category,
        'isPremium': isPremium,
      },
    );

    return result.first.toColumnMap()['id'].toString();
  }

  /// Get post by ID
  Future<Map<String, dynamic>?> getPost(String postId) async {
    final result = await PostgresClient.execute(
      '''
      SELECT p.*, u.full_name as user_name, u.profile_picture_url
      FROM posts p
      JOIN users u ON p.user_id = u.id
      WHERE p.id = @postId
      ''',
      parameters: {'postId': postId},
    );

    if (result.isEmpty) return null;
    return result.first.toColumnMap();
  }

  /// Get user's posts
  Future<List<Map<String, dynamic>>> getUserPosts(String userId, {int limit = 20}) async {
    final result = await PostgresClient.execute(
      '''
      SELECT p.*, u.full_name as user_name, u.profile_picture_url
      FROM posts p
      JOIN users u ON p.user_id = u.id
      WHERE p.user_id = @userId
      ORDER BY p.created_at DESC
      LIMIT @limit
      ''',
      parameters: {'userId': userId, 'limit': limit},
    );

    return result.map((row) => row.toColumnMap()).toList();
  }

  /// Get "For You" feed (simple chronological for now)
  Future<List<Map<String, dynamic>>> getForYouFeed(String userId, {int limit = 20, int offset = 0}) async {
    final result = await PostgresClient.execute(
      '''
      SELECT p.*, u.full_name as user_name, u.profile_picture_url
      FROM posts p
      JOIN users u ON p.user_id = u.id
      ORDER BY p.created_at DESC
      LIMIT @limit OFFSET @offset
      ''',
      parameters: {'limit': limit, 'offset': offset},
    );

    return result.map((row) => row.toColumnMap()).toList();
  }

  /// Get "Following" feed
  Future<List<Map<String, dynamic>>> getFollowingFeed(String userId, {int limit = 20, int offset = 0}) async {
    final result = await PostgresClient.execute(
      '''
      SELECT p.*, u.full_name as user_name, u.profile_picture_url
      FROM posts p
      JOIN users u ON p.user_id = u.id
      JOIN follows f ON p.user_id = f.following_id
      WHERE f.follower_id = @userId
      ORDER BY p.created_at DESC
      LIMIT @limit OFFSET @offset
      ''',
      parameters: {'userId': userId, 'limit': limit, 'offset': offset},
    );

    return result.map((row) => row.toColumnMap()).toList();
  }

  /// Delete post
  Future<void> deletePost(String postId) async {
    await PostgresClient.execute(
      'DELETE FROM posts WHERE id = @postId',
      parameters: {'postId': postId},
    );
  }

  /// Increment view count
  Future<void> incrementViewCount(String postId) async {
    await PostgresClient.execute(
      'UPDATE posts SET view_count = view_count + 1 WHERE id = @postId',
      parameters: {'postId': postId},
    );
  }

  /// Follow user
  Future<void> followUser(String followerId, String followingId) async {
    await PostgresClient.execute(
      '''
      INSERT INTO follows (follower_id, following_id)
      VALUES (@followerId, @followingId)
      ON CONFLICT (follower_id, following_id) DO NOTHING
      ''',
      parameters: {
        'followerId': followerId,
        'followingId': followingId,
      },
    );
  }

  /// Unfollow user
  Future<void> unfollowUser(String followerId, String followingId) async {
    await PostgresClient.execute(
      '''
      DELETE FROM follows
      WHERE follower_id = @followerId AND following_id = @followingId
      ''',
      parameters: {
        'followerId': followerId,
        'followingId': followingId,
      },
    );
  }

  /// Get follower count
  Future<int> getFollowerCount(String userId) async {
    final result = await PostgresClient.execute(
      'SELECT COUNT(*) as count FROM follows WHERE following_id = @userId',
      parameters: {'userId': userId},
    );

    return result.first.toColumnMap()['count'] as int;
  }

  /// Get following count
  Future<int> getFollowingCount(String userId) async {
    final result = await PostgresClient.execute(
      'SELECT COUNT(*) as count FROM follows WHERE follower_id = @userId',
      parameters: {'userId': userId},
    );

    return result.first.toColumnMap()['count'] as int;
  }

  /// Check if following
  Future<bool> isFollowing(String followerId, String followingId) async {
    final result = await PostgresClient.execute(
      '''
      SELECT COUNT(*) as count FROM follows
      WHERE follower_id = @followerId AND following_id = @followingId
      ''',
      parameters: {
        'followerId': followerId,
        'followingId': followingId,
      },
    );

    return (result.first.toColumnMap()['count'] as int) > 0;
  }
}
