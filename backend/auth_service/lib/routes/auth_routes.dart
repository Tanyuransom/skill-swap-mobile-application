import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../controllers/auth_controller.dart';
import '../../../shared/lib/skillswapp_shared.dart';

class AuthRoutes {
  final AuthController _controller = AuthController();

  Router get router {
    final router = Router();

    // Public routes (no authentication required)
    router.post('/register', _controller.register);
    router.post('/verify-otp', _controller.verifyOTP);
    router.post('/resend-otp', _controller.resendOTP);
    router.post('/login', _controller.login);
    router.post('/refresh-token', _controller.refreshToken);
    router.post('/forgot-password', _controller.forgotPassword);
    router.post('/reset-password', _controller.resetPassword);
    router.post('/google-auth', _controller.googleAuth);

    // Protected routes (authentication required)
    router.post(
        '/logout',
        Pipeline()
            .addMiddleware(authMiddleware())
            .addHandler(_controller.logout));
    router.get(
        '/me',
        Pipeline()
            .addMiddleware(authMiddleware())
            .addHandler(_controller.getCurrentUser));

    return router;
  }
}
