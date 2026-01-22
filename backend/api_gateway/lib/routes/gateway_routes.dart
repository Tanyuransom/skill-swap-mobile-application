import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../proxy/service_proxy.dart';

class GatewayRoutes {
  final ServiceProxy _proxy = ServiceProxy();
  
  // Service URLs from environment
  final Map<String, String> _serviceUrls = {
    'auth': 'http://localhost:8081',
    'user': 'http://localhost:8082',
    'course': 'http://localhost:8083',
    'verification': 'http://localhost:8084',
    'learning': 'http://localhost:8085',
    'payment': 'http://localhost:8086',
    'messaging': 'http://localhost:8087',
    'review': 'http://localhost:8088',
    'certificate': 'http://localhost:8089',
    'admin': 'http://localhost:8090',
  };

  Router get router {
    final router = Router();

    // Route to Auth Service
    router.all('/api/auth/<path|.*>', (Request request, String path) async {
      return _proxy.forward(request, _serviceUrls['auth']!);
    });

    // Route to User Service
    router.all('/api/users/<path|.*>', (Request request, String path) async {
      final newRequest = request.change(path: path);
      return _proxy.forward(newRequest, _serviceUrls['user']!);
    });

    // Route to Course Service
    router.all('/api/courses/<path|.*>', (Request request, String path) async {
      final newRequest = request.change(path: path);
      return _proxy.forward(newRequest, _serviceUrls['course']!);
    });

    // Route to Verification Service
    router.all('/api/verification/<path|.*>', (Request request, String path) async {
      final newRequest = request.change(path: path);
      return _proxy.forward(newRequest, _serviceUrls['verification']!);
    });

    // Route to Learning Service
    router.all('/api/learning/<path|.*>', (Request request, String path) async {
      final newRequest = request.change(path: path);
      return _proxy.forward(newRequest, _serviceUrls['learning']!);
    });

    // Route to Payment Service
    router.all('/api/payments/<path|.*>', (Request request, String path) async {
      final newRequest = request.change(path: path);
      return _proxy.forward(newRequest, _serviceUrls['payment']!);
    });

    // Route to Messaging Service
    router.all('/api/messages/<path|.*>', (Request request, String path) async {
      final newRequest = request.change(path: path);
      return _proxy.forward(newRequest, _serviceUrls['messaging']!);
    });

    // Route to Review Service
    router.all('/api/reviews/<path|.*>', (Request request, String path) async {
      final newRequest = request.change(path: path);
      return _proxy.forward(newRequest, _serviceUrls['review']!);
    });

    // Route to Certificate Service
    router.all('/api/certificates/<path|.*>', (Request request, String path) async {
      final newRequest = request.change(path: path);
      return _proxy.forward(newRequest, _serviceUrls['certificate']!);
    });

    // Route to Admin Service
    router.all('/api/admin/<path|.*>', (Request request, String path) async {
      final newRequest = request.change(path: path);
      return _proxy.forward(newRequest, _serviceUrls['admin']!);
    });

    return router;
  }
}
