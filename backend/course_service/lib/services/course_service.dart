import 'package:skillswapp_shared/skillswapp_shared.dart';
import '../models/course_model.dart';
import '../models/module_model.dart';
import '../models/lesson_model.dart';
import '../repositories/course_repository.dart';

class CourseService {
  final CourseRepository _repository = CourseRepository();

  // Course operations
  Future<Map<String, dynamic>> createCourse(String tutorId, CreateCourseRequest request) async {
    final errors = request.validate();
    if (errors.isNotEmpty) {
      throw ValidationException(errors.join(', '));
    }

    final courseId = await _repository.createCourse(tutorId, request);
    final course = await _repository.getCourseById(courseId);

    return course!.toJson();
  }

  Future<Map<String, dynamic>> getCourse(String courseId) async {
    final course = await _repository.getCourseById(courseId);
    if (course == null) {
      throw NotFoundException('Course not found');
    }

    final modules = await _repository.getModulesByCourse(courseId);
    final modulesWithLessons = <Map<String, dynamic>>[];

    for (final module in modules) {
      final lessons = await _repository.getLessonsByModule(module.id);
      modulesWithLessons.add({
        ...module.toJson(),
        'lessons': lessons.map((l) => l.toJson()).toList(),
      });
    }

    return {
      ...course.toJson(),
      'modules': modulesWithLessons,
    };
  }

  Future<List<Map<String, dynamic>>> getAllCourses({
    String? category,
    String? level,
    String? status,
  }) async {
    final courses = await _repository.getAllCourses(
      category: category,
      level: level,
      status: status,
    );

    return courses.map((c) => c.toJson()).toList();
  }

  Future<List<Map<String, dynamic>>> getMyCourses(String tutorId) async {
    final courses = await _repository.getCoursesByTutor(tutorId);
    return courses.map((c) => c.toJson()).toList();
  }

  Future<void> updateCourse(String courseId, String tutorId, UpdateCourseRequest request) async {
    final course = await _repository.getCourseById(courseId);
    if (course == null) {
      throw NotFoundException('Course not found');
    }

    if (course.tutorId != tutorId) {
      throw UnauthorizedException('You can only update your own courses');
    }

    await _repository.updateCourse(courseId, request);
  }

  Future<void> deleteCourse(String courseId, String tutorId) async {
    final course = await _repository.getCourseById(courseId);
    if (course == null) {
      throw NotFoundException('Course not found');
    }

    if (course.tutorId != tutorId) {
      throw UnauthorizedException('You can only delete your own courses');
    }

    await _repository.deleteCourse(courseId);
  }

  // Module operations
  Future<Map<String, dynamic>> addModule(String courseId, String tutorId, CreateModuleRequest request) async {
    final errors = request.validate();
    if (errors.isNotEmpty) {
      throw ValidationException(errors.join(', '));
    }

    final course = await _repository.getCourseById(courseId);
    if (course == null) {
      throw NotFoundException('Course not found');
    }

    if (course.tutorId != tutorId) {
      throw UnauthorizedException('You can only add modules to your own courses');
    }

    final moduleId = await _repository.createModule(courseId, request);
    return {'id': moduleId, 'message': 'Module created successfully'};
  }

  Future<void> deleteModule(String moduleId, String tutorId) async {
    // Ensure module exists and belongs to a course owned by this tutor
    final module = await _repository.getModuleById(moduleId);
    if (module == null) {
      throw NotFoundException('Module not found');
    }

    final course = await _repository.getCourseById(module.courseId);
    if (course == null) {
      throw NotFoundException('Course not found');
    }

    if (course.tutorId != tutorId) {
      throw UnauthorizedException('You can only modify modules for your own courses');
    }

    await _repository.deleteModule(moduleId);
  }

  // Lesson operations
  Future<Map<String, dynamic>> addLesson(String moduleId, String tutorId, CreateLessonRequest request) async {
    final errors = request.validate();
    if (errors.isNotEmpty) {
      throw ValidationException(errors.join(', '));
    }

    // Ensure module belongs to a course owned by this tutor
    final module = await _repository.getModuleById(moduleId);
    if (module == null) {
      throw NotFoundException('Module not found');
    }

    final course = await _repository.getCourseById(module.courseId);
    if (course == null) {
      throw NotFoundException('Course not found');
    }

    if (course.tutorId != tutorId) {
      throw UnauthorizedException('You can only add lessons to your own courses');
    }

    final lessonId = await _repository.createLesson(moduleId, request);
    return {'id': lessonId, 'message': 'Lesson created successfully'};
  }

  Future<void> deleteLesson(String lessonId, String tutorId) async {
    // Ensure lesson belongs to a module/course owned by this tutor
    final lesson = await _repository.getLessonById(lessonId);
    if (lesson == null) {
      throw NotFoundException('Lesson not found');
    }

    final module = await _repository.getModuleById(lesson.moduleId);
    if (module == null) {
      throw NotFoundException('Module not found');
    }

    final course = await _repository.getCourseById(module.courseId);
    if (course == null) {
      throw NotFoundException('Course not found');
    }

    if (course.tutorId != tutorId) {
      throw UnauthorizedException('You can only delete lessons from your own courses');
    }

    await _repository.deleteLesson(lessonId);
  }

  Future<List<Map<String, dynamic>>> searchCourses(String query) async {
    if (query.trim().isEmpty) {
      throw ValidationException('Search query cannot be empty');
    }

    final courses = await _repository.searchCourses(query);
    return courses.map((c) => c.toJson()).toList();
  }
}
