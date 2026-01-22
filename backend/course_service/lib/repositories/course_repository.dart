import 'package:skillswapp_shared/skillswapp_shared.dart';
import '../models/course_model.dart';
import '../models/module_model.dart';
import '../models/lesson_model.dart';

class CourseRepository {
  // Course operations
  Future<String> createCourse(String tutorId, CreateCourseRequest request) async {
    final id = generateUUID();
    
    await PostgresClient.execute(
      '''
      INSERT INTO courses (
        id, tutor_id, category_id, title, description, price, currency,
        thumbnail_url, difficulty_level, duration_hours, is_published,
        created_at, updated_at
      )
      VALUES (
        @id, @tutorId, @categoryId, @title, @description, @price, @currency,
        @thumbnailUrl, @difficultyLevel, @durationHours, FALSE,
        NOW(), NOW()
      )
      ''',
      parameters: {
        'id': id,
        'tutorId': tutorId,
        'title': request.title,
        'description': request.description,
        'price': request.price,
        'currency': 'USD',
        'categoryId': request.categoryId,
        'thumbnailUrl': null,
        'difficultyLevel': request.difficultyLevel,
        'durationHours': request.durationHours,
      },
    );
    
    return id;
  }

  Future<CourseModel?> getCourseById(String courseId) async {
    final result = await PostgresClient.executeOne(
      'SELECT * FROM courses WHERE id = @id',
      parameters: {'id': courseId},
    );
    
    return result != null ? CourseModel.fromJson(result.toColumnMap()) : null;
  }

  Future<List<CourseModel>> getAllCourses({String? category, String? level, String? status}) async {
    var query = 'SELECT * FROM courses WHERE 1=1';
    final params = <String, dynamic>{};
    
    if (category != null) {
      query += ' AND category_id = @categoryId';
      params['categoryId'] = category;
    }
    
    if (level != null) {
      query += ' AND difficulty_level = @difficultyLevel';
      params['difficultyLevel'] = level;
    }
    
    // status flag is mapped to is_published boolean
    if (status != null) {
      if (status == 'published') {
        query += ' AND is_published = TRUE';
      } else if (status == 'draft') {
        query += ' AND is_published = FALSE';
      }
    } else {
      query += ' AND is_published = TRUE';
    }
    
    query += ' ORDER BY created_at DESC';
    
    final result = await PostgresClient.execute(query, parameters: params);
    return result.map((row) => CourseModel.fromJson(row.toColumnMap())).toList();
  }

  Future<List<CourseModel>> getCoursesByTutor(String tutorId) async {
    final result = await PostgresClient.execute(
      'SELECT * FROM courses WHERE tutor_id = @tutorId ORDER BY created_at DESC',
      parameters: {'tutorId': tutorId},
    );
    
    return result.map((row) => CourseModel.fromJson(row.toColumnMap())).toList();
  }

  Future<void> updateCourse(String courseId, UpdateCourseRequest request) async {
    final updates = <String>[];
    final params = <String, dynamic>{'id': courseId};
    
    if (request.title != null) {
      updates.add('title = @title');
      params['title'] = request.title;
    }
    if (request.description != null) {
      updates.add('description = @description');
      params['description'] = request.description;
    }
    if (request.categoryId != null) {
      updates.add('category_id = @categoryId');
      params['categoryId'] = request.categoryId;
    }
    if (request.price != null) {
      updates.add('price = @price');
      params['price'] = request.price;
    }
    if (request.difficultyLevel != null) {
      updates.add('difficulty_level = @difficultyLevel');
      params['difficultyLevel'] = request.difficultyLevel;
    }
    if (request.durationHours != null) {
      updates.add('duration_hours = @durationHours');
      params['durationHours'] = request.durationHours;
    }
    if (request.isPublished != null) {
      updates.add('is_published = @isPublished');
      params['isPublished'] = request.isPublished;
    }
    
    if (updates.isEmpty) return;
    
    updates.add('updated_at = NOW()');
    
    await PostgresClient.execute(
      'UPDATE courses SET ${updates.join(', ')} WHERE id = @id',
      parameters: params,
    );
  }

  Future<void> deleteCourse(String courseId) async {
    await PostgresClient.execute(
      'DELETE FROM courses WHERE id = @id',
      parameters: {'id': courseId},
    );
  }

