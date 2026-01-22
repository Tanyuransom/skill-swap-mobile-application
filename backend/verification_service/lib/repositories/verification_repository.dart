import 'package:skillswapp_shared/skillswapp_shared.dart';
import 'dart:convert';

class VerificationRepository {
  /// Create a new verification request
  Future<String> createRequest(String userId, String topic) async {
    final result = await PostgresClient.executeOne(
      '''
      INSERT INTO verification_requests (user_id, topic, status)
      VALUES (@userId, @topic, 'pending')
      RETURNING id
      ''',
      parameters: {'userId': userId, 'topic': topic},
    );
    
    if (result == null) throw DatabaseException('Failed to create request');
    final map = result.toColumnMap();
    return map['id'].toString();
  }

  /// Save generated exam
  Future<void> saveExam(String requestId, List<Map<String, dynamic>> questions) async {
    // PostgresClient handles List/Map to JSONB conversion automatically usually 
    // if not, we encode it. Assuming standard Postgres package behavior with JSONB.
    // Safest to encode to String if unsure about driver mapping.
    // The shared lib might expect parameters.
    
    // Actually, let's look at how we pass JSON. 
    // Usually standard postgres driver handles Map/List if column is JSONB.
    
    // Explicitly encode to JSON string for Postgres JSONB compatibility
    final questionsJson = jsonEncode(questions);
    
    await PostgresClient.execute(
      '''
      INSERT INTO verification_exams (request_id, questions)
      VALUES (@requestId, @questions)
      ''',
      parameters: {
        'requestId': requestId, 
        'questions': questionsJson 
      },
    );
    
    await PostgresClient.execute(
      "UPDATE verification_requests SET status = 'generated' WHERE id = @id",
      parameters: {'id': requestId},
    );
  }

  /// Get exam by request ID
  Future<Map<String, dynamic>?> getExam(String requestId) async {
    final result = await PostgresClient.executeOne(
      'SELECT * FROM verification_exams WHERE request_id = @requestId',
      parameters: {'requestId': requestId},
    );
    return result?.toColumnMap();
  }
  
  /// Get request details
  Future<Map<String, dynamic>?> getRequest(String requestId) async {
    final result = await PostgresClient.executeOne(
      'SELECT * FROM verification_requests WHERE id = @id',
      parameters: {'id': requestId},
    );
    return result?.toColumnMap();
  }

  /// Update request with results
  Future<void> updateResult(String requestId, int score, String feedback, bool passed) async {
    await PostgresClient.execute(
      '''
      UPDATE verification_requests 
      SET score = @score, feedback = @feedback, status = @status
      WHERE id = @id
      ''',
      parameters: {
        'id': requestId,
        'score': score,
        'feedback': feedback,
        'status': passed ? 'completed' : 'failed'
      },
    );
  }

  /// Issue badge
  Future<void> issueBadge(String userId, String topic) async {
    await PostgresClient.execute(
      '''
      INSERT INTO tutor_badges (user_id, title, topic)
      VALUES (@userId, @title, @topic)
      ''',
      parameters: {
        'userId': userId,
        'title': 'Verified $topic Tutor',
        'topic': topic
      },
    );
  }
  
  /// Get user badges
  Future<List<Map<String, dynamic>>> getUserBadges(String userId) async {
    final result = await PostgresClient.execute(
      'SELECT * FROM tutor_badges WHERE user_id = @userId ORDER BY issued_at DESC',
      parameters: {'userId': userId},
    );
    return result.map((row) => row.toColumnMap()).toList();
  }
}
