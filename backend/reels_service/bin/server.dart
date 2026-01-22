import 'dart:io';
import 'package:shelf/shelf_io.dart' as io;
import 'package:dotenv/dotenv.dart';
import 'package:skillswapp_shared/skillswapp_shared.dart';
import '../lib/routes/reels_routes.dart';

void main() async {
  final env = DotEnv(includePlatformEnvironment: true)..load();

  await PostgresClient.initialize();
  print('✅ Database connection pool initialized');

  final routes = ReelsRoutes();
  final handler = routes.handler;

  final port = int.parse(env['REELS_SERVICE_PORT'] ?? '8090');
  final server = await io.serve(handler, '0.0.0.0', port);

  print('🚀 Reels Service running on http://${server.address.host}:${server.port}');
  print('🎬 TikTok-style short videos (15-60 seconds)');
  print('📊 Viral metrics & completion tracking');
}
