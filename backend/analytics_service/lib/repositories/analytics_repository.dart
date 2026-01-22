import 'package:skillswapp_shared/skillswapp_shared.dart';

class AnalyticsRepository {
  /// Track content view
  Future<void> trackView({
    required String lessonId,
    required String tutorId,
    required String userId,
    required int watchDuration,
    bool completed = false,
    bool liked = false,
    bool shared = false,
  }) async {
    await PostgresClient.execute(
      '''
      INSERT INTO content_analytics (
        lesson_id, tutor_id, user_id, watch_duration, 
        completed, liked, shared
      )
      VALUES (@lessonId, @tutorId, @userId, @watchDuration, @completed, @liked, @shared)
      ''',
      parameters: {
        'lessonId': lessonId,
        'tutorId': tutorId,
        'userId': userId,
        'watchDuration': watchDuration,
        'completed': completed,
        'liked': liked,
        'shared': shared,
      },
    );
  }

  /// Get tutor analytics summary
  Future<Map<String, dynamic>> getTutorAnalytics(String tutorId) async {
    final result = await PostgresClient.execute(
      '''
      SELECT 
        COUNT(*) as total_views,
        SUM(watch_duration) as total_watch_seconds,
        SUM(CASE WHEN liked THEN 1 ELSE 0 END) as total_likes,
        SUM(CASE WHEN shared THEN 1 ELSE 0 END) as total_shares,
        SUM(CASE WHEN completed THEN 1 ELSE 0 END) as total_completions
      FROM content_analytics
      WHERE tutor_id = @tutorId
      ''',
      parameters: {'tutorId': tutorId},
    );

    if (result.isEmpty) {
      return {
        'total_views': 0,
        'total_watch_seconds': 0,
        'total_likes': 0,
        'total_shares': 0,
        'total_completions': 0,
      };
    }

    return result.first.toColumnMap();
  }

  /// Get subscriber count
  Future<int> getSubscriberCount(String tutorId) async {
    final result = await PostgresClient.execute(
      'SELECT COUNT(*) as count FROM tutor_followers WHERE tutor_id = @tutorId',
      parameters: {'tutorId': tutorId},
    );

    return result.first.toColumnMap()['count'] as int;
  }

  /// Follow tutor
  Future<void> followTutor(String tutorId, String followerId) async {
    await PostgresClient.execute(
      '''
      INSERT INTO tutor_followers (tutor_id, follower_id)
      VALUES (@tutorId, @followerId)
      ON CONFLICT (tutor_id, follower_id) DO NOTHING
      ''',
      parameters: {
        'tutorId': tutorId,
        'followerId': followerId,
      },
    );
  }

  /// Unfollow tutor
  Future<void> unfollowTutor(String tutorId, String followerId) async {
    await PostgresClient.execute(
      '''
      DELETE FROM tutor_followers
      WHERE tutor_id = @tutorId AND follower_id = @followerId
      ''',
      parameters: {
        'tutorId': tutorId,
        'followerId': followerId,
      },
    );
  }

  /// Get monthly analytics for all tutors
  Future<List<Map<String, dynamic>>> getMonthlyAnalytics(DateTime month) async {
    final startOfMonth = DateTime(month.year, month.month, 1);
    final endOfMonth = DateTime(month.year, month.month + 1, 0, 23, 59, 59);

    final result = await PostgresClient.execute(
      '''
      SELECT 
        tutor_id,
        COUNT(*) as total_views,
        SUM(watch_duration) as total_watch_seconds,
        SUM(CASE WHEN liked THEN 1 ELSE 0 END) as total_likes,
        SUM(CASE WHEN shared THEN 1 ELSE 0 END) as total_shares
      FROM content_analytics
      WHERE watched_at >= @startDate AND watched_at <= @endDate
      GROUP BY tutor_id
      ''',
      parameters: {
        'startDate': startOfMonth.toIso8601String(),
        'endDate': endOfMonth.toIso8601String(),
      },
    );

    return result.map((row) => row.toColumnMap()).toList();
  }

  /// Save monthly earnings
  Future<void> saveMonthlyEarnings({
    required String tutorId,
    required DateTime month,
    required double watchTimeHours,
    required int totalViews,
    required int totalLikes,
    required int totalShares,
    required int subscriberCount,
    required double watchTimeScore,
    required double engagementScore,
    required double subscriberScore,
    required double totalEarnings,
  }) async {
    await PostgresClient.execute(
      '''
      INSERT INTO tutor_earnings (
        tutor_id, month, watch_time_hours, total_views, total_likes,
        total_shares, subscriber_count, watch_time_score, engagement_score,
        subscriber_score, total_earnings
      )
      VALUES (
        @tutorId, @month, @watchTimeHours, @totalViews, @totalLikes,
        @totalShares, @subscriberCount, @watchTimeScore, @engagementScore,
        @subscriberScore, @totalEarnings
      )
      ON CONFLICT (tutor_id, month)
      DO UPDATE SET
        watch_time_hours = @watchTimeHours,
        total_views = @totalViews,
        total_likes = @totalLikes,
        total_shares = @totalShares,
        subscriber_count = @subscriberCount,
        watch_time_score = @watchTimeScore,
        engagement_score = @engagementScore,
        subscriber_score = @subscriberScore,
        total_earnings = @totalEarnings,
        calculated_at = CURRENT_TIMESTAMP
      ''',
      parameters: {
        'tutorId': tutorId,
        'month': '${month.year}-${month.month.toString().padLeft(2, '0')}-01',
        'watchTimeHours': watchTimeHours,
        'totalViews': totalViews,
        'totalLikes': totalLikes,
        'totalShares': totalShares,
        'subscriberCount': subscriberCount,
        'watchTimeScore': watchTimeScore,
        'engagementScore': engagementScore,
        'subscriberScore': subscriberScore,
        'totalEarnings': totalEarnings,
      },
    );
  }

  /// Get tutor earnings for a month
  Future<Map<String, dynamic>?> getTutorEarnings(String tutorId, DateTime month) async {
    final result = await PostgresClient.execute(
      '''
      SELECT * FROM tutor_earnings
      WHERE tutor_id = @tutorId 
      AND month = @month
      ''',
      parameters: {
        'tutorId': tutorId,
        'month': '${month.year}-${month.month.toString().padLeft(2, '0')}-01',
      },
    );

    if (result.isEmpty) return null;
    return result.first.toColumnMap();
  }
}
