import 'package:shelf/shelf.dart';
import 'dart:collection';

class RateLimiter {
  final int maxRequests;
  final Duration window;
  final Map<String, Queue<DateTime>> _requests = {};

  RateLimiter({
    this.maxRequests = 100,
    this.window = const Duration(minutes: 1),
  });

  bool isAllowed(String identifier) {
    final now = DateTime.now();
    
    // Get or create request queue for this identifier
    _requests.putIfAbsent(identifier, () => Queue<DateTime>());
    final queue = _requests[identifier]!;
    
    // Remove old requests outside the window
    while (queue.isNotEmpty && now.difference(queue.first) > window) {
      queue.removeFirst();
    }
    
    // Check if limit exceeded
    if (queue.length >= maxRequests) {
      return false;
    }
    
    // Add current request
    queue.add(now);
    return true;
  }

  void cleanup() {
    final now = DateTime.now();
    _requests.removeWhere((key, queue) {
      while (queue.isNotEmpty && now.difference(queue.first) > window) {
        queue.removeFirst();
      }
      return queue.isEmpty;
    });
  }
}

/// Rate limiting middleware
Middleware rateLimitMiddleware({
  int maxRequests = 100,
  Duration window = const Duration(minutes: 1),
}) {
  final limiter = RateLimiter(maxRequests: maxRequests, window: window);
  
  // Cleanup old entries every 5 minutes
  Future.delayed(Duration(minutes: 5), () => limiter.cleanup());
  
  return (Handler handler) {
    return (Request request) async {
      // Use IP address as identifier
      final identifier = request.headers['x-forwarded-for'] ?? 
                        request.context['shelf.io.connection_info']?.toString() ?? 
                        'unknown';
      
      if (!limiter.isAllowed(identifier)) {
        return Response(
          429,
          body: '{"error": "Rate limit exceeded. Please try again later."}',
          headers: {
            'content-type': 'application/json',
            'retry-after': window.inSeconds.toString(),
          },
        );
      }
      
      return handler(request);
    };
  };
}
