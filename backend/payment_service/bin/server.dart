import 'dart:io';
import 'package:shelf/shelf_io.dart' as io;
import 'package:dotenv/dotenv.dart';
import 'package:skillswapp_shared/skillswapp_shared.dart';
import '../lib/routes/payment_routes.dart';

void main() async {
  // Load environment variables
  final env = DotEnv(includePlatformEnvironment: true)..load();

  // Initialize database
  await PostgresClient.initialize();
  print('✅ Database connection pool initialized');

  // Create routes
  final routes = PaymentRoutes();
  final handler = routes.handler;

  // Start server
  final port = int.parse(env['PAYMENT_SERVICE_PORT'] ?? '8086');
  final server = await io.serve(handler, '0.0.0.0', port);

  print('🚀 Payment Service running on http://${server.address.host}:${server.port}');
  print('💰 Currency: XAF (Central African Franc)');
  print('📱 Payment Methods: Orange Money CM, MTN Mobile Money CM');
}
