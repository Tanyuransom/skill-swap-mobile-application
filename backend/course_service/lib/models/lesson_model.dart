
class LessonModel {
  final String id;
  final String moduleId;
  final String title;
  final String? content;
  final String? videoUrl;
  final int? durationMinutes;
  final int orderIndex;
  final bool isFree;
  final DateTime createdAt;
  final DateTime updatedAt;

  LessonModel({
    required this.id,
    required this.moduleId,
    required this.title,
    this.content,
    this.videoUrl,
    this.durationMinutes,
    required this.orderIndex,
    required this.isFree,
    required this.createdAt,
    required this.updatedAt,
  });

  factory LessonModel.fromJson(Map<String, dynamic> json) {
    return LessonModel(
      id: json['id'] as String,
      moduleId: json['module_id'] as String,
      title: json['title'] as String,
      content: json['content'],
      videoUrl: json['video_url'] as String?,
      durationMinutes: json['duration_minutes'] as int?,
      orderIndex: json['order_index'] as int,
      isFree: json['is_free'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'].toString()),
      updatedAt: DateTime.parse(json['updated_at'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'module_id': moduleId,
      'title': title,
      'content': content,
      'video_url': videoUrl,
      'duration_minutes': durationMinutes,
      'order_index': orderIndex,
      'is_free': isFree,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class CreateLessonRequest {
  final String title;
  final String? content;
  final String? videoUrl;
  final int? durationMinutes;
  final bool isFree;
  final bool isPremium;

  CreateLessonRequest({
    required this.title,
    this.content,
    this.videoUrl,
    this.durationMinutes,
    this.isFree = true,
    this.isPremium = false,
  });

  factory CreateLessonRequest.fromJson(Map<String, dynamic> json) {
    return CreateLessonRequest(
      title: json['title'] as String,
      content: json['content'],
      // Accept either camelCase or snake_case for flexibility
      videoUrl: (json['videoUrl'] ?? json['video_url']) as String?,
      durationMinutes: (json['durationMinutes'] ?? json['duration_minutes']) as int?,
      isFree: json['isFree'] as bool? ?? true,
      isPremium: json['isPremium'] as bool? ?? false,
    );
  }

  List<String> validate() {
    final errors = <String>[];
    
    if (title.trim().isEmpty) {
      errors.add('Lesson title is required');
    }

    if (durationMinutes != null && durationMinutes! < 0) {
      errors.add('Duration cannot be negative');
    }
    
    return errors;
  }
}
