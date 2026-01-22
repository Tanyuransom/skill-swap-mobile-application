import 'dart:io';
import 'package:shelf/shelf_io.dart' as io;
import 'package:dotenv/dotenv.dart';
import 'package:skillswapp_shared/skillswapp_shared.dart';
import '../lib/routes/interaction_routes.dart';

void main() async {
  final env = DotEnv(includePlatformEnvironment: true)..load();
  await PostgresClient.initialize();
  
  final routes = InteractionRoutes();
  final port = int.parse(env['INTERACTION_SERVICE_PORT'] ?? '8093');
  final server = await io.serve(routes.handler, '0.0.0.0', port);

  print('🚀 Interaction Service running on http://${server.address.host}:${server.port}');
  print('💬 Features: Likes, Comments, Shares, Saves');
}
