import 'package:skillswapp_shared/skillswapp_shared.dart';
import '../repositories/learning_repository.dart';

class LearningService {
  final LearningRepository _repository = LearningRepository();

  /// Enroll a user in a course
  Future<Map<String, dynamic>> enrollInCourse(
    String userId,
    String courseId,
    int totalLessons,
  ) async {
    // Check if already enrolled
    final alreadyEnrolled = await _repository.isEnrolled(userId, courseId);
    if (alreadyEnrolled) {
      throw ConflictException('Already enrolled in this course');
    }

    // Create enrollment
    final enrollmentId = await _repository.createEnrollment(userId, courseId);

    // Initialize progress
    await _repository.initializeProgress(enrollmentId, totalLessons);

    return {
      'enrollmentId': enrollmentId,
      'courseId': courseId,
      'status': 'active',
      'enrolledAt': DateTime.now().toIso8601String(),
    };
  }

  /// Get all enrollments for a user
  Future<Map<String, dynamic>> getEnrollments(
    String userId, {
    String? status,
    String sort = 'enrolled_at',
  }) async {
    final enrollments = await _repository.getEnrollments(
      userId,
      status: status,
      sort: sort,
    );

    return {
      'enrollments': enrollments,
      'total': enrollments.length,
    };
  }

  /// Get progress for a specific course
  Future<Map<String, dynamic>> getCourseProgress(
    String userId,
    String courseId,
  ) async {
    // Get enrollment
    final enrollment = await _repository.getEnrollmentByUserAndCourse(
      userId,
      courseId,
    );

    if (enrollment == null) {
      throw NotFoundException('Not enrolled in this course');
    }

    final enrollmentId = enrollment['id'].toString();

    // Get progress
    final progress = await _repository.getProgress(enrollmentId);
    if (progress == null) {
      throw NotFoundException('Progress not found');
    }

    // Get completed lesson IDs
    final completedLessonIds = await _repository.getCompletedLessonIds(enrollmentId);

    return {
      'courseId': courseId,
      'enrollmentId': enrollmentId,
      'progress': {
        'percentage': progress['percentage'],
        'completedLessons': progress['completed_lessons'],
        'totalLessons': progress['total_lessons'],
      },
      'completedLessonIds': completedLessonIds,
      'lastAccessed': enrollment['last_accessed'].toString(),
      'enrolledAt': enrollment['enrolled_at'].toString(),
    };
  }

  /// Update last accessed time
  Future<void> updateProgress(
    String userId,
    String enrollmentId,
    String lessonId, {
    int? watchDuration,
  }) async {
    // Verify ownership
    final enrollment = await _repository.getEnrollment(enrollmentId);
    if (enrollment == null) {
      throw NotFoundException('Enrollment not found');
    }

    if (enrollment['user_id'].toString() != userId) {
      throw UnauthorizedException('Not your enrollment');
    }

    // Update last accessed
    await _repository.updateLastAccessed(enrollmentId);
  }

  /// Mark a lesson as complete
  Future<Map<String, dynamic>> markLessonComplete(
    String userId,
    String lessonId,
    String courseId,
  ) async {
    // Get enrollment
    final enrollment = await _repository.getEnrollmentByUserAndCourse(
      userId,
      courseId,
    );

    if (enrollment == null) {
      throw NotFoundException('Not enrolled in this course');
    }

    final enrollmentId = enrollment['id'].toString();

    // Check if already completed (idempotent)
    final alreadyCompleted = await _repository.isLessonCompleted(
      enrollmentId,
      lessonId,
    );

    if (!alreadyCompleted) {
      // Mark as complete
      await _repository.markLessonComplete(enrollmentId, lessonId);

      // Update progress
      await _repository.updateProgress(enrollmentId);
    }

    // Get updated progress
    final progress = await _repository.getProgress(enrollmentId);
    if (progress == null) {
      throw NotFoundException('Progress not found');
    }

    final percentage = progress['percentage'] as int;
    final courseCompleted = percentage >= 100;

    // If course completed, update enrollment status
    if (courseCompleted && enrollment['status'] != 'completed') {
      await _repository.markEnrollmentCompleted(enrollmentId);
    }

    return {
      'lessonId': lessonId,
      'completedAt': DateTime.now().toIso8601String(),
      'progress': {
        'percentage': percentage,
        'completedLessons': progress['completed_lessons'],
        'totalLessons': progress['total_lessons'],
      },
      'courseCompleted': courseCompleted,
    };
  }

  /// Drop enrollment
  Future<void> dropEnrollment(String userId, String enrollmentId) async {
    // Verify ownership
    final enrollment = await _repository.getEnrollment(enrollmentId);
    if (enrollment == null) {
      throw NotFoundException('Enrollment not found');
    }

    if (enrollment['user_id'].toString() != userId) {
      throw UnauthorizedException('Not your enrollment');
    }

    await _repository.dropEnrollment(enrollmentId);
  }
}
