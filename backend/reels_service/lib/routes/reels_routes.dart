import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:skillswapp_shared/skillswapp_shared.dart';
import '../controllers/reels_controller.dart';

class ReelsRoutes {
  final ReelsController _controller = ReelsController();

  Router get router {
    final router = Router();

    router.post('/reels', (Request request) => _controller.createReel(request));
    router.get('/reels/feed', (Request request) => _controller.getReelsFeed(request));
    router.post('/reels/<reelId>/view', (Request request, String reelId) => _controller.trackView(request, reelId));

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
