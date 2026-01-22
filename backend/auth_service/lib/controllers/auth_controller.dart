import 'dart:convert';
import 'package:shelf/shelf.dart';
import '../models/register_request.dart';
import '../models/login_request.dart';
import '../models/otp_request.dart';
import '../services/auth_service.dart';
import '../../../shared/lib/skillswapp_shared.dart';

class AuthController {
  final AuthService _authService = AuthService();

  /// POST /register
  Future<Response> register(Request request) async {
    try {
      final body = jsonDecode(await request.readAsString());
      final registerRequest = RegisterRequest.fromJson(body);

      // Validate request
      final errors = registerRequest.validate();
      if (errors.isNotEmpty) {
        return Response.badRequest(
          body: ApiResponse.error(
            message: 'Validation failed',
            errors: {'fields': errors},
          ).toJsonString(),
          headers: {'Content-Type': 'application/json'},
        );
      }

      final result = await _authService.register(registerRequest);

      return Response.ok(
        ApiResponse.success(
          message: result['message'],
          data: {'userId': result['userId'], 'email': result['email']},
        ).toJsonString(),
        headers: {'Content-Type': 'application/json'},
      );
    } on EmailAlreadyExistsException catch (e) {
      return Response(
        409,
        body: ApiResponse.error(message: e.message).toJsonString(),
        headers: {'Content-Type': 'application/json'},
      );
    } on WeakPasswordException catch (e) {
      return Response.badRequest(
        body: ApiResponse.error(message: e.message).toJsonString(),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e, stackTrace) {
      print('❌ Registration error: $e');
      print('Stack trace: $stackTrace');
      return Response.internalServerError(
        body: ApiResponse.error(message: 'Registration failed: ${e.toString()}').toJsonString(),
        headers: {'Content-Type': 'application/json'},
      );
    }
  }

  /// POST /verify-otp
  Future<Response> verifyOTP(Request request) async {
    try {
      final body = jsonDecode(await request.readAsString());
      final otpRequest = OTPRequest.fromJson(body);

      final errors = otpRequest.validate();
      if (errors.isNotEmpty) {
        return Response.badRequest(
          body: ApiResponse.error(
            message: 'Validation failed',
            errors: {'fields': errors},
          ).toJsonString(),
          headers: {'Content-Type': 'application/json'},
        );
      }

      final authResponse = await _authService.verifyOTP(otpRequest);

      return Response.ok(
        ApiResponse.success(
          message: 'Email verified successfully',
          data: authResponse.toJson(),
        ).toJsonString(),
        headers: {'Content-Type': 'application/json'},
      );
    } on InvalidOTPException catch (e) {
      return Response.badRequest(
        body: ApiResponse.error(message: e.message).toJsonString(),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return Response.internalServerError(
        body: ApiResponse.error(message: 'OTP verification failed').toJsonString(),
        headers: {'Content-Type': 'application/json'},
      );
    }
  }

  /// POST /resend-otp
  Future<Response> resendOTP(Request request) async {
    try {
      final body = jsonDecode(await request.readAsString());
      final email = body['email'] as String?;

      if (email == null || email.isEmpty) {
        return Response.badRequest(
          body: ApiResponse.error(message: 'Email is required').toJsonString(),
          headers: {'Content-Type': 'application/json'},
        );
      }

      await _authService.resendOTP(email);

      return Response.ok(
        ApiResponse.success(
          message: 'OTP sent successfully',
        ).toJsonString(),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return Response.internalServerError(
        body: ApiResponse.error(message: 'Failed to resend OTP').toJsonString(),
        headers: {'Content-Type': 'application/json'},
      );
    }
  }

  /// POST /login
  Future<Response> login(Request request) async {
    try {
      final body = jsonDecode(await request.readAsString());
      final loginRequest = LoginRequest.fromJson(body);

      final errors = loginRequest.validate();
      if (errors.isNotEmpty) {
        return Response.badRequest(
          body: ApiResponse.error(
            message: 'Validation failed',
            errors: {'fields': errors},
          ).toJsonString(),
          headers: {'Content-Type': 'application/json'},
        );
      }

      final authResponse = await _authService.login(loginRequest);

      return Response.ok(
        ApiResponse.success(
          message: 'Login successful',
          data: authResponse.toJson(),
        ).toJsonString(),
        headers: {'Content-Type': 'application/json'},
      );
    } on InvalidCredentialsException catch (e) {
      return Response.unauthorized(
        ApiResponse.error(message: e.message).toJsonString(),
        headers: {'Content-Type': 'application/json'},
      );
    } on EmailNotVerifiedException catch (e) {
      return Response(
        403,
        body: ApiResponse.error(message: e.message).toJsonString(),
        headers: {'Content-Type': 'application/json'},
      );
    } on AccountInactiveException catch (e) {
      return Response(
        403,
        body: ApiResponse.error(message: e.message).toJsonString(),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return Response.internalServerError(
        body: ApiResponse.error(message: 'Login failed').toJsonString(),
        headers: {'Content-Type': 'application/json'},
      );
    }
  }

  /// POST /logout
  Future<Response> logout(Request request) async {
    try {
      final authHeader = request.headers['authorization'];
      if (authHeader == null || !authHeader.startsWith('Bearer ')) {
        return Response.unauthorized(
          ApiResponse.error(message: 'Missing authorization header').toJsonString(),
          headers: {'Content-Type': 'application/json'},
        );
      }

      final token = authHeader.substring(7);
      await _authService.logout(token);

      return Response.ok(
        ApiResponse.success(message: 'Logout successful').toJsonString(),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return Response.internalServerError(
        body: ApiResponse.error(message: 'Logout failed').toJsonString(),
        headers: {'Content-Type': 'application/json'},
      );
    }
  }

  /// POST /refresh-token
  Future<Response> refreshToken(Request request) async {
    try {
      final body = jsonDecode(await request.readAsString());
      final refreshToken = body['refreshToken'] as String?;

      if (refreshToken == null || refreshToken.isEmpty) {
        return Response.badRequest(
          body: ApiResponse.error(message: 'Refresh token is required').toJsonString(),
          headers: {'Content-Type': 'application/json'},
        );
      }

      final authResponse = await _authService.refreshToken(refreshToken);

      return Response.ok(
        ApiResponse.success(
          message: 'Token refreshed successfully',
          data: authResponse.toJson(),
        ).toJsonString(),
        headers: {'Content-Type': 'application/json'},
      );
    } on InvalidTokenException catch (e) {
      return Response.unauthorized(
        ApiResponse.error(message: e.message).toJsonString(),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return Response.internalServerError(
        body: ApiResponse.error(message: 'Token refresh failed').toJsonString(),
        headers: {'Content-Type': 'application/json'},
      );
    }
  }

  /// POST /forgot-password
  Future<Response> forgotPassword(Request request) async {
    try {
      final body = jsonDecode(await request.readAsString());
      final email = body['email'] as String?;

      if (email == null || email.isEmpty) {
        return Response.badRequest(
          body: ApiResponse.error(message: 'Email is required').toJsonString(),
          headers: {'Content-Type': 'application/json'},
        );
      }

      await _authService.forgotPassword(email);

      return Response.ok(
        ApiResponse.success(
          message: 'If the email exists, a password reset code has been sent',
        ).toJsonString(),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return Response.internalServerError(
        body: ApiResponse.error(message: 'Failed to process request').toJsonString(),
        headers: {'Content-Type': 'application/json'},
      );
    }
  }

  /// POST /reset-password
  Future<Response> resetPassword(Request request) async {
    try {
      final body = jsonDecode(await request.readAsString());
      final email = body['email'] as String?;
      final otp = body['otp'] as String?;
      final newPassword = body['newPassword'] as String?;

      if (email == null || otp == null || newPassword == null) {
        return Response.badRequest(
          body: ApiResponse.error(
            message: 'Email, OTP, and new password are required',
          ).toJsonString(),
          headers: {'Content-Type': 'application/json'},
        );
      }

      await _authService.resetPassword(
        email: email,
        otp: otp,
        newPassword: newPassword,
      );

      return Response.ok(
        ApiResponse.success(message: 'Password reset successfully').toJsonString(),
        headers: {'Content-Type': 'application/json'},
      );
    } on InvalidOTPException catch (e) {
      return Response.badRequest(
        body: ApiResponse.error(message: e.message).toJsonString(),
        headers: {'Content-Type': 'application/json'},
      );
    } on WeakPasswordException catch (e) {
      return Response.badRequest(
        body: ApiResponse.error(message: e.message).toJsonString(),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return Response.internalServerError(
        body: ApiResponse.error(message: 'Password reset failed').toJsonString(),
        headers: {'Content-Type': 'application/json'},
      );
    }
  }

  /// GET /me
  Future<Response> getCurrentUser(Request request) async {
    try {
      final userId = request.context['userId'] as String?;
      
      if (userId == null) {
        return Response.unauthorized(
          ApiResponse.error(message: 'Unauthorized').toJsonString(),
          headers: {'Content-Type': 'application/json'},
        );
      }

      final user = await _authService.getCurrentUser(userId);

      return Response.ok(
        ApiResponse.success(data: user).toJsonString(),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return Response.internalServerError(
        body: ApiResponse.error(message: 'Failed to get user').toJsonString(),
        headers: {'Content-Type': 'application/json'},
      );
    }
  }
}
