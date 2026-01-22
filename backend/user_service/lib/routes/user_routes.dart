import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../controllers/user_controller.dart';
import '../../../shared/lib/skillswapp_shared.dart';

class UserRoutes {
  final UserController _controller = UserController();

  Router get router {
    final router = Router();

    // Public routes
    router.get('/profile/<userId>/public', _controller.getPublicProfile);

    // Protected routes (require authentication)
    router.get('/profile/<userId>', (Request request, String userId) {
      return Pipeline()
          .addMiddleware(authMiddleware())
          .addHandler((req) => _controller.getProfile(req, userId))(request);
    });
    
    router.put(
      '/profile',
      Pipeline().addMiddleware(authMiddleware()).addHandler(_controller.updateProfile),
    );

    router.get(
      '/settings',
      Pipeline().addMiddleware(authMiddleware()).addHandler(_controller.getSettings),
    );
    
    router.put(
      '/settings',
      Pipeline().addMiddleware(authMiddleware()).addHandler(_controller.updateSettings),
    );

    // Admin routes
    router.get(
      '/users',
      Pipeline().addMiddleware(authMiddleware()).addHandler(_controller.listUsers),
    );
    
    router.delete('/users/<userId>', (Request request, String userId) {
      return Pipeline()
          .addMiddleware(authMiddleware())
          .addHandler((req) => _controller.deleteUser(req, userId))(request);
    });
    
    router.patch('/users/<userId>/status', (Request request, String userId) {
      return Pipeline()
          .addMiddleware(authMiddleware())
          .addHandler((req) => _controller.updateUserStatus(req, userId))(request);
    });

    return router;
  }
}
