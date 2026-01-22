import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:skillswapp_shared/skillswapp_shared.dart';
import '../lib/routes/verification_routes.dart';

void main() async {
  // Initialize Database
  await PostgresClient.initialize();

  // Configure Routes
  final router = VerificationRoutes().router;

  // Pipeline with Middleware
  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(corsMiddleware()) // Use correct function name
      .addMiddleware(authMiddleware()) // Protects all routes by default, except specified public ones? 
                                       // Actually authMiddleware usually checks for token.
                                       // If /badges is public, we might need a custom middleware or conditional logic.
                                       // For simplicity, let's allow all for now and trust Controller to handle null user if needed,
                                       // or better: apply authMiddleware only to specific routes in VerificationRoutes?
                                       // The 'authMiddleware' from shared usually requires token. 
                                       
                                       // Correction: Let's apply authMiddleware globally for now. 
                                       // If we need public badge access, we can exclude it in middleware or make a separate pipeline.
                                       // Assuming tutor needs to be logged in for most things.
                                       // Badges can be fetched by logged in users.
      .addHandler(router);

  // Start Server
  final port = 8084;
  final server = await io.serve(handler, InternetAddress.anyIPv4, port);
  print('🚀 Verification Service running on http://${server.address.host}:${server.port}');
}
