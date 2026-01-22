import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:skillswapp_shared/skillswapp_shared.dart';
import '../controllers/course_controller.dart';

class CourseRoutes {
  final CourseController _controller = CourseController();

  Router get router {
    final router = Router();

    // Health check
    router.get('/health', (Request request) {
      return Response.ok(
        '{"success": true, "message": "Course Service is healthy", "service": "course_service", "version": "1.0.0"}',
        headers: {'Content-Type': 'application/json'},
      );
    });

    // Public routes
    router.get('/courses', _controller.getAllCourses);
    router.get('/courses/<courseId>', _controller.getCourse);
    router.get('/courses/search', _controller.searchCourses);

    // Protected routes (require authentication)
    router.post(
      '/courses',
      Pipeline().addMiddleware(authMiddleware()).addHandler(_controller.createCourse),
    );

    router.get(
      '/my-courses',
      Pipeline().addMiddleware(authMiddleware()).addHandler(_controller.getMyCourses),
    );

    router.put('/courses/<courseId>', (Request request, String courseId) {
      return Pipeline()
          .addMiddleware(authMiddleware())
          .addHandler((req) => _controller.updateCourse(req, courseId))(request);
    });

    router.delete('/courses/<courseId>', (Request request, String courseId) {
      return Pipeline()
          .addMiddleware(authMiddleware())
          .addHandler((req) => _controller.deleteCourse(req, courseId))(request);
    });

    router.post('/courses/<courseId>/modules', (Request request, String courseId) {
      return Pipeline()
          .addMiddleware(authMiddleware())
          .addHandler((req) => _controller.addModule(req, courseId))(request);
    });

    router.delete('/modules/<moduleId>', (Request request, String moduleId) {
      return Pipeline()
          .addMiddleware(authMiddleware())
          .addHandler((req) => _controller.deleteModule(req, moduleId))(request);
    });

    router.post('/modules/<moduleId>/lessons', (Request request, String moduleId) {
      return Pipeline()
          .addMiddleware(authMiddleware())
          .addHandler((req) => _controller.addLesson(req, moduleId))(request);
    });

    router.delete('/lessons/<lessonId>', (Request request, String lessonId) {
      return Pipeline()
          .addMiddleware(authMiddleware())
          .addHandler((req) => _controller.deleteLesson(req, lessonId))(request);
    });

    return router;
  }
}