  // Module operations
  Future<String> createModule(String courseId, CreateModuleRequest request) async {
    final id = generateUUID();
    
    // Get next order index
    final countResult = await PostgresClient.executeOne(
      'SELECT COUNT(*) as count FROM modules WHERE course_id = @courseId',
      parameters: {'courseId': courseId},
    );
    final orderIndex = (countResult?.toColumnMap()['count'] as int?) ?? 0;
    
    await PostgresClient.execute(
      '''
      INSERT INTO modules (id, course_id, title, description, order_index, created_at)
      VALUES (@id, @courseId, @title, @description, @orderIndex, NOW())
      ''',
      parameters: {
        'id': id,
        'courseId': courseId,
        'title': request.title,
        'description': request.description,
        'orderIndex': orderIndex,
      },
    );
    
    return id;
  }

  Future<List<ModuleModel>> getModulesByCourse(String courseId) async {
    final result = await PostgresClient.execute(
      'SELECT * FROM modules WHERE course_id = @courseId ORDER BY order_index',
      parameters: {'courseId': courseId},
    );
    
    return result.map((row) => ModuleModel.fromJson(row.toColumnMap())).toList();
  }

  Future<ModuleModel?> getModuleById(String moduleId) async {
    final result = await PostgresClient.executeOne(
      'SELECT * FROM modules WHERE id = @id',
      parameters: {'id': moduleId},
    );

    return result != null ? ModuleModel.fromJson(result.toColumnMap()) : null;
  }

  Future<void> deleteModule(String moduleId) async {
    await PostgresClient.execute(
      'DELETE FROM modules WHERE id = @id',
      parameters: {'id': moduleId},
    );
  }

  // Lesson operations
  Future<String> createLesson(String moduleId, CreateLessonRequest request) async {
    final id = generateUUID();
    
    // Get next order index
    final countResult = await PostgresClient.executeOne(
      'SELECT COUNT(*) as count FROM lessons WHERE module_id = @moduleId',
      parameters: {'moduleId': moduleId},
    );
    final orderIndex = (countResult?.toColumnMap()['count'] as int?) ?? 0;
    
    await PostgresClient.execute(
      '''
      INSERT INTO lessons (
        id, module_id, title, content, video_url, duration_minutes, order_index, is_free, is_premium, created_at, updated_at
      )
      VALUES (
        @id, @moduleId, @title, @content, @videoUrl, @durationMinutes, @orderIndex, @isFree, @isPremium, NOW(), NOW()
      )
      ''',
      parameters: {
        'id': id,
        'moduleId': moduleId,
        'title': request.title,
        'content': request.content,
        'videoUrl': request.videoUrl,
        'durationMinutes': request.durationMinutes,
        'orderIndex': orderIndex,
        'isFree': request.isFree,
        'isPremium': request.isPremium,
      },
    );
    
    return id;
  }

  Future<List<LessonModel>> getLessonsByModule(String moduleId) async {
    final result = await PostgresClient.execute(
      'SELECT * FROM lessons WHERE module_id = @moduleId ORDER BY order_index',
      parameters: {'moduleId': moduleId},
    );
    
    return result.map((row) => LessonModel.fromJson(row.toColumnMap())).toList();
  }

  Future<LessonModel?> getLessonById(String lessonId) async {
    final result = await PostgresClient.executeOne(
      'SELECT * FROM lessons WHERE id = @id',
      parameters: {'id': lessonId},
    );

    return result != null ? LessonModel.fromJson(result.toColumnMap()) : null;
  }

  Future<void> deleteLesson(String lessonId) async {
    await PostgresClient.execute(
      'DELETE FROM lessons WHERE id = @id',
      parameters: {'id': lessonId},
    );
  }

  Future<List<CourseModel>> searchCourses(String query) async {
    final result = await PostgresClient.execute(
      '''
      SELECT * FROM courses 
      WHERE is_published = TRUE 
      AND (title ILIKE @query OR description ILIKE @query)
      ORDER BY created_at DESC
      ''',
      parameters: {'query': '%$query%'},
    );
    
    return result.map((row) => CourseModel.fromJson(row.toColumnMap())).toList();
  }
}
