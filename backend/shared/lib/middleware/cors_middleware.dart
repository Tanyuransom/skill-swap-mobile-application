import 'package:shelf/shelf.dart';

/// CORS middleware for handling cross-origin requests
Middleware corsMiddleware() {
  const corsHeaders = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, PATCH, OPTIONS',
    'Access-Control-Allow-Headers': 'Origin, Content-Type, Authorization, Accept',
    'Access-Control-Max-Age': '86400',
  };

  return (Handler handler) {
    return (Request request) async {
      // Handle preflight requests
      if (request.method == 'OPTIONS') {
        return Response.ok('', headers: corsHeaders);
      }

      // Process request and add CORS headers to response
      final response = await handler(request);
      return response.change(headers: corsHeaders);
    };
  };
}
