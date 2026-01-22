import 'package:skillswapp_shared/skillswapp_shared.dart';
import '../repositories/social_feed_repository.dart';

class SocialFeedService {
  final SocialFeedRepository _repository = SocialFeedRepository();

  /// Create post
  Future<Map<String, dynamic>> createPost({
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
    // Validate post type
    if (!['video', 'reel', 'text', 'image'].contains(postType)) {
      throw BadRequestException('Invalid post type');
    }

    // Validate required fields based on type
    if (postType == 'video' && mediaUrl == null) {
      throw BadRequestException('Video URL is required for video posts');
    }

    final postId = await _repository.createPost(
      userId: userId,
      postType: postType,
      title: title,
      description: description,
      mediaUrl: mediaUrl,
      thumbnailUrl: thumbnailUrl,
      duration: duration,
      category: category,
      isPremium: isPremium,
    );

    return {
      'id': postId,
      'message': 'Post created successfully',
    };
  }

  /// Get post
  Future<Map<String, dynamic>> getPost(String postId, String? viewerId) async {
    final post = await _repository.getPost(postId);
    
    if (post == null) {
      throw NotFoundException('Post not found');
    }

    // Increment view count
    if (viewerId != null) {
      await _repository.incrementViewCount(postId);
    }

    return post;
  }

  /// Get user posts
  Future<List<Map<String, dynamic>>> getUserPosts(String userId) async {
    return await _repository.getUserPosts(userId);
  }

  /// Get For You feed
  Future<Map<String, dynamic>> getForYouFeed(String userId, {int page = 1, int limit = 20}) async {
    final offset = (page - 1) * limit;
    final posts = await _repository.getForYouFeed(userId, limit: limit, offset: offset);

    return {
      'posts': posts,
      'page': page,
      'hasMore': posts.length == limit,
    };
  }

  /// Get Following feed
  Future<Map<String, dynamic>> getFollowingFeed(String userId, {int page = 1, int limit = 20}) async {
    final offset = (page - 1) * limit;
    final posts = await _repository.getFollowingFeed(userId, limit: limit, offset: offset);

    return {
      'posts': posts,
      'page': page,
      'hasMore': posts.length == limit,
    };
  }

  /// Delete post
  Future<void> deletePost(String postId, String userId) async {
    final post = await _repository.getPost(postId);
    
    if (post == null) {
      throw NotFoundException('Post not found');
    }

    if (post['user_id'].toString() != userId) {
      throw UnauthorizedException('You can only delete your own posts');
    }

    await _repository.deletePost(postId);
  }

  /// Follow user
  Future<void> followUser(String followerId, String followingId) async {
    if (followerId == followingId) {
      throw BadRequestException('Cannot follow yourself');
    }

    await _repository.followUser(followerId, followingId);
  }

  /// Unfollow user
  Future<void> unfollowUser(String followerId, String followingId) async {
    await _repository.unfollowUser(followerId, followingId);
  }

  /// Get user stats
  Future<Map<String, dynamic>> getUserStats(String userId, String? viewerId) async {
    final followerCount = await _repository.getFollowerCount(userId);
    final followingCount = await _repository.getFollowingCount(userId);
    final isFollowing = viewerId != null 
        ? await _repository.isFollowing(viewerId, userId)
        : false;

    return {
      'followerCount': followerCount,
      'followingCount': followingCount,
      'isFollowing': isFollowing,
    };
  }
}
