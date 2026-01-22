import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:skillswapp_shared/skillswapp_shared.dart';
import '../lib/routes/course_routes.dart';

void main() async {
  // Initialize database
  await PostgresClient.initialize();
  print('✅ Database connected successfully');

  // Setup routes
  final courseRoutes = CourseRoutes();
  final router = courseRoutes.router;

  // Middleware pipeline
  final handler = Pipeline()
      .addMiddleware(loggingMiddleware())
      .addMiddleware(corsMiddleware())
      .addHandler(router.call);

  // Start server
  final port = 8083;
  final server = await shelf_io.serve(handler, '0.0.0.0', port);

  print('🚀 Course Service running on http://${server.address.host}:${server.port}');
}
