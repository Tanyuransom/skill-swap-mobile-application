class PostModel {
  final String id;
  final String userId;
  final String postType; // 'video', 'reel', 'text', 'image'
  final String? title;
  final String? description;
  final String? mediaUrl;
  final String? thumbnailUrl;
  final int? duration;
  final String? category;
  final bool isPremium;
  final int viewCount;
  final int likeCount;
  final int commentCount;
  final int shareCount;
  final int saveCount;
  final DateTime createdAt;

  PostModel({
    required this.id,
    required this.userId,
    required this.postType,
    this.title,
    this.description,
    this.mediaUrl,
    this.thumbnailUrl,
    this.duration,
    this.category,
    required this.isPremium,
    required this.viewCount,
    required this.likeCount,
    required this.commentCount,
    required this.shareCount,
    required this.saveCount,
    required this.createdAt,
  });

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      id: map['id'].toString(),
      userId: map['user_id'].toString(),
      postType: map['post_type'] as String,
      title: map['title']?.toString(),
      description: map['description']?.toString(),
      mediaUrl: map['media_url']?.toString(),
      thumbnailUrl: map['thumbnail_url']?.toString(),
      duration: map['duration'] as int?,
      category: map['category']?.toString(),
      isPremium: map['is_premium'] as bool,
      viewCount: map['view_count'] as int,
      likeCount: map['like_count'] as int,
      commentCount: map['comment_count'] as int,
      shareCount: map['share_count'] as int,
      saveCount: map['save_count'] as int,
      createdAt: DateTime.parse(map['created_at'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'postType': postType,
      'title': title,
      'description': description,
      'mediaUrl': mediaUrl,
      'thumbnailUrl': thumbnailUrl,
      'duration': duration,
      'category': category,
      'isPremium': isPremium,
      'viewCount': viewCount,
      'likeCount': likeCount,
      'commentCount': commentCount,
      'shareCount': shareCount,
      'saveCount': saveCount,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
