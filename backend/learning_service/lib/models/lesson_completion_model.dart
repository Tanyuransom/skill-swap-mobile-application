class LessonCompletionModel {
  final String id;
  final String enrollmentId;
  final String lessonId;
  final DateTime completedAt;
  final int? watchDuration; // seconds

  LessonCompletionModel({
    required this.id,
    required this.enrollmentId,
    required this.lessonId,
    required this.completedAt,
    this.watchDuration,
  });

  factory LessonCompletionModel.fromMap(Map<String, dynamic> map) {
    return LessonCompletionModel(
      id: map['id'].toString(),
      enrollmentId: map['enrollment_id'].toString(),
      lessonId: map['lesson_id'].toString(),
      completedAt: DateTime.parse(map['completed_at'].toString()),
      watchDuration: map['watch_duration'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'lessonId': lessonId,
      'completedAt': completedAt.toIso8601String(),
      'watchDuration': watchDuration,
    };
  }
}
