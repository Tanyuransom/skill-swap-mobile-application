import 'dart:io';
import 'package:shelf/shelf_io.dart' as io;
import 'package:dotenv/dotenv.dart';
import 'package:skillswapp_shared/skillswapp_shared.dart';
import '../lib/routes/social_feed_routes.dart';

void main() async {
  final env = DotEnv(includePlatformEnvironment: true)..load();

  await PostgresClient.initialize();
  print('✅ Database connection pool initialized');

  final routes = SocialFeedRoutes();
  final handler = routes.handler;

  final port = int.parse(env['SOCIAL_FEED_SERVICE_PORT'] ?? '8089');
  final server = await io.serve(handler, '0.0.0.0', port);

  print('🚀 Social Feed Service running on http://${server.address.host}:${server.port}');
  print('📱 Features: Posts, Feed (For You/Following), Follow/Unfollow');
  print('🎯 Social media learning platform ready!');
}
