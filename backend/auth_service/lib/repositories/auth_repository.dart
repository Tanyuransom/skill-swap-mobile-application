import '../../../shared/lib/skillswapp_shared.dart';

class AuthRepository {
  // ==================== PENDING REGISTRATIONS ====================
  
  /// Create pending registration (before OTP verification)
  Future<Map<String, dynamic>> createPendingRegistration({
    required String email,
    required String passwordHash,
    required String firstName,
    required String lastName,
    required String role,
    required String otpCode,
    required DateTime otpExpiresAt,
  }) async {
    final result = await PostgresClient.executeOne(
      '''
      INSERT INTO pending_registrations 
        (email, password_hash, first_name, last_name, role, otp_code, otp_expires_at)
      VALUES (@email, @passwordHash, @firstName, @lastName, @role, @otpCode, @otpExpiresAt)
      RETURNING id, email, first_name, created_at
      ''',
      parameters: {
        'email': email,
        'passwordHash': passwordHash,
        'firstName': firstName,
        'lastName': lastName,
        'role': role,
        'otpCode': otpCode,
        'otpExpiresAt': otpExpiresAt.toIso8601String(),
      },
    );

    if (result == null) {
      throw DatabaseException('Failed to create pending registration');
    }

    return result.toColumnMap();
  }

  /// Find pending registration by email
  Future<Map<String, dynamic>?> findPendingRegistrationByEmail(String email) async {
    final result = await PostgresClient.executeOne(
      'SELECT * FROM pending_registrations WHERE email = @email',
      parameters: {'email': email},
    );

    return result?.toColumnMap();
  }

  /// Verify OTP for pending registration
  Future<Map<String, dynamic>?> verifyPendingRegistrationOTP({
    required String email,
    required String otpCode,
  }) async {
    final result = await PostgresClient.executeOne(
      '''
      SELECT * FROM pending_registrations
      WHERE email = @email
        AND otp_code = @otpCode
        AND otp_expires_at > NOW()
        AND expires_at > NOW()
      ''',
      parameters: {
        'email': email,
        'otpCode': otpCode,
      },
    );

    return result?.toColumnMap();
  }

  /// Delete pending registration after account creation
  Future<void> deletePendingRegistration(String email) async {
    await PostgresClient.execute(
      'DELETE FROM pending_registrations WHERE email = @email',
      parameters: {'email': email},
    );
  }

  /// Update OTP for pending registration (for resend)
  Future<void> updatePendingRegistrationOTP({
    required String email,
    required String otpCode,
    required DateTime otpExpiresAt,
  }) async {
    await PostgresClient.execute(
      '''
      UPDATE pending_registrations 
      SET otp_code = @otpCode, otp_expires_at = @otpExpiresAt
      WHERE email = @email
      ''',
      parameters: {
        'email': email,
        'otpCode': otpCode,
        'otpExpiresAt': otpExpiresAt.toIso8601String(),
      },
    );
  }

  // ==================== USER MANAGEMENT ====================

  /// Create a new user
  Future<Map<String, dynamic>> createUser({
    required String email,
    required String passwordHash,
    required String role,
    required String firstName,
    required String lastName,
  }) async {
    final result = await PostgresClient.executeOne(
      '''
      INSERT INTO users (email, password_hash, role, first_name, last_name)
      VALUES (@email, @passwordHash, @role, @firstName, @lastName)
      RETURNING id, email, role, first_name, last_name, is_verified, is_active, created_at, updated_at
      ''',
      parameters: {
        'email': email,
        'passwordHash': passwordHash,
        'role': role,
        'firstName': firstName,
        'lastName': lastName,
      },
    );

    if (result == null) {
      throw DatabaseException('Failed to create user');
    }

    return result.toColumnMap();
  }

  /// Find user by email
  Future<Map<String, dynamic>?> findUserByEmail(String email) async {
    final result = await PostgresClient.executeOne(
      'SELECT * FROM users WHERE email = @email',
      parameters: {'email': email},
    );

    return result?.toColumnMap();
  }

  /// Find user by ID
  Future<Map<String, dynamic>?> findUserById(String userId) async {
    final result = await PostgresClient.executeOne(
      'SELECT * FROM users WHERE id = @userId',
      parameters: {'userId': userId},
    );

    return result?.toColumnMap();
  }

