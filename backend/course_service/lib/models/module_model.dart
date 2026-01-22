
class ModuleModel {
  final String id;
  final String courseId;
  final String title;
  final String? description;
  final int orderIndex;
  final DateTime createdAt;

  ModuleModel({
    required this.id,
    required this.courseId,
    required this.title,
    this.description,
    required this.orderIndex,
    required this.createdAt,
  });

  factory ModuleModel.fromJson(Map<String, dynamic> json) {
    return ModuleModel(
      id: json['id'],
      courseId: json['course_id'],
      title: json['title'],
      description: json['description'],
      orderIndex: json['order_index'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'course_id': courseId,
      'title': title,
      'description': description,
      'order_index': orderIndex,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class CreateModuleRequest {
  final String title;
  final String? description;

  CreateModuleRequest({
    required this.title,
    this.description,
  });

  factory CreateModuleRequest.fromJson(Map<String, dynamic> json) {
    return CreateModuleRequest(
      title: json['title'],
      description: json['description'],
    );
  }

  List<String> validate() {
    final errors = <String>[];
    
    if (title.trim().isEmpty) {
      errors.add('Module title is required');
    }
    
    return errors;
  }
}
