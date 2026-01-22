import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:skillswapp_shared/skillswapp_shared.dart';
import '../controllers/subscription_controller.dart';

class SubscriptionRoutes {
  final SubscriptionController _controller = SubscriptionController();

  Router get router {
    final router = Router();

    // Subscribe to premium
    router.post('/subscribe', (Request request) {
      return _controller.subscribe(request);
    });

    // Get subscription status
    router.get('/subscription/status', (Request request) {
      return _controller.getStatus(request);
    });

    // Cancel subscription
    router.post('/subscription/cancel', (Request request) {
      return _controller.cancelSubscription(request);
    });

    // Check content access
    router.get('/content/<lessonId>/access', (Request request, String lessonId) {
      return _controller.checkContentAccess(request, lessonId);
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
