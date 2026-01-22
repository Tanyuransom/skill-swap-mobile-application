import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../controllers/verification_controller.dart';

class VerificationRoutes {
  final VerificationController _controller = VerificationController();

  Handler get router {
    final router = Router();

    // Authenticated Routes
    // Note: The main server.dart should wrap these specific routes with auth middleware
    // Or we apply it here. Usually better to apply in server.dart pipeline if applying to all.
    // But distinct routes might need distinct pipelines.
    // Let's assume server.dart applies global middleware chain.
    
    // Request verification
    router.post('/request', _controller.requestVerification);
    
    // Get Exam
    router.get('/exam/<requestId>', _controller.getExam);
    
    // Submit Exam
    router.post('/exam/<requestId>/submit', _controller.submitExam);
    
    // Get Badges (Public)
    router.get('/badges/<userId>', _controller.getBadges);

    router.get('/health', (Request request) {
      return Response.ok('{"status": "ok"}', headers: {'content-type': 'application/json'});
    });

    return router;
  }
}
