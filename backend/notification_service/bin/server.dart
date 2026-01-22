import 'dart:io';
import 'package:shelf/shelf_io.dart' as io;
import 'package:dotenv/dotenv.dart';
import 'package:skillswapp_shared/skillswapp_shared.dart';
import '../lib/routes/notification_routes.dart';

void main() async {
  final env = DotEnv(includePlatformEnvironment: true)..load();
  await PostgresClient.initialize();
  
  final routes = NotificationRoutes();
  final port = int.parse(env['NOTIFICATION_SERVICE_PORT'] ?? '8094');
  final server = await io.serve(routes.handler, '0.0.0.0', port);

  print('🚀 Notification Service running on http://${server.address.host}:${server.port}');
  print('🔔 Features: Activity notifications, Unread tracking');
}
