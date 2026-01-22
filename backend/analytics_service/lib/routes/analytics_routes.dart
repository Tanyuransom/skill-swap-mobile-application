import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:skillswapp_shared/skillswapp_shared.dart';
import '../controllers/analytics_controller.dart';

class AnalyticsRoutes {
  final AnalyticsController _controller = AnalyticsController();

  Router get router {
    final router = Router();

    // Track content view
    router.post('/analytics/track', (Request request) {
      return _controller.trackView(request);
    });

    // Get tutor dashboard
    router.get('/analytics/tutor/dashboard', (Request request) {
      return _controller.getTutorDashboard(request);
    });

    // Follow tutor
    router.post('/tutors/<tutorId>/follow', (Request request, String tutorId) {
      return _controller.followTutor(request, tutorId);
    });

    // Unfollow tutor
    router.delete('/tutors/<tutorId>/follow', (Request request, String tutorId) {
      return _controller.unfollowTutor(request, tutorId);
    });

    return router;
  }

  Handler get handler {
    final router = this.router;

    final pipeline = Pipeline()
        .addMiddleware(corsMiddleware())
        .addMiddleware(loggingMiddleware())
        .addMiddleware(authMiddleware())
        .addHandler(router.call);

    return pipeline;
  }
}
