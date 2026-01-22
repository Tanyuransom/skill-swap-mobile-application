import 'dart:io';
import 'package:shelf/shelf_io.dart' as io;
import 'package:dotenv/dotenv.dart';
import 'package:skillswapp_shared/skillswapp_shared.dart';
import '../lib/routes/analytics_routes.dart';

void main() async {
  final env = DotEnv(includePlatformEnvironment: true)..load();

  await PostgresClient.initialize();
  print('✅ Database connection pool initialized');

  final routes = AnalyticsRoutes();
  final handler = routes.handler;

  final port = int.parse(env['ANALYTICS_SERVICE_PORT'] ?? '8088');
  final server = await io.serve(handler, '0.0.0.0', port);

  print('🚀 Analytics Service running on http://${server.address.host}:${server.port}');
  print('📊 Tracking: Watch time, Likes, Shares, Subscribers');
  print('💰 Revenue Model: 40% watch time, 30% engagement, 30% subscribers');
}
