import 'package:shelf/shelf.dart';
import 'package:uuid/uuid.dart';

/// Middleware to add correlation ID to requests
Middleware correlationIdMiddleware() {
  final uuid = Uuid();
  
  return (Handler handler) {
    return (Request request) async {
      // Generate or use existing correlation ID
      final correlationId = request.headers['x-correlation-id'] ?? uuid.v4();
      
      // Add to request context
      final updatedRequest = request.change(
        context: {'correlationId': correlationId},
      );
      
      // Process request
      final response = await handler(updatedRequest);
      
      // Add correlation ID to response
      return response.change(
        headers: {'x-correlation-id': correlationId},
      );
    };
  };
}
