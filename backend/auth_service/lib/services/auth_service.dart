import '../models/register_request.dart';
import '../models/login_request.dart';
import '../models/auth_response.dart';
import '../models/otp_request.dart';
import '../repositories/auth_repository.dart';
import '../../../shared/lib/skillswapp_shared.dart';

class AuthService {
  final AuthRepository _repository = AuthRepository();

  /// Register new user (stores in pending_registrations until OTP verified)
  Future<Map<String, dynamic>> register(RegisterRequest request) async {
    // Validate password strength
    if (!HashUtils.isPasswordStrong(request.password)) {
      throw WeakPasswordException(
        HashUtils.getPasswordStrengthMessage(request.password),
      );
    }

    // Check if email already exists in users table
    final existingUser = await _repository.findUserByEmail(request.email);
    if (existingUser != null) {
      throw EmailAlreadyExistsException();
    }

    // Check if there's an existing pending registration
    final existingPending = await _repository.findPendingRegistrationByEmail(request.email);
    if (existingPending != null) {
      // Delete old pending registration
      await _repository.deletePendingRegistration(request.email);
    }

    // Hash password
    final passwordHash = HashUtils.hashPassword(request.password);

    // Generate OTP
    final otp = OTPUtils.generateOTP();
    final expiresAt = OTPUtils.getOTPExpiry();

    // Store in pending_registrations (NOT users table)
    final pendingReg = await _repository.createPendingRegistration(
      email: request.email,
      passwordHash: passwordHash,
      firstName: request.firstName,
      lastName: request.lastName,
      role: request.role,
      otpCode: otp,
      otpExpiresAt: expiresAt,
    );

    // Send OTP email
    await EmailService.sendOTPEmail(
      toEmail: request.email,
      otp: otp,
      userName: request.firstName,
    );

    return {
      'email': pendingReg['email'],
      'message': 'Registration successful. Please check your email for verification code.',
    };
  }

  /// Verify OTP and create user account
  Future<AuthResponse> verifyOTP(OTPRequest request) async {
    // Find and verify OTP in pending_registrations
    final pendingReg = await _repository.verifyPendingRegistrationOTP(
      email: request.email,
      otpCode: request.otp,
    );

    if (pendingReg == null) {
      throw InvalidOTPException();
    }

    // NOW create the actual user account
    final user = await _repository.createUser(
      email: pendingReg['email'],
      passwordHash: pendingReg['password_hash'],
      firstName: pendingReg['first_name'],
      lastName: pendingReg['last_name'],
      role: pendingReg['role'],
    );

    // Mark user as verified immediately (since OTP was validated)
    await _repository.markEmailAsVerified(user['id']);

    // Delete pending registration
    await _repository.deletePendingRegistration(request.email);

    // Generate tokens
    final accessToken = JWTUtils.generateAccessToken(
      userId: user['id'],
      email: user['email'],
      role: user['role'],
    );

    final refreshToken = JWTUtils.generateRefreshToken(
      userId: user['id'],
    );

    // Create session
    await _repository.createSession(
      userId: user['id'],
      accessToken: accessToken,
      refreshToken: refreshToken,
      expiresAt: DateTime.now().add(Duration(hours: 1)),
      refreshExpiresAt: DateTime.now().add(Duration(days: 7)),
    );

    // Send welcome email
    await EmailService.sendWelcomeEmail(
      toEmail: user['email'],
      userName: user['first_name'],
    );

    return AuthResponse(
      accessToken: accessToken,
      refreshToken: refreshToken,
      user: UserModel.fromMap(user).toJson(),
    );
  }

  /// Resend OTP for pending registration
  Future<void> resendOTP(String email) async {
    // Check if there's a pending registration
    final pendingReg = await _repository.findPendingRegistrationByEmail(email);
    
    if (pendingReg == null) {
      // Check if user already exists (already verified)
      final existingUser = await _repository.findUserByEmail(email);
      if (existingUser != null) {
        throw Exception('Email already verified. Please login.');
      }
      throw NotFoundException('No pending registration found for this email');
    }

    // Generate new OTP
    final otp = OTPUtils.generateOTP();
    final expiresAt = OTPUtils.getOTPExpiry();

    // Update OTP in pending registration
    await _repository.updatePendingRegistrationOTP(
      email: email,
      otpCode: otp,
      otpExpiresAt: expiresAt,
    );

    // Send OTP email
    await EmailService.sendOTPEmail(
      toEmail: email,
      otp: otp,
      userName: pendingReg['first_name'],
    );
  }

