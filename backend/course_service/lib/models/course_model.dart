
class CourseModel {
  final String id;
  final String tutorId;
  final String? categoryId;
  final String title;
  final String description;
  final double price;
  final String currency;
  final String? thumbnailUrl;
  final String? difficultyLevel; // beginner, intermediate, advanced
  final int? durationHours;
  final bool isPublished;
  final DateTime createdAt;
  final DateTime updatedAt;

  CourseModel({
    required this.id,
    required this.tutorId,
    this.categoryId,
    required this.title,
    required this.description,
    required this.price,
    required this.currency,
    this.thumbnailUrl,
    this.difficultyLevel,
    this.durationHours,
    required this.isPublished,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['id'] as String,
      tutorId: json['tutor_id'] as String,
      categoryId: json['category_id'] as String?,
      title: json['title'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      currency: json['currency'] as String? ?? 'USD',
      thumbnailUrl: json['thumbnail_url'] as String?,
      difficultyLevel: json['difficulty_level'] as String?,
      durationHours: json['duration_hours'] as int?,
      isPublished: json['is_published'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'].toString()),
      updatedAt: DateTime.parse(json['updated_at'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tutor_id': tutorId,
      'category_id': categoryId,
      'title': title,
      'description': description,
      'price': price,
      'currency': currency,
      'thumbnail_url': thumbnailUrl,
      'difficulty_level': difficultyLevel,
      'duration_hours': durationHours,
      'is_published': isPublished,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class CreateCourseRequest {
  final String title;
  final String description;
  final String? categoryId;
  final double price;
  final String? difficultyLevel;
  final int? durationHours;

  CreateCourseRequest({
    required this.title,
    required this.description,
    this.categoryId,
    required this.price,
    this.difficultyLevel,
    this.durationHours,
  });

  factory CreateCourseRequest.fromJson(Map<String, dynamic> json) {
    return CreateCourseRequest(
      title: json['title'] as String,
      description: json['description'] as String,
      categoryId: json['categoryId'] as String?,
      price: (json['price'] as num).toDouble(),
      difficultyLevel: json['difficultyLevel'] as String?,
      durationHours: json['durationHours'] as int?,
    );
  }

  List<String> validate() {
    final errors = <String>[];
    
    if (title.trim().isEmpty) {
      errors.add('Title is required');
    } else if (title.length < 5) {
      errors.add('Title must be at least 5 characters');
    }
    
    if (description.trim().isEmpty) {
      errors.add('Description is required');
    } else if (description.length < 20) {
      errors.add('Description must be at least 20 characters');
    }

    if (price < 0) {
      errors.add('Price cannot be negative');
    }

    if (difficultyLevel != null &&
        !['beginner', 'intermediate', 'advanced'].contains(difficultyLevel)) {
      errors.add(
          'Invalid difficultyLevel. Must be: beginner, intermediate, or advanced');
    }

    if (durationHours != null && durationHours! < 0) {
      errors.add('durationHours cannot be negative');
    }

    return errors;
  }
}

class UpdateCourseRequest {
  final String? title;
  final String? description;
  final String? categoryId;
  final double? price;
  final String? difficultyLevel;
  final int? durationHours;
  final bool? isPublished;

  UpdateCourseRequest({
    this.title,
    this.description,
    this.categoryId,
    this.price,
    this.difficultyLevel,
    this.durationHours,
    this.isPublished,
  });

  factory UpdateCourseRequest.fromJson(Map<String, dynamic> json) {
    return UpdateCourseRequest(
      title: json['title'] as String?,
      description: json['description'] as String?,
      categoryId: json['categoryId'] as String?,
      price:
          json['price'] != null ? (json['price'] as num).toDouble() : null,
      difficultyLevel: json['difficultyLevel'] as String?,
      durationHours: json['durationHours'] as int?,
      isPublished: json['isPublished'] as bool?,
    );
  }
}
