import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:skillswapp_shared/skillswapp_shared.dart';
import '../controllers/learning_controller.dart';

class LearningRoutes {
  final LearningController _controller = LearningController();

  Router get router {
    final router = Router();

    // Enroll in a course
    router.post('/enroll/<courseId>', (Request request, String courseId) {
      return _controller.enrollInCourse(request, courseId);
    });

    // Get all enrollments for current user
    router.get('/enrollments', (Request request) {
      return _controller.getEnrollments(request);
    });

    // Get progress for a specific course
    router.get('/progress/<courseId>', (Request request, String courseId) {
      return _controller.getCourseProgress(request, courseId);
    });

    // Update progress (last accessed time)
    router.post('/progress', (Request request) {
      return _controller.updateProgress(request);
    });

    // Mark lesson as complete
    router.post('/complete/<lessonId>', (Request request, String lessonId) {
      return _controller.markLessonComplete(request, lessonId);
    });

    // Drop enrollment
    router.delete('/enroll/<enrollmentId>', (Request request, String enrollmentId) {
      return _controller.dropEnrollment(request, enrollmentId);
    });

    return router;
  }

  Handler get handler {
    final router = this.router;

    // Apply middleware
    final pipeline = Pipeline()
        .addMiddleware(corsMiddleware())
        .addMiddleware(loggingMiddleware())
        .addMiddleware(authMiddleware()) // Require authentication for all routes
        .addHandler(router.call);

    return pipeline;
  }
}