  /// Login
  Future<AuthResponse> login(LoginRequest request) async {
    // Find user
    final user = await _repository.findUserByEmail(request.email);
    if (user == null) {
      throw InvalidCredentialsException();
    }

    // Verify password
    final isPasswordValid = HashUtils.verifyPassword(
      request.password,
      user['password_hash'],
    );

    if (!isPasswordValid) {
      throw InvalidCredentialsException();
    }

    // Check if email is verified
    if (user['is_verified'] != true) {
      throw EmailNotVerifiedException();
    }

    // Check if account is active
    if (user['is_active'] != true) {
      throw AccountInactiveException();
    }

    // Generate tokens
    final accessToken = JWTUtils.generateAccessToken(
      userId: user['id'],
      email: user['email'],
      role: user['role'],
    );

    final refreshToken = JWTUtils.generateRefreshToken(
      userId: user['id'],
    );

    // Create session
    await _repository.createSession(
      userId: user['id'],
      accessToken: accessToken,
      refreshToken: refreshToken,
      expiresAt: DateTime.now().add(Duration(hours: 1)),
      refreshExpiresAt: DateTime.now().add(Duration(days: 7)),
    );

    return AuthResponse(
      accessToken: accessToken,
      refreshToken: refreshToken,
      user: UserModel.fromMap(user).toJson(),
    );
  }

  /// Logout
  Future<void> logout(String accessToken) async {
    await _repository.deleteSession(accessToken);
  }

  /// Refresh token
  Future<AuthResponse> refreshToken(String refreshToken) async {
    // Find session
    final session = await _repository.findSessionByRefreshToken(refreshToken);
    if (session == null) {
      throw InvalidTokenException();
    }

    // Get user
    final user = await _repository.findUserById(session['user_id']);
    if (user == null) {
      throw NotFoundException('User not found');
    }

    // Generate new tokens
    final newAccessToken = JWTUtils.generateAccessToken(
      userId: user['id'],
      email: user['email'],
      role: user['role'],
    );

    final newRefreshToken = JWTUtils.generateRefreshToken(
      userId: user['id'],
    );

    // Delete old session
    await _repository.deleteSession(session['access_token']);

    // Create new session
    await _repository.createSession(
      userId: user['id'],
      accessToken: newAccessToken,
      refreshToken: newRefreshToken,
      expiresAt: DateTime.now().add(Duration(hours: 1)),
      refreshExpiresAt: DateTime.now().add(Duration(days: 7)),
    );

    return AuthResponse(
      accessToken: newAccessToken,
      refreshToken: newRefreshToken,
      user: UserModel.fromMap(user).toJson(),
    );
  }

  /// Forgot password
  Future<void> forgotPassword(String email) async {
    final user = await _repository.findUserByEmail(email);
    if (user == null) {
      // Don't reveal if email exists
      return;
    }

    // Generate OTP
    final otp = OTPUtils.generateOTP();
    final expiresAt = OTPUtils.getOTPExpiry();

    // Save OTP
    await _repository.createOTP(
      userId: user['id'],
      email: email,
      otpCode: otp,
      purpose: 'password_reset',
      expiresAt: expiresAt,
    );

    // Send password reset email
    await EmailService.sendPasswordResetEmail(
      toEmail: email,
      otp: otp,
      userName: user['first_name'],
    );
  }

  /// Reset password
  Future<void> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    // Validate password strength
    if (!HashUtils.isPasswordStrong(newPassword)) {
      throw WeakPasswordException(
        HashUtils.getPasswordStrengthMessage(newPassword),
      );
    }

    // Verify OTP
    final otpRecord = await _repository.verifyOTP(
      email: email,
      otpCode: otp,
      purpose: 'password_reset',
    );

    if (otpRecord == null) {
      throw InvalidOTPException();
    }

    // Mark OTP as used
    await _repository.markOTPAsUsed(otpRecord['id']);

    // Hash new password
    final passwordHash = HashUtils.hashPassword(newPassword);

    // Update password
    await PostgresClient.execute(
      'UPDATE users SET password_hash = @passwordHash WHERE id = @userId',
      parameters: {
        'passwordHash': passwordHash,
        'userId': otpRecord['user_id'],
      },
    );
  }

  /// Get current user
  Future<Map<String, dynamic>> getCurrentUser(String userId) async {
    final user = await _repository.findUserById(userId);
    if (user == null) {
      throw NotFoundException('User not found');
    }

    return UserModel.fromMap(user).toJson();
  }
}
