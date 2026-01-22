import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:dotenv/dotenv.dart';

class JWTUtils {
  static final DotEnv _env = DotEnv()..load();
  
  static String get _secret => _env['JWT_SECRET'] ?? 'your_secret_key_change_in_production';
  static int get _accessTokenExpiry => int.parse(_env['JWT_EXPIRY'] ?? '3600'); // 1 hour
  static int get _refreshTokenExpiry => int.parse(_env['JWT_REFRESH_EXPIRY'] ?? '604800'); // 7 days

  /// Generate access token
  static String generateAccessToken({
    required String userId,
    required String email,
    required String role,
  }) {
    final jwt = JWT({
      'userId': userId,
      'email': email,
      'role': role,
      'type': 'access',
      'iat': DateTime.now().millisecondsSinceEpoch ~/ 1000,
      'exp': DateTime.now().add(Duration(seconds: _accessTokenExpiry)).millisecondsSinceEpoch ~/ 1000,
    });

    return jwt.sign(SecretKey(_secret), algorithm: JWTAlgorithm.HS256);
  }

  /// Generate refresh token
  static String generateRefreshToken({
    required String userId,
  }) {
    final jwt = JWT({
      'userId': userId,
      'type': 'refresh',
      'iat': DateTime.now().millisecondsSinceEpoch ~/ 1000,
      'exp': DateTime.now().add(Duration(seconds: _refreshTokenExpiry)).millisecondsSinceEpoch ~/ 1000,
    });

    return jwt.sign(SecretKey(_secret), algorithm: JWTAlgorithm.HS256);
  }

  /// Verify and decode token
  static Map<String, dynamic>? verifyToken(String token) {
    try {
      final jwt = JWT.verify(token, SecretKey(_secret));
      return jwt.payload as Map<String, dynamic>;
    } on JWTExpiredException {
      throw Exception('Token has expired');
    } on JWTException catch (e) {
      throw Exception('Invalid token: ${e.message}');
    }
  }

  /// Extract user ID from token
  static String? getUserIdFromToken(String token) {
    try {
      final payload = verifyToken(token);
      return payload?['userId'] as String?;
    } catch (e) {
      return null;
    }
  }

  /// Extract user role from token
  static String? getUserRoleFromToken(String token) {
    try {
      final payload = verifyToken(token);
      return payload?['role'] as String?;
    } catch (e) {
      return null;
    }
  }

  /// Check if token is expired
  static bool isTokenExpired(String token) {
    try {
      verifyToken(token);
      return false;
    } catch (e) {
      return true;
    }
  }

  /// Get token expiry time
  static DateTime? getTokenExpiry(String token) {
    try {
      final payload = verifyToken(token);
      final exp = payload?['exp'] as int?;
      if (exp == null) return null;
      return DateTime.fromMillisecondsSinceEpoch(exp * 1000);
    } catch (e) {
      return null;
    }
  }
}
