import 'dart:io';
import 'package:shelf/shelf_io.dart' as io;
import 'package:dotenv/dotenv.dart';
import 'package:skillswapp_shared/skillswapp_shared.dart';
import '../lib/routes/subscription_routes.dart';

void main() async {
  final env = DotEnv(includePlatformEnvironment: true)..load();

  await PostgresClient.initialize();
  print('✅ Database connection pool initialized');

  final routes = SubscriptionRoutes();
  final handler = routes.handler;

  final port = int.parse(env['SUBSCRIPTION_SERVICE_PORT'] ?? '8087');
  final server = await io.serve(handler, '0.0.0.0', port);

  print('🚀 Subscription Service running on http://${server.address.host}:${server.port}');
  print('💎 Premium Subscription: 2,500 XAF/month');
  print('📱 Payment: Orange Money CM, MTN Mobile Money CM');
}
