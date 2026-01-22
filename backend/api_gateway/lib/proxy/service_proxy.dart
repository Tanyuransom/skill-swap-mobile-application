import 'package:http/http.dart' as http;
import 'package:shelf/shelf.dart';
import 'dart:async';

class ServiceProxy {
  final http.Client _client = http.Client();
  final Duration timeout = Duration(seconds: 30);

  /// Forward request to a service - SIMPLIFIED
  Future<Response> forward(
    Request request,
    String targetUrl,
  ) async {
    try {
      // Get the path after /api/servicename/
      // Example: /api/auth/register -> /register
      final fullPath = request.url.path;
      final segments = fullPath.split('/').where((s) => s.isNotEmpty).toList();
      
      // Skip 'api' and service name, keep the rest
      final servicePath = segments.length > 2 
          ? '/${segments.skip(2).join('/')}' 
          : '/';
      
      // Build target URL
      final targetUri = Uri.parse('$targetUrl$servicePath');
      
      // Read request body
      final body = await request.readAsString();
      
      // Copy headers
      final headers = Map<String, String>.from(request.headers);
      headers['content-type'] = 'application/json';
      headers.remove('host');
      headers.remove('content-length');
      
      // Forward request
      http.Response response;
      
      switch (request.method.toUpperCase()) {
        case 'GET':
          response = await _client.get(targetUri, headers: headers).timeout(timeout);
          break;
        case 'POST':
          response = await _client.post(targetUri, headers: headers, body: body).timeout(timeout);
          break;
        case 'PUT':
          response = await _client.put(targetUri, headers: headers, body: body).timeout(timeout);
          break;
        case 'DELETE':
          response = await _client.delete(targetUri, headers: headers, body: body).timeout(timeout);
          break;
        case 'PATCH':
          response = await _client.patch(targetUri, headers: headers, body: body).timeout(timeout);
          break;
        default:
          return Response(405, body: '{"error": "Method not allowed"}');
      }

      // Return response
      return Response(
        response.statusCode,
        body: response.body,
        headers: {'content-type': response.headers['content-type'] ?? 'application/json'},
      );
    } on TimeoutException {
      return Response.internalServerError(
        body: '{"error": "Service timeout"}',
        headers: {'content-type': 'application/json'},
      );
    } catch (e) {
      print('❌ Proxy error: $e');
      return Response.internalServerError(
        body: '{"error": "Service unavailable: ${e.toString()}"}',
        headers: {'content-type': 'application/json'},
      );
    }
  }

  void close() {
    _client.close();
  }
}
