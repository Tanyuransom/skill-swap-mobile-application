import 'package:shelf/shelf.dart';
import 'package:logger/logger.dart';

final logger = Logger(
  printer: PrettyPrinter(
    methodCount: 0,
    errorMethodCount: 5,
    lineLength: 80,
    colors: true,
    printEmojis: true,
    printTime: true,
  ),
);

/// Logging middleware for request/response logging
Middleware loggingMiddleware() {
  return (Handler handler) {
    return (Request request) async {
      final startTime = DateTime.now();
      
      // Log incoming request
      logger.i('${request.method} ${request.requestedUri.path}');

      try {
        // Process request
        final response = await handler(request);
        
        final duration = DateTime.now().difference(startTime);
        
        // Log response
        logger.i(
          '${request.method} ${request.requestedUri.path} '
          '→ ${response.statusCode} (${duration.inMilliseconds}ms)',
        );

        return response;
      } catch (e, stackTrace) {
        final duration = DateTime.now().difference(startTime);
        
        // Log error
        logger.e(
          '${request.method} ${request.requestedUri.path} '
          '→ ERROR (${duration.inMilliseconds}ms)',
          error: e,
          stackTrace: stackTrace,
        );

        rethrow;
      }
    };
  };
}
