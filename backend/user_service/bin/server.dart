import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';
import '../lib/routes/user_routes.dart';
import '../../shared/lib/skillswapp_shared.dart';

void main() async {
  // Initialize database connection
  await PostgresClient.initialize();

  // Test database connection
  final isConnected = await PostgresClient.testConnection();
  if (!isConnected) {
    print('❌ Failed to connect to database');
    exit(1);
  }

  print('✅ Database connected successfully');

  // Create router
  final router = Router();
  
  // Mount user routes
  final userRoutes = UserRoutes();
  router.mount('/', userRoutes.router.call);

  // Health check endpoint
  router.get('/health', (Request request) {
    return Response.ok(
      ApiResponse.success(
        message: 'User Service is healthy',
        data: {
          'service': 'user_service',
          'version': '1.0.0',
          'timestamp': DateTime.now().toIso8601String(),
        },
      ).toJsonString(),
      headers: {'Content-Type': 'application/json'},
    );
  });

  // Create pipeline with middleware
  final handler = Pipeline()
      .addMiddleware(loggingMiddleware())
      .addMiddleware(corsMiddleware())
      .addHandler(router.call);

  // Start server
  final port = int.parse(Platform.environment['PORT'] ?? '8082');
  final server = await shelf_io.serve(handler, '0.0.0.0', port);

  print('🚀 User Service running on http://${server.address.host}:${server.port}');
}
