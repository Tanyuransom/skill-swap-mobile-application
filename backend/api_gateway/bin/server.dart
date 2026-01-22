import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';
import 'package:http/http.dart' as http;
import '../../shared/lib/skillswapp_shared.dart';

Future<Response> proxyRequest(Request request, String targetUrl) async {
  try {
    final client = http.Client();
    final uri = Uri.parse(targetUrl);
    final body = await request.readAsString();
    final headers = {'Content-Type': 'application/json'};
    
    http.Response response;
    
    switch (request.method.toUpperCase()) {
      case 'GET':
        response = await client.get(uri, headers: headers);
        break;
      case 'POST':
        response = await client.post(uri, headers: headers, body: body);
        break;
      case 'PUT':
        response = await client.put(uri, headers: headers, body: body);
        break;
      case 'DELETE':
        response = await client.delete(uri, headers: headers, body: body);
        break;
      case 'PATCH':
        response = await client.patch(uri, headers: headers, body: body);
        break;
      default:
        return Response(405, body: '{"error": "Method not allowed"}');
    }
    
    client.close();
    
    return Response(
      response.statusCode,
      body: response.body,
      headers: {'Content-Type': 'application/json'},
    );
  } catch (e) {
    print('Proxy error: $e');
    return Response.internalServerError(
      body: '{"error": "Service unavailable: ${e.toString()}"}',
      headers: {'Content-Type': 'application/json'},
    );
  }
}

void main() async {
  final router = Router();

  // Health check
  router.get('/health', (Request request) {
    return Response.ok(
      '{"success": true, "message": "API Gateway is healthy", "service": "api_gateway", "version": "1.0.0"}',
      headers: {'Content-Type': 'application/json'},
    );
  });

  // Auth Service routes
  router.all('/api/auth/<path|.*>', (Request request, String path) async {
    return proxyRequest(request, 'http://localhost:8081/$path');
  });

  // User Service routes
  router.all('/api/users/<path|.*>', (Request request, String path) async {
    return proxyRequest(request, 'http://localhost:8082/$path');
  });

  // Middleware
  final handler = Pipeline()
      .addMiddleware(loggingMiddleware())
      .addMiddleware(corsMiddleware())
      .addHandler(router.call);

  final port = 8080;
  final server = await shelf_io.serve(handler, '0.0.0.0', port);

  print('🚀 API Gateway running on http://${server.address.host}:${server.port}');
}
