import 'package:skillswapp_shared/skillswapp_shared.dart';

class SocialGraphRepository {
  /// Send friend request
  Future<String> sendFriendRequest(String userId, String friendId) async {
    final result = await PostgresClient.execute(
      '''
      INSERT INTO friendships (user_id, friend_id, status)
      VALUES (@userId, @friendId, 'pending')
      ON CONFLICT (user_id, friend_id) DO NOTHING
      RETURNING id
      ''',
      parameters: {'userId': userId, 'friendId': friendId},
    );

    if (result.isEmpty) {
      throw ConflictException('Friend request already exists');
    }

    return result.first.toColumnMap()['id'].toString();
  }

  /// Accept friend request
  Future<void> acceptFriendRequest(String requestId) async {
    await PostgresClient.execute(
      '''
      UPDATE friendships
      SET status = 'accepted', accepted_at = CURRENT_TIMESTAMP
      WHERE id = @requestId
      ''',
      parameters: {'requestId': requestId},
    );

    // Create reverse friendship
    final request = await PostgresClient.execute(
      'SELECT user_id, friend_id FROM friendships WHERE id = @requestId',
      parameters: {'requestId': requestId},
    );

    if (request.isNotEmpty) {
      final row = request.first.toColumnMap();
      await PostgresClient.execute(
        '''
        INSERT INTO friendships (user_id, friend_id, status, accepted_at)
        VALUES (@friendId, @userId, 'accepted', CURRENT_TIMESTAMP)
        ON CONFLICT (user_id, friend_id) DO NOTHING
        ''',
        parameters: {
          'userId': row['user_id'].toString(),
          'friendId': row['friend_id'].toString(),
        },
      );
    }
  }

  /// Reject friend request
  Future<void> rejectFriendRequest(String requestId) async {
    await PostgresClient.execute(
      'UPDATE friendships SET status = \'rejected\' WHERE id = @requestId',
      parameters: {'requestId': requestId},
    );
  }

  /// Get friend requests
  Future<List<Map<String, dynamic>>> getFriendRequests(String userId) async {
    final result = await PostgresClient.execute(
      '''
      SELECT f.*, u.full_name, u.profile_picture_url
      FROM friendships f
      JOIN users u ON f.user_id = u.id
      WHERE f.friend_id = @userId AND f.status = 'pending'
      ORDER BY f.requested_at DESC
      ''',
      parameters: {'userId': userId},
    );

    return result.map((row) => row.toColumnMap()).toList();
  }

  /// Get friends
  Future<List<Map<String, dynamic>>> getFriends(String userId) async {
    final result = await PostgresClient.execute(
      '''
      SELECT f.*, u.full_name, u.profile_picture_url
      FROM friendships f
      JOIN users u ON f.friend_id = u.id
      WHERE f.user_id = @userId AND f.status = 'accepted'
      ORDER BY f.accepted_at DESC
      ''',
      parameters: {'userId': userId},
    );

    return result.map((row) => row.toColumnMap()).toList();
  }

  /// Unfriend
  Future<void> unfriend(String userId, String friendId) async {
    await PostgresClient.execute(
      '''
      DELETE FROM friendships
      WHERE (user_id = @userId AND friend_id = @friendId)
      OR (user_id = @friendId AND friend_id = @userId)
      ''',
      parameters: {'userId': userId, 'friendId': friendId},
    );
  }
}
