class EnrollmentModel {
  final String id;
  final String userId;
  final String courseId;
  final String status; // 'active', 'completed', 'dropped'
  final DateTime enrolledAt;
  final DateTime? completedAt;
  final DateTime lastAccessed;

  EnrollmentModel({
    required this.id,
    required this.userId,
    required this.courseId,
    required this.status,
    required this.enrolledAt,
    this.completedAt,
    required this.lastAccessed,
  });

  factory EnrollmentModel.fromMap(Map<String, dynamic> map) {
    return EnrollmentModel(
      id: map['id'].toString(),
      userId: map['user_id'].toString(),
      courseId: map['course_id'].toString(),
      status: map['status'] as String,
      enrolledAt: DateTime.parse(map['enrolled_at'].toString()),
      completedAt: map['completed_at'] != null 
          ? DateTime.parse(map['completed_at'].toString()) 
          : null,
      lastAccessed: DateTime.parse(map['last_accessed'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'courseId': courseId,
      'status': status,
      'enrolledAt': enrolledAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'lastAccessed': lastAccessed.toIso8601String(),
    };
  }
}
