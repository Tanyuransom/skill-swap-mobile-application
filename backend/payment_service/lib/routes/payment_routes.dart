import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:skillswapp_shared/skillswapp_shared.dart';
import '../controllers/payment_controller.dart';

class PaymentRoutes {
  final PaymentController _controller = PaymentController();

  Router get router {
    final router = Router();

    // Initiate payment
    router.post('/payment/initiate', (Request request) {
      return _controller.initiatePayment(request);
    });

    // Confirm payment
    router.post('/payment/confirm/<transactionId>', (Request request, String transactionId) {
      return _controller.confirmPayment(request, transactionId);
    });

    // Get payment history
    router.get('/payment/history', (Request request) {
      return _controller.getPaymentHistory(request);
    });

    // Get wallet
    router.get('/wallet', (Request request) {
      return _controller.getWallet(request);
    });

    // Request payout
    router.post('/payout', (Request request) {
      return _controller.requestPayout(request);
    });

    return router;
  }

  Handler get handler {
    final router = this.router;

    final pipeline = Pipeline()
        .addMiddleware(corsMiddleware())
        .addMiddleware(loggingMiddleware())
        .addMiddleware(authMiddleware())
        .addHandler(router.call);

    return pipeline;
  }
}
