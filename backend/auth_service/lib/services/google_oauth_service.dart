import 'package:http/http.dart' as http;
import 'dart:convert';
import '../repositories/auth_repository.dart';
import '../../../shared/lib/skillswapp_shared.dart';

class GoogleOAuthService {
  final AuthRepository _repository = AuthRepository();

  // Google's token info endpoint
  static const String _tokenInfoUrl = 'https://oauth2.googleapis.com/tokeninfo';

  /// Verify Google ID token and extract user information
  Future<Map<String, dynamic>> verifyGoogleToken(String idToken) async {
    try {
      // Verify token with Google
      final response = await http.get(
        Uri.parse('$_tokenInfoUrl?id_token=$idToken'),
      );

      if (response.statusCode != 200) {
        throw Exception('Invalid Google token');
      }

      final tokenInfo = json.decode(response.body) as Map<String, dynamic>;

      // Verify token is valid
      if (tokenInfo['email_verified'] != 'true' &&
          tokenInfo['email_verified'] != true) {
        throw Exception('Email not verified by Google');
      }

      return tokenInfo;
    } catch (e) {
      throw Exception('Failed to verify Google token: $e');
    }
  }

  /// Authenticate user with Google token
  Future<Map<String, dynamic>> authenticateWithGoogle(String idToken) async {
    // Verify token and get user info
    final googleUserInfo = await verifyGoogleToken(idToken);

    final email = googleUserInfo['email'] as String;
    final firstName = (googleUserInfo['given_name'] as String?) ?? '';
    final lastName = (googleUserInfo['family_name'] as String?) ?? '';

    // Check if user exists
    var user = await _repository.findUserByEmail(email);

    if (user == null) {
      // Create new user (Google users don't have passwords)
      user = await _repository.createUser(
        email: email,
        passwordHash: '', // No password for Google auth users
        firstName: firstName,
        lastName: lastName,
        role: 'student', // Default role
      );

      // Mark as verified (Google users are pre-verified)
      await _repository.markEmailAsVerified(user['id'] as String);

      // Refresh user data to get updated is_verified status
      user = await _repository.findUserById(user['id'] as String);
    }

    // Generate JWT tokens
    final accessToken = JWTUtils.generateAccessToken(
      userId: user!['id'] as String,
      email: user['email'] as String,
      role: user['role'] as String,
    );

    final refreshToken = JWTUtils.generateRefreshToken(
      userId: user['id'] as String,
    );

    // Store session with tokens
    final expiresAt = DateTime.now().add(Duration(hours: 1));
    final refreshExpiresAt = DateTime.now().add(Duration(days: 30));

    await _repository.createSession(
      userId: user['id'] as String,
      accessToken: accessToken,
      refreshToken: refreshToken,
      expiresAt: expiresAt,
      refreshExpiresAt: refreshExpiresAt,
    );

    return {
      'user': {
        'id': user['id'],
        'email': user['email'],
        'firstName': user['first_name'],
        'lastName': user['last_name'],
        'role': user['role'],
        'isVerified': user['is_verified'],
      },
      'accessToken': accessToken,
      'refreshToken': refreshToken,
    };
  }
}
