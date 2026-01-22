// ignore_for_file: unnecessary_import

import 'dart:io';
import 'package:shelf/shelf_io.dart' as io;
import 'package:dotenv/dotenv.dart';
import 'package:skillswapp_shared/skillswapp_shared.dart';
import '../lib/routes/social_graph_routes.dart';

void main() async {
  final env = DotEnv(includePlatformEnvironment: true)..load();
  await PostgresClient.initialize();
  
  final routes = SocialGraphRoutes();
  final port = int.parse(env['SOCIAL_GRAPH_SERVICE_PORT'] ?? '8091');
  final server = await io.serve(routes.handler, '0.0.0.0', port);

  print('🚀 Social Graph Service running on http://${server.address.host}:${server.port}');
  print('👥 Features: Friend requests, Accept/Reject, Friends list');
}