  /// Update user verification status
  Future<void> markEmailAsVerified(String userId) async {
    await PostgresClient.execute(
      'UPDATE users SET is_verified = true WHERE id = @userId',
      parameters: {'userId': userId},
    );
  }

  /// Create OTP verification record
  Future<void> createOTP({
    required String userId,
    required String email,
    required String otpCode,
    required String purpose,
    required DateTime expiresAt,
  }) async {
    await PostgresClient.execute(
      '''
      INSERT INTO otp_verifications (user_id, email, otp_code, purpose, expires_at)
      VALUES (@userId, @email, @otpCode, @purpose, @expiresAt)
      ''',
      parameters: {
        'userId': userId,
        'email': email,
        'otpCode': otpCode,
        'purpose': purpose,
        'expiresAt': expiresAt.toIso8601String(),
      },
    );
  }

  /// Verify OTP
  Future<Map<String, dynamic>?> verifyOTP({
    required String email,
    required String otpCode,
    required String purpose,
  }) async {
    final result = await PostgresClient.executeOne(
      '''
      SELECT * FROM otp_verifications
      WHERE email = @email
        AND otp_code = @otpCode
        AND purpose = @purpose
        AND is_used = false
        AND expires_at > NOW()
      ORDER BY created_at DESC
      LIMIT 1
      ''',
      parameters: {
        'email': email,
        'otpCode': otpCode,
        'purpose': purpose,
      },
    );

    return result?.toColumnMap();
  }

  /// Mark OTP as used
  Future<void> markOTPAsUsed(String otpId) async {
    await PostgresClient.execute(
      'UPDATE otp_verifications SET is_used = true WHERE id = @otpId',
      parameters: {'otpId': otpId},
    );
  }

  /// Create session
  Future<void> createSession({
    required String userId,
    required String accessToken,
    required String refreshToken,
    required DateTime expiresAt,
    required DateTime refreshExpiresAt,
  }) async {
    await PostgresClient.execute(
      '''
      INSERT INTO sessions (user_id, access_token, refresh_token, expires_at, refresh_expires_at)
      VALUES (@userId, @accessToken, @refreshToken, @expiresAt, @refreshExpiresAt)
      ''',
      parameters: {
        'userId': userId,
        'accessToken': accessToken,
        'refreshToken': refreshToken,
        'expiresAt': expiresAt.toIso8601String(),
        'refreshExpiresAt': refreshExpiresAt.toIso8601String(),
      },
    );
  }

  /// Delete session (logout)
  Future<void> deleteSession(String accessToken) async {
    await PostgresClient.execute(
      'DELETE FROM sessions WHERE access_token = @accessToken',
      parameters: {'accessToken': accessToken},
    );
  }

  /// Find session by refresh token
  Future<Map<String, dynamic>?> findSessionByRefreshToken(
      String refreshToken) async {
    final result = await PostgresClient.executeOne(
      '''
      SELECT * FROM sessions
      WHERE refresh_token = @refreshToken
        AND refresh_expires_at > NOW()
      ''',
      parameters: {'refreshToken': refreshToken},
    );

    return result?.toColumnMap();
  }

  /// Create OAuth provider record
  Future<void> createOAuthProvider({
    required String userId,
    required String provider,
    required String providerUserId,
    String? accessToken,
    String? refreshToken,
  }) async {
    await PostgresClient.execute(
      '''
      INSERT INTO oauth_providers (user_id, provider, provider_user_id, access_token, refresh_token)
      VALUES (@userId, @provider, @providerUserId, @accessToken, @refreshToken)
      ON CONFLICT (provider, provider_user_id)
      DO UPDATE SET access_token = @accessToken, refresh_token = @refreshToken, updated_at = NOW()
      ''',
      parameters: {
        'userId': userId,
        'provider': provider,
        'providerUserId': providerUserId,
        'accessToken': accessToken,
        'refreshToken': refreshToken,
      },
    );
  }

  /// Find user by OAuth provider
  Future<Map<String, dynamic>?> findUserByOAuthProvider({
    required String provider,
    required String providerUserId,
  }) async {
    final result = await PostgresClient.executeOne(
      '''
      SELECT u.* FROM users u
      INNER JOIN oauth_providers op ON u.id = op.user_id
      WHERE op.provider = @provider AND op.provider_user_id = @providerUserId
      ''',
      parameters: {
        'provider': provider,
        'providerUserId': providerUserId,
      },
    );

    return result?.toColumnMap();
  }
}
