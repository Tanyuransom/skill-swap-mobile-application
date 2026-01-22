import 'package:skillswapp_shared/skillswapp_shared.dart';
import '../repositories/analytics_repository.dart';

class AnalyticsService {
  final AnalyticsRepository _repository = AnalyticsRepository();

  // Revenue distribution weights
  final double watchTimeWeight = 0.40; // 40%
  final double engagementWeight = 0.30; // 30%
  final double subscriberWeight = 0.30; // 30%
  final double platformCommission = 0.20; // 20%

  /// Track content view
  Future<void> trackView({
    required String lessonId,
    required String userId,
    required int watchDuration,
    bool completed = false,
    bool liked = false,
    bool shared = false,
  }) async {
    // Get tutor ID from lesson
    final tutorId = await _getTutorIdFromLesson(lessonId);

    await _repository.trackView(
      lessonId: lessonId,
      tutorId: tutorId,
      userId: userId,
      watchDuration: watchDuration,
      completed: completed,
      liked: liked,
      shared: shared,
    );
  }

  /// Get tutor dashboard analytics
  Future<Map<String, dynamic>> getTutorDashboard(String tutorId) async {
    final analytics = await _repository.getTutorAnalytics(tutorId);
    final subscriberCount = await _repository.getSubscriberCount(tutorId);

    final totalWatchSeconds = analytics['total_watch_seconds'] as int? ?? 0;
    final watchTimeHours = (totalWatchSeconds / 3600).toDouble();

    // Get current month earnings
    final now = DateTime.now();
    final currentMonth = DateTime(now.year, now.month, 1);
    final earnings = await _repository.getTutorEarnings(tutorId, currentMonth);

    return {
      'totalViews': analytics['total_views'],
      'totalWatchTimeHours': watchTimeHours.toStringAsFixed(2),
      'totalLikes': analytics['total_likes'],
      'totalShares': analytics['total_shares'],
      'totalCompletions': analytics['total_completions'],
      'subscriberCount': subscriberCount,
      'estimatedEarnings': earnings?['total_earnings'] ?? 0,
      'currentMonth': '${now.year}-${now.month.toString().padLeft(2, '0')}',
    };
  }

  /// Follow tutor
  Future<void> followTutor(String tutorId, String followerId) async {
    await _repository.followTutor(tutorId, followerId);
  }

  /// Unfollow tutor
  Future<void> unfollowTutor(String tutorId, String followerId) async {
    await _repository.unfollowTutor(tutorId, followerId);
  }

  /// Calculate monthly earnings for all tutors
  Future<void> calculateMonthlyEarnings(DateTime month) async {
    print('📊 Calculating earnings for ${month.year}-${month.month}...');

    // Get total subscription revenue
    final totalRevenue = await _getTotalSubscriptionRevenue(month);
    final tutorPool = totalRevenue * (1 - platformCommission);

    print('💰 Total revenue: $totalRevenue XAF');
    print('💰 Tutor pool (80%): $tutorPool XAF');

    // Get all tutor analytics for the month
    final tutorAnalytics = await _repository.getMonthlyAnalytics(month);

    if (tutorAnalytics.isEmpty) {
      print('⚠️ No analytics data for this month');
      return;
    }

    // Calculate totals for normalization
    double totalWatchTime = 0;
    int totalEngagement = 0;
    int totalSubscribers = 0;

    for (var tutor in tutorAnalytics) {
      final watchSeconds = tutor['total_watch_seconds'] as int? ?? 0;
      totalWatchTime += watchSeconds / 3600; // Convert to hours

      final likes = tutor['total_likes'] as int? ?? 0;
      final shares = tutor['total_shares'] as int? ?? 0;
      totalEngagement += likes + shares;
    }

    // Get total subscribers across all tutors
    for (var tutor in tutorAnalytics) {
      final tutorId = tutor['tutor_id'].toString();
      final count = await _repository.getSubscriberCount(tutorId);
      totalSubscribers += count;
    }

    print('📈 Total watch time: ${totalWatchTime.toStringAsFixed(2)} hours');
    print('📈 Total engagement: $totalEngagement actions');
    print('📈 Total subscribers: $totalSubscribers');

    // Calculate earnings for each tutor
    for (var tutor in tutorAnalytics) {
      final tutorId = tutor['tutor_id'].toString();
      final watchSeconds = tutor['total_watch_seconds'] as int? ?? 0;
      final watchHours = watchSeconds / 3600;
      final likes = tutor['total_likes'] as int? ?? 0;
      final shares = tutor['total_shares'] as int? ?? 0;
      final views = tutor['total_views'] as int? ?? 0;
      final engagement = likes + shares;
      final subscriberCount = await _repository.getSubscriberCount(tutorId);

      // Calculate scores (percentage of total)
      final watchTimeScore = totalWatchTime > 0 
          ? (watchHours / totalWatchTime) * tutorPool * watchTimeWeight
          : 0;

      final engagementScore = totalEngagement > 0
          ? (engagement / totalEngagement) * tutorPool * engagementWeight
          : 0;

      final subscriberScore = totalSubscribers > 0
          ? (subscriberCount / totalSubscribers) * tutorPool * subscriberWeight
          : 0;

      final totalEarnings = watchTimeScore + engagementScore + subscriberScore;

      // Save earnings
      await _repository.saveMonthlyEarnings(
        tutorId: tutorId,
        month: month,
        watchTimeHours: watchHours.toDouble(),
        totalViews: views,
        totalLikes: likes,
        totalShares: shares,
        subscriberCount: subscriberCount,
        watchTimeScore: watchTimeScore.toDouble(),
        engagementScore: engagementScore.toDouble(),
        subscriberScore: subscriberScore.toDouble(),
        totalEarnings: totalEarnings.toDouble(),
      );

      print('✅ Tutor $tutorId: ${totalEarnings.toStringAsFixed(2)} XAF');
    }

    print('✅ Monthly earnings calculated!');
  }

  /// Helper: Get tutor ID from lesson
  Future<String> _getTutorIdFromLesson(String lessonId) async {
    final result = await PostgresClient.execute(
      '''
      SELECT c.tutor_id FROM lessons l
      JOIN courses c ON l.course_id = c.id
      WHERE l.id = @lessonId
      ''',
      parameters: {'lessonId': lessonId},
    );

    if (result.isEmpty) {
      throw NotFoundException('Lesson not found');
    }

    return result.first.toColumnMap()['tutor_id'].toString();
  }

  /// Helper: Get total subscription revenue for month
  Future<double> _getTotalSubscriptionRevenue(DateTime month) async {
    final startOfMonth = DateTime(month.year, month.month, 1);
    final endOfMonth = DateTime(month.year, month.month + 1, 0, 23, 59, 59);

    final result = await PostgresClient.execute(
      '''
      SELECT COUNT(*) as count FROM subscriptions
      WHERE status = 'active'
      AND start_date <= @endDate
      AND (end_date IS NULL OR end_date >= @startDate)
      ''',
      parameters: {
        'startDate': startOfMonth.toIso8601String(),
        'endDate': endOfMonth.toIso8601String(),
      },
    );

    final activeSubscriptions = result.first.toColumnMap()['count'] as int;
    return activeSubscriptions * 2500.0; // 2,500 XAF per subscription
  }
}
