class ProgressModel {
  final String id;
  final String enrollmentId;
  final int totalLessons;
  final int completedLessons;
  final int percentage;
  final DateTime updatedAt;

  ProgressModel({
    required this.id,
    required this.enrollmentId,
    required this.totalLessons,
    required this.completedLessons,
    required this.percentage,
    required this.updatedAt,
  });

  factory ProgressModel.fromMap(Map<String, dynamic> map) {
    return ProgressModel(
      id: map['id'].toString(),
      enrollmentId: map['enrollment_id'].toString(),
      totalLessons: map['total_lessons'] as int,
      completedLessons: map['completed_lessons'] as int,
      percentage: map['percentage'] as int,
      updatedAt: DateTime.parse(map['updated_at'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalLessons': totalLessons,
      'completedLessons': completedLessons,
      'percentage': percentage,
    };
  }
}
