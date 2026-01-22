import 'package:shelf/shelf.dart';
import '../utils/jwt_utils.dart';
import '../exceptions/auth_exception.dart';

/// Authentication middleware for protecting routes
Middleware authMiddleware() {
  return (Handler handler) {
    return (Request request) async {
      try {
        // Extract token from Authorization header
        final authHeader = request.headers['authorization'];
        
        if (authHeader == null || !authHeader.startsWith('Bearer ')) {
          throw AuthException('Missing or invalid authorization header');
        }

        final token = authHeader.substring(7); // Remove 'Bearer ' prefix

        // Verify token
        final payload = JWTUtils.verifyToken(token);
        
        if (payload == null) {
          throw AuthException('Invalid token');
        }

        // Check token type
        if (payload['type'] != 'access') {
          throw AuthException('Invalid token type');
        }

        // Add user info to request context
        final updatedRequest = request.change(context: {
          'userId': payload['userId'],
          'email': payload['email'],
          'role': payload['role'],
        });

        return await handler(updatedRequest);
      } on AuthException catch (e) {
        return Response.unauthorized(
          '{"error": "${e.message}"}',
          headers: {'Content-Type': 'application/json'},
        );
      } catch (e) {
        return Response.unauthorized(
          '{"error": "Authentication failed"}',
          headers: {'Content-Type': 'application/json'},
        );
      }
    };
  };
}

/// Role-based authorization middleware
Middleware roleMiddleware(List<String> allowedRoles) {
  return (Handler handler) {
    return (Request request) async {
      final role = request.context['role'] as String?;

      if (role == null || !allowedRoles.contains(role)) {
        return Response.forbidden(
          '{"error": "Insufficient permissions"}',
          headers: {'Content-Type': 'application/json'},
        );
      }

      return await handler(request);
    };
  };
}
