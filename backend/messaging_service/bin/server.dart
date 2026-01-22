import 'dart:io';
import 'package:shelf/shelf_io.dart' as io;
import 'package:dotenv/dotenv.dart';
import 'package:skillswapp_shared/skillswapp_shared.dart';
import '../lib/routes/messaging_routes.dart';

void main() async {
  final env = DotEnv(includePlatformEnvironment: true)..load();
  await PostgresClient.initialize();
  
  final routes = MessagingRoutes();
  final port = int.parse(env['MESSAGING_SERVICE_PORT'] ?? '8092');
  final server = await io.serve(routes.handler, '0.0.0.0', port);

  print('🚀 Messaging Service running on http://${server.address.host}:${server.port}');
  print('💬 Features: Direct chat, Group chat, Share content');
  print('📱 Real-time messaging ready!');
}
