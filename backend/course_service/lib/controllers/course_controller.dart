import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:skillswapp_shared/skillswapp_shared.dart';
import '../models/course_model.dart';
import '../models/module_model.dart';
import '../models/lesson_model.dart';
import '../services/course_service.dart';

class CourseController {
  final CourseService _service = CourseService();

  Future<Response> createCourse(Request request) async {
    try {
      final userId = request.context['userId'] as String;
      final body = await request.readAsString();
      final data = jsonDecode(body);
      
      final courseRequest = CreateCourseRequest.fromJson(data);
      final course = await _service.createCourse(userId, courseRequest);
      
      return ApiResponse.success(
        message: 'Course created successfully',
        data: course,
      ).toResponse();
    } on ValidationException catch (e) {
      return ApiResponse.error(message: e.message).toResponse(statusCode: 400);
    } catch (e) {
      return ApiResponse.error(message: 'Failed to create course: ${e.toString()}').toResponse(statusCode: 500);
    }
  }

  Future<Response> getCourse(Request request, String courseId) async {
    try {
      final course = await _service.getCourse(courseId);
      return ApiResponse.success(data: course).toResponse();
    } on NotFoundException catch (e) {
      return ApiResponse.error(message: e.message).toResponse(statusCode: 404);
    } catch (e) {
      return ApiResponse.error(message: 'Failed to get course').toResponse(statusCode: 500);
    }
  }

  Future<Response> getAllCourses(Request request) async {
    try {
      final params = request.url.queryParameters;
      final courses = await _service.getAllCourses(
        category: params['category'],
        level: params['level'],
        status: params['status'],
      );
      
      return ApiResponse.success(data: courses).toResponse();
    } catch (e) {
      return ApiResponse.error(message: 'Failed to get courses').toResponse(statusCode: 500);
    }
  }

  Future<Response> getMyCourses(Request request) async {
    try {
      final userId = request.context['userId'] as String;
      final courses = await _service.getMyCourses(userId);
      
      return ApiResponse.success(data: courses).toResponse();
    } catch (e) {
      return ApiResponse.error(message: 'Failed to get courses').toResponse(statusCode: 500);
    }
  }

  Future<Response> updateCourse(Request request, String courseId) async {
    try {
      final userId = request.context['userId'] as String;
      final body = await request.readAsString();
      final data = jsonDecode(body);
      
      final updateRequest = UpdateCourseRequest.fromJson(data);
      await _service.updateCourse(courseId, userId, updateRequest);
      
      return ApiResponse.success(message: 'Course updated successfully').toResponse();
    } on NotFoundException catch (e) {
      return ApiResponse.error(message: e.message).toResponse(statusCode: 404);
    } on UnauthorizedException catch (e) {
      return ApiResponse.error(message: e.message).toResponse(statusCode: 403);
    } catch (e) {
      return ApiResponse.error(message: 'Failed to update course').toResponse(statusCode: 500);
    }
  }

  Future<Response> deleteCourse(Request request, String courseId) async {
    try {
      final userId = request.context['userId'] as String;
      await _service.deleteCourse(courseId, userId);
      
      return ApiResponse.success(message: 'Course deleted successfully').toResponse();
    } on NotFoundException catch (e) {
      return ApiResponse.error(message: e.message).toResponse(statusCode: 404);
    } on UnauthorizedException catch (e) {
      return ApiResponse.error(message: e.message).toResponse(statusCode: 403);
    } catch (e) {
      return ApiResponse.error(message: 'Failed to delete course').toResponse(statusCode: 500);
    }
  }

  Future<Response> addModule(Request request, String courseId) async {
    try {
      final userId = request.context['userId'] as String;
      final body = await request.readAsString();
      final data = jsonDecode(body);
      
      final moduleRequest = CreateModuleRequest.fromJson(data);
      final result = await _service.addModule(courseId, userId, moduleRequest);
      
      return ApiResponse.success(
        message: 'Module added successfully',
        data: result,
      ).toResponse();
    } on ValidationException catch (e) {
      return ApiResponse.error(message: e.message).toResponse(statusCode: 400);
    } on NotFoundException catch (e) {
      return ApiResponse.error(message: e.message).toResponse(statusCode: 404);
    } on UnauthorizedException catch (e) {
      return ApiResponse.error(message: e.message).toResponse(statusCode: 403);
    } catch (e) {
      return ApiResponse.error(message: 'Failed to add module').toResponse(statusCode: 500);
    }
  }

  Future<Response> deleteModule(Request request, String moduleId) async {
    try {
      final userId = request.context['userId'] as String;
      await _service.deleteModule(moduleId, userId);
      
      return ApiResponse.success(message: 'Module deleted successfully').toResponse();
    } catch (e) {
      return ApiResponse.error(message: 'Failed to delete module').toResponse(statusCode: 500);
    }
  }

  Future<Response> addLesson(Request request, String moduleId) async {
    try {
      final userId = request.context['userId'] as String;
      final body = await request.readAsString();
      final data = jsonDecode(body);
      
      final lessonRequest = CreateLessonRequest.fromJson(data);
      final result = await _service.addLesson(moduleId, userId, lessonRequest);
      
      return ApiResponse.success(
        message: 'Lesson added successfully',
        data: result,
      ).toResponse();
    } on ValidationException catch (e) {
      return ApiResponse.error(message: e.message).toResponse(statusCode: 400);
    } catch (e) {
      return ApiResponse.error(message: 'Failed to add lesson').toResponse(statusCode: 500);
    }
  }

  Future<Response> deleteLesson(Request request, String lessonId) async {
    try {
      final userId = request.context['userId'] as String;
      await _service.deleteLesson(lessonId, userId);
      
      return ApiResponse.success(message: 'Lesson deleted successfully').toResponse();
    } catch (e) {
      return ApiResponse.error(message: 'Failed to delete lesson').toResponse(statusCode: 500);
    }
  }

  Future<Response> searchCourses(Request request) async {
    try {
      final query = request.url.queryParameters['q'] ?? '';
      final courses = await _service.searchCourses(query);
      
      return ApiResponse.success(data: courses).toResponse();
    } on ValidationException catch (e) {
      return ApiResponse.error(message: e.message).toResponse(statusCode: 400);
    } catch (e) {
      return ApiResponse.error(message: 'Failed to search courses').toResponse(statusCode: 500);
    }
  }
}
