import 'package:skillswapp_shared/skillswapp_shared.dart';
import '../models/enrollment_model.dart';
import '../models/progress_model.dart';
import '../models/lesson_completion_model.dart';

class LearningRepository {
  /// Create a new enrollment
  Future<String> createEnrollment(String userId, String courseId) async {
    final result = await PostgresClient.execute(
      '''
      INSERT INTO enrollments (user_id, course_id, status, enrolled_at, last_accessed)
      VALUES (@userId, @courseId, 'active', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
      RETURNING id
      ''',
      parameters: {
        'userId': userId,
        'courseId': courseId,
      },
    );
    
    return result.first.toColumnMap()['id'].toString();
  }

  /// Initialize progress for an enrollment
  Future<void> initializeProgress(String enrollmentId, int totalLessons) async {
    await PostgresClient.execute(
      '''
      INSERT INTO course_progress (enrollment_id, total_lessons, completed_lessons, percentage)
      VALUES (@enrollmentId, @totalLessons, 0, 0)
      ''',
      parameters: {
        'enrollmentId': enrollmentId,
        'totalLessons': totalLessons,
      },
    );
  }

  /// Check if user is already enrolled in a course
  Future<bool> isEnrolled(String userId, String courseId) async {
    final result = await PostgresClient.execute(
      '''
      SELECT COUNT(*) as count FROM enrollments
      WHERE user_id = @userId AND course_id = @courseId
      ''',
      parameters: {
        'userId': userId,
        'courseId': courseId,
      },
    );
    
    final count = result.first.toColumnMap()['count'] as int;
    return count > 0;
  }

  /// Get all enrollments for a user
  Future<List<Map<String, dynamic>>> getEnrollments(
    String userId, {
    String? status,
    String sort = 'enrolled_at',
  }) async {
    String query = '''
      SELECT 
        e.id as enrollment_id,
        e.course_id,
        e.status,
        e.enrolled_at,
        e.last_accessed,
        e.completed_at,
        p.total_lessons,
        p.completed_lessons,
        p.percentage
      FROM enrollments e
      LEFT JOIN course_progress p ON e.id = p.enrollment_id
      WHERE e.user_id = @userId
    ''';
    
    if (status != null) {
      query += ' AND e.status = @status';
    }
    
    query += ' ORDER BY e.$sort DESC';
    
    final result = await PostgresClient.execute(
      query,
      parameters: {
        'userId': userId,
        if (status != null) 'status': status,
      },
    );
    
    return result.map((row) => row.toColumnMap()).toList();
  }

  /// Get enrollment by ID
  Future<Map<String, dynamic>?> getEnrollment(String enrollmentId) async {
    final result = await PostgresClient.execute(
      '''
      SELECT * FROM enrollments WHERE id = @enrollmentId
      ''',
      parameters: {'enrollmentId': enrollmentId},
    );
    
    if (result.isEmpty) return null;
    return result.first.toColumnMap();
  }

  /// Get enrollment by user and course
  Future<Map<String, dynamic>?> getEnrollmentByUserAndCourse(
    String userId,
    String courseId,
  ) async {
    final result = await PostgresClient.execute(
      '''
      SELECT * FROM enrollments 
      WHERE user_id = @userId AND course_id = @courseId
      ''',
      parameters: {
        'userId': userId,
        'courseId': courseId,
      },
    );
    
    if (result.isEmpty) return null;
    return result.first.toColumnMap();
  }

  /// Get progress for an enrollment
  Future<Map<String, dynamic>?> getProgress(String enrollmentId) async {
    final result = await PostgresClient.execute(
      '''
      SELECT * FROM course_progress WHERE enrollment_id = @enrollmentId
      ''',
      parameters: {'enrollmentId': enrollmentId},
    );
    
    if (result.isEmpty) return null;
    return result.first.toColumnMap();
  }

  /// Update last accessed time
  Future<void> updateLastAccessed(String enrollmentId) async {
    await PostgresClient.execute(
      '''
      UPDATE enrollments 
      SET last_accessed = CURRENT_TIMESTAMP
      WHERE id = @enrollmentId
      ''',
      parameters: {'enrollmentId': enrollmentId},
    );
  }

  /// Check if lesson is already completed
  Future<bool> isLessonCompleted(String enrollmentId, String lessonId) async {
    final result = await PostgresClient.execute(
      '''
      SELECT COUNT(*) as count FROM completed_lessons
      WHERE enrollment_id = @enrollmentId AND lesson_id = @lessonId
      ''',
      parameters: {
        'enrollmentId': enrollmentId,
        'lessonId': lessonId,
      },
    );
    
    final count = result.first.toColumnMap()['count'] as int;
    return count > 0;
  }

  /// Mark lesson as complete
  Future<void> markLessonComplete(
    String enrollmentId,
    String lessonId, {
    int? watchDuration,
  }) async {
    await PostgresClient.execute(
      '''
      INSERT INTO completed_lessons (enrollment_id, lesson_id, watch_duration)
      VALUES (@enrollmentId, @lessonId, @watchDuration)
      ''',
      parameters: {
        'enrollmentId': enrollmentId,
        'lessonId': lessonId,
        'watchDuration': watchDuration,
      },
    );
  }

  /// Get completed lesson IDs for an enrollment
  Future<List<String>> getCompletedLessonIds(String enrollmentId) async {
    final result = await PostgresClient.execute(
      '''
      SELECT lesson_id FROM completed_lessons
      WHERE enrollment_id = @enrollmentId
      ''',
      parameters: {'enrollmentId': enrollmentId},
    );
    
    return result.map((row) => row.toColumnMap()['lesson_id'].toString()).toList();
  }

  /// Update progress (increment completed lessons and recalculate percentage)
  Future<void> updateProgress(String enrollmentId) async {
    await PostgresClient.execute(
      '''
      UPDATE course_progress
      SET 
        completed_lessons = (
          SELECT COUNT(*) FROM completed_lessons 
          WHERE enrollment_id = @enrollmentId
        ),
        percentage = (
          SELECT CASE 
            WHEN total_lessons = 0 THEN 0
            ELSE (COUNT(*) * 100 / total_lessons)
          END
          FROM completed_lessons 
          WHERE enrollment_id = @enrollmentId
        ),
        updated_at = CURRENT_TIMESTAMP
      WHERE enrollment_id = @enrollmentId
      ''',
      parameters: {'enrollmentId': enrollmentId},
    );
  }

  /// Mark enrollment as completed
  Future<void> markEnrollmentCompleted(String enrollmentId) async {
    await PostgresClient.execute(
      '''
      UPDATE enrollments
      SET status = 'completed', completed_at = CURRENT_TIMESTAMP
      WHERE id = @enrollmentId
      ''',
      parameters: {'enrollmentId': enrollmentId},
    );
  }

  /// Drop enrollment (soft delete)
  Future<void> dropEnrollment(String enrollmentId) async {
    await PostgresClient.execute(
      '''
      UPDATE enrollments
      SET status = 'dropped'
      WHERE id = @enrollmentId
      ''',
      parameters: {'enrollmentId': enrollmentId},
    );
  }
}
